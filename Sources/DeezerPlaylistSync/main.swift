import Foundation

import Console
import Command

let container = BasicContainer(config: Config(), environment: Environment.production, services: Services(), on: EmbeddedEventLoop())

var commandConfig = CommandConfig()
commandConfig.use(PlaylistsCommand(), as: "playlists", isDefault: false)
commandConfig.use(CompareCommand(), as: "compare", isDefault: false)
container.services.register(commandConfig)

let group = try commandConfig.resolve(for: container).group()

var commandInput = CommandInput(arguments: CommandLine.arguments)
let terminal = Terminal()
try terminal.run(group, input: &commandInput, on: container).wait()

// let name = "fernando"
// let token = DeezerToken.forUser(name)
// guard let token = token else {
// 	print("Cannot find token for \(name)")
// 	exit(1)
// }

// let name2 = "fernando"
// let token2 = DeezerToken.forUser(name2)
// guard let token2 = token2 else {
// 	print("Cannot find token for \(name2)")
// 	exit(1)
// }

// let client = DeezerClient(withToken: token)
// let client2 = DeezerClient(withToken: token2)

// do {
// 	// try client.authorize()

// 	// let pls = try client.playlists()

// 	// _ = pls.map { pl in
// 	// 	print("The playlist \(pl.title) has \(pl.nb_tracks) tracks")
// 	// }
// 	let pl = try client.playlist(named: "Maia")
// 	let pl2 = try client2.playlist(named: "Maia")

// 	let tracks = client.tracks(from: pl!)
// 	_ = tracks.map { track in
// 		print(track.title as Any)
// 	}
// 	let tracks2 = client2.tracks(from: pl2!)
// 	_ = tracks2.map { track in
// 		print(track.title as Any)
// 	}
// 	exit(0)
// } catch {
// 	print("Unexpected error: \(error).")
// }

// dispatchMain()