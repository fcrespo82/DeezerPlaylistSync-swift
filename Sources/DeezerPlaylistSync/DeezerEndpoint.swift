import Foundation

struct DeezerEndpoint {
	let host: String
	let path: String
	let queryItems: [URLQueryItem]?
	static func auth(app_id: String, redirect_uri: String, permissions: [DeezerPermission]) -> DeezerEndpoint {
		let permissions = (permissions.map { (permission) -> String in
			permission.rawValue
		}.joined(separator: ","))

		return DeezerEndpoint(host: "connect.deezer.com", path: "/oauth/auth.php", queryItems: [
			URLQueryItem(name: "app_id", value: app_id),
			URLQueryItem(name: "redirect_uri", value: redirect_uri),
			URLQueryItem(name: "perms", value: permissions),
			URLQueryItem(name: "output", value: "json"),
		])
	}

	static func token(app_id _: String, secret: String, code: String) -> DeezerEndpoint {
		return DeezerEndpoint(host: "connect.deezer.com", path: "/oauth/access_token.php", queryItems: [
			URLQueryItem(name: "secret", value: secret),
			URLQueryItem(name: "code", value: code),
			URLQueryItem(name: "output", value: "json"),
		])
	}

	static func playlists(user: DeezerUser, token: String) -> DeezerEndpoint {
		let username: String
		switch user {
		case .Me:
			username = "me"
		case let .User(name):
			username = name
		}
		return DeezerEndpoint(host: "api.deezer.com", path: "/user/\(username)/playlists/", queryItems: [
			URLQueryItem(name: "access_token", value: token),
			URLQueryItem(name: "output", value: "json"),
		])
	}

	static func playlist(id: Int, token: String) -> DeezerEndpoint {
		return DeezerEndpoint(host: "api.deezer.com", path: "/user/playlist/\(id)", queryItems: [
			URLQueryItem(name: "access_token", value: token),
			URLQueryItem(name: "output", value: "json"),
		])
	}

	static func playlist(from playlist: DeezerResponse.Playlist, token: String) -> DeezerEndpoint {
		return DeezerEndpoint(host: "api.deezer.com", path: "/user/playlist/\(playlist.id)", queryItems: [
			URLQueryItem(name: "access_token", value: token),
			URLQueryItem(name: "output", value: "json"),
		])
	}
	static func tracks(from playlist: DeezerResponse.Playlist, token: String) -> DeezerEndpoint {
		return DeezerEndpoint(host: "api.deezer.com", path: "/playlist/\(playlist.id)/tracks", queryItems: [
			URLQueryItem(name: "access_token", value: token),
			URLQueryItem(name: "output", value: "json"),
		])
	}

	var url: URL {
		var components = URLComponents()
		components.scheme = "https"
		components.host = host
		components.path = path
		components.queryItems = queryItems

		return components.url!
	}
}