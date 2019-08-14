import Foundation

import Command
import Console

let container = BasicContainer(config: Config(), environment: Environment.production, services: Services(), on: EmbeddedEventLoop())

var commandConfig = CommandConfig()
commandConfig.use(AuthorizationCommand(), as: "authorize", isDefault: false)
commandConfig.use(CompareCommand(), as: "compare", isDefault: false)
commandConfig.use(CompareTracksCommand(), as: "compare_tracks", isDefault: false)
commandConfig.use(PlaylistsCommand(), as: "playlists", isDefault: false)
container.services.register(commandConfig)

let group = try commandConfig.resolve(for: container).group()

var commandInput = CommandInput(arguments: CommandLine.arguments)
let terminal = Terminal()
do {
	try terminal.run(group, input: &commandInput, on: container).wait()
} catch let error as ConsoleError {
	print(error)
}