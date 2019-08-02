import Foundation

struct DeezerToken: Codable, Equatable {
	var name: String?
	let access_token: String?
	let expires: Int?

	private enum CodingKeys: String, CodingKey {
		case name
		case access_token
		case expires
	}

	static func forUser(_ user: String, in file: String = "./token.json") -> DeezerToken? {
		let users = readJson(path: file)
		return users.first { (token) -> Bool in
			token.name == user
		}
	}

	fileprivate static func readJson(path: String) -> [DeezerToken] {
		let tokenJson = URL(fileURLWithPath: path)
		let data = try! Data(contentsOf: tokenJson)
		guard let tokens = try? JSONDecoder().decode([DeezerToken].self, from: data) else {
			print("Error: Couldn't decode data")
			return []
		}
		return tokens
	}
}