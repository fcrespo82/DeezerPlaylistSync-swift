import Foundation

struct DeezerResponse {
	struct Artist: Codable {
		let id: Int
		let name: String
		let link: String
		let share: String?
		let picture: String?
		let picture_small: String?
		let picture_medium: String?
		let picture_big: String?
		let picture_xl: String?
		let nb_album: Int?
		let nb_fan: Int?
		let radio: Bool?
		let tracklist: String?
		private enum CodingKeys: String, CodingKey {
			case id
			case name
			case link
			case share
			case picture
			case picture_small
			case picture_medium
			case picture_big
			case picture_xl
			case nb_album
			case nb_fan
			case radio
			case tracklist
		}
	}

	struct Genre: Codable {
		let id: Int
		let name: String
		let picture: String?
		let picture_small: String?
		let picture_medium: String?
		let picture_big: String?
		let picture_xl: String?
		private enum CodingKeys: String, CodingKey {
			case id
			case name
			case picture
			case picture_small
			case picture_medium
			case picture_big
			case picture_xl
		}
	}

	struct User: Codable {
		let id: Int
		let name: String
		let lastname: String?
		let firstname: String?
		let email: String?
		let status: Int?
		let birthday: String?
		let inscription_date: String?
		let gender: String?
		let link: String?
		let picture: String?
		let picture_small: String?
		let picture_medium: String?
		let picture_big: String?
		let picture_xl: String?
		let country: String?
		let lang: String?
		let is_kid: Bool?
		let explicit_content_level: String?
		let explicit_content_levels_available: [String]?
		let tracklist: String?

		private enum CodingKeys: String, CodingKey {
			case id
			case name
			case lastname
			case firstname
			case email
			case status
			case birthday
			case inscription_date
			case gender
			case link
			case picture
			case picture_small
			case picture_medium
			case picture_big
			case picture_xl
			case country
			case lang
			case is_kid
			case explicit_content_level
			case explicit_content_levels_available
			case tracklist
		}
	}

	struct Album: Codable {
		let id: Int
		let title: String
		let upc: String?
		let link: String
		let share: String?
		let cover: String?
		let cover_small: String?
		let cover_medium: String?
		let cover_big: String?
		let cover_xl: String?
		let genre_id: Int?
		let genres: [Genre]?
		let label: String?
		let nb_tracks: Int?
		let duration: Int?
		let fans: Int?
		let rating: Int?
		let release_date: String?
		let record_type: String?
		let available: Bool?
		// let alternative: Object?
		let tracklist: String?
		let explicit_lyrics: Bool?
		let explicit_content_lyrics: Int?
		let explicit_content_cover: Int?
		// let contributors: List?
		let artist: Artist?
		let tracks: [Track]?
		private enum CodingKeys: String, CodingKey {
			case id
			case title
			case upc
			case link
			case share
			case cover
			case cover_small
			case cover_medium
			case cover_big
			case cover_xl
			case genre_id
			case genres
			case label
			case nb_tracks
			case duration
			case fans
			case rating
			case release_date
			case record_type
			case available
			// case alternative
			case tracklist
			case explicit_lyrics
			case explicit_content_lyrics
			case explicit_content_cover
			// case contributors
			case artist
			case tracks
		}
	}

	struct Playlist: Codable {
		let id: Int
		let title: String
		let duration: Int
		let is_public: Bool
		let is_loved_track: Bool
		let collaborative: Bool
		let rating: Int?
		let nb_tracks: Int
		let fans: Int
		let link: String
		let picture: String
		let picture_small: String
		let picture_medium: String
		let picture_big: String
		let picture_xl: String
		let checksum: String
		let creation_date: String
		let time_add: Int
		let time_mod: Int
		let creator: User

		private enum CodingKeys: String, CodingKey {
			case id
			case title
			case duration
			case is_public = "public"
			case is_loved_track
			case collaborative
			case rating
			case nb_tracks
			case fans
			case link
			case picture
			case picture_small
			case picture_medium
			case picture_big
			case picture_xl
			case checksum
			case creation_date
			case time_add
			case time_mod
			case creator
		}
	}

	struct Track: Codable {
		let id: Int
		let readable: Bool?
		let title: String
		let title_short: String?
		let title_version: String?
		let unseen: Bool?
		let isrc: String?
		let link: String?
		let share: String?
		let duration: Int?
		let track_position: Int?
		let disk_number: Int?
		let rank: Int?
		let release_date: String?
		let explicit_lyrics: Bool?
		let explicit_content_lyrics: Int?
		let explicit_content_cover: Int?
		let preview: String?
		let bpm: Float?
		let gain: Float?
		let available_countries: [String]?
		// let alternative: Track?
		// let contributors: List?
		// let artist: Object?
		// let album: Object?
		private enum CodingKeys: String, CodingKey {
			case id
			case readable
			case title
			case title_short
			case title_version
			case unseen
			case isrc
			case link
			case share
			case duration
			case track_position
			case disk_number
			case rank
			case release_date
			case explicit_lyrics
			case explicit_content_lyrics
			case explicit_content_cover
			case preview
			case bpm
			case gain
			case available_countries
			// case alternative
			// case contributors
			// case artist
			// case album
		}
	}

	struct List<T: Codable>: Codable {
		let data: [T]
		let checksum: String
		let total: Int
		let next: String?

		func hasNext() -> Bool {
			guard let _ = self.next else {
				return false
			}
			return true
		}

		// private enum CodingKeys: String, CodingKey {
		// 	case data
		// 	case checksum
		// 	case total
		// 	case next
		// }
	}
}

extension DeezerResponse.User: Comparable, Equatable {
	static func < (lhs: DeezerResponse.User, rhs: DeezerResponse.User) -> Bool {
		if lhs.name != rhs.name {
			return lhs.name < rhs.name
		} else {
			return lhs.id < rhs.id
		}
	}

	static func == (lhs: DeezerResponse.User, rhs: DeezerResponse.User) -> Bool {
		return
			lhs.id == rhs.id
	}
}

extension DeezerResponse.User: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

extension DeezerResponse.Playlist: Comparable, Equatable {
	static func < (lhs: DeezerResponse.Playlist, rhs: DeezerResponse.Playlist) -> Bool {
		if lhs.title != rhs.title {
			return lhs.title < rhs.title
		} else {
			return lhs.id < rhs.id
		}
	}

	static func == (lhs: DeezerResponse.Playlist, rhs: DeezerResponse.Playlist) -> Bool {
		return lhs.title == rhs.title || lhs.id == rhs.id
	}
}

extension DeezerResponse.Playlist: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(title)
	}
}