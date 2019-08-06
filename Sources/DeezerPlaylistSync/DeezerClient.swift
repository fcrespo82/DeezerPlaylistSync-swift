import Cocoa
import Foundation
import Swifter

enum DeezerError: Error {
    case failedToDecodeData
    case failedToInitialize
    case UserNotLogged
    case NotSetupCorrectly
}

class DeezerClient {
    fileprivate var logged = false
    var user: String?
    var appId: String?
    var secret: String?
    var redirectUri: String?
    var permissions: [DeezerPermission]?
    var token: String?
    var shouldKeepRunning = true

    init(withUser user: String?, appId: String?, secret: String?, redirectUri: String = "http://localhost:8000", permissions: [DeezerPermission]) {
        self.user = user
        self.appId = appId
        self.secret = secret
        self.redirectUri = redirectUri
        self.permissions = permissions
    }

    init(withToken token: DeezerToken) {
        self.token = token.access_token
        logged = true
    }

    private func request(_ endpoint: DeezerEndpoint, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: endpoint.url) { data, _, err in
            if err != nil {
                // ERRO
                print(err as Any)
                return
            }
            completion(data)
        }.resume()
    }

    private func requestPost<D:Encodable>(_ endpoint: DeezerEndpoint, data: D, completion: @escaping (Data?) -> Void) {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let uploadData = try? JSONEncoder().encode(data) else {
            return
        }
        URLSession.shared.uploadTask(with: request, from: uploadData) { data, _, err in
            if err != nil {
                // ERRO
                print(err as Any)
                return
            }
            completion(data)
        }.resume()
    }

    func listen(_ callback: @escaping (String) -> Void) {
        let server = HttpServer()
        server["/"] = { request in
            let code = request.queryParams[0].1
            callback(code)
            return HttpResponse.ok(.htmlBody("You can now close this window!"))
        }
        do {
            try server.start(8000)
            while shouldKeepRunning, RunLoop.current.run(mode: .default, before: Date.distantFuture) {}
        } catch {
            print("\(error)")
        }
    }

    func authorize() throws {
        // let permissions = (self.permissions?.map { (permission) -> String in
        //     permission.rawValue
        // }.joined(separator: ","))!

        guard let appId = self.appId, let redirectUri = self.redirectUri, let secret = self.secret, let permissions = self.permissions else { throw DeezerError.NotSetupCorrectly }

        // print("https://connect.deezer.com/oauth/auth.php?app_id=\(appId)&redirect_uri=\(redirectUri)&perms=\(permissions)")
        let endpoint = DeezerEndpoint.auth(app_id: appId, redirect_uri: redirectUri, permissions: permissions)
        // let url = URL(string: "https://connect.deezer.com/oauth/auth.php?app_id=\(appId)&redirect_uri=\(redirectUri)&perms=\(permissions)")!

        NSWorkspace.shared.open(endpoint.url)

        listen { code in
            print("After Listen \(code)")
            let url2 = URL(string: "https://connect.deezer.com/oauth/access_token.php?app_id=\(appId)&secret=\(secret)&code=\(code)&output=json")!
            URLSession.shared.dataTask(with: url2) { data, _, _ in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    var deezerData = try decoder.decode(DeezerToken.self, from: data)
                    deezerData.name = self.user

                    let tokensPath = URL(fileURLWithPath: "./token.json")

                    var tokenList = try decoder.decode([DeezerToken].self, from: Data(contentsOf: tokensPath, options: .mappedIfSafe))

                    if !tokenList.contains(deezerData) {
                        tokenList.append(deezerData)
                    }

                    if let encodedData = try? JSONEncoder().encode(tokenList) {
                        do {
                            try encodedData.write(to: tokensPath)
                        } catch {
                            print("Failed to write JSON data: \(error.localizedDescription)")
                        }
                    }
                    // Salvar token em algum arquivo
                } catch let err {
                    print("Err", err)
                }
                DispatchQueue.main.async {
                    self.shouldKeepRunning = false
                }
                self.logged = true
            }.resume()
        }
    }

    func playlists(user: DeezerUser = DeezerUser.Me) throws -> [DeezerResponse.Playlist] {
        let sem = DispatchSemaphore(value: 0)
        var result: [DeezerResponse.Playlist]?
        guard logged else {
            throw DeezerError.UserNotLogged
        }
        let endpoint = DeezerEndpoint.playlists(user: user, token: token!)

        request(endpoint) { data in
            guard let parsed = try? JSONDecoder().decode(DeezerResponse.List<DeezerResponse.Playlist>.self, from: data!) else {
                print("Error: Couldn't decode data:")
                return
            }
            result = parsed.data
            sem.signal()
        }
        _ = sem.wait(timeout: .now() + 10.0)
        return result!
    }

    func playlist(named playlist: String, user: DeezerUser = DeezerUser.Me) throws -> DeezerResponse.Playlist? {
        return try playlists(user: user).filter { $0.title == playlist }.first
    }

    func tracks(from playlist: DeezerResponse.Playlist) -> [DeezerResponse.Track] {
        let sem = DispatchSemaphore(value: 0)
        var result: [DeezerResponse.Track]?
        let endpoint = DeezerEndpoint.tracks(from: playlist, token: token!)
        request(endpoint) { data in
            // print(String(data:data!, encoding: .utf8))
            guard let parsed = try? JSONDecoder().decode(DeezerResponse.List<DeezerResponse.Track>.self, from: data!) else {
                print("Error: Couldn't decode data:")
                return
            }
            result = parsed.data
            sem.signal()
        }
        _ = sem.wait(timeout: .now() + 10.0)
        return result!
    }

    func addTracks(to playlist: DeezerResponse.Playlist, tracks: [DeezerResponse.Track]) {
        let sem = DispatchSemaphore(value: 0)
        // var playlist: DeezerResponse.Playlist?
        // let endpoint = DeezerEndpoint.playlist(from: playlist.id, token: token!)
        let tracksEndpoint = DeezerEndpoint.playlist(from: playlist, token: token!)
        
        requestPost(tracksEndpoint, data: tracks) { _ in
            sem.signal()
        }
        _ = sem.wait(timeout: .now() + 10.0)
    }

    func createPlaylist(title: String, is_public: Bool=false){
        let endpoint = DeezerEndpoint.playlists(user: .Me, token: token!)
        // Dictionary() Create a json with title and public 
        requestPost(endpoint, data: data) { data in

        }
            
        // return resp
    }
}

enum DeezerUser {
    case Me
    case User(name: String)
}

enum DeezerPermission: String {
    case BasicAccess = "basic_access"
    case Email = "email"
    case OfflineAccess = "offline_access"
    case ManageLibrary = "manage_library"
    case DeleteLibrary = "delete_library"
}