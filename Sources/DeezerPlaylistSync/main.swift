import Foundation

// import Console
// import Command

// let container = BasicContainer(config: Config(), environment: Environment.production, services: Services(), on: EmbeddedEventLoop())

// var commandConfig = CommandConfig()
// commandConfig.use(BatteryCommand(), as: "batt", isDefault: false)
// container.services.register(commandConfig)

// let group = try commandConfig.resolve(for: container).group()

// var commandInput = CommandInput(arguments: CommandLine.arguments)
// let terminal = Terminal()
// try terminal.run(group, input: &commandInput, on: container).wait()

// let client = DeezerClient(withUser: "fernando", appId: "265942", secret: "08939a8ec75721493eed20579b4a6500", permissions: [.BasicAccess, .ManageLibrary])

let name = "fernando"
let token = DeezerToken.forUser(name)
guard let token = token else {
	print("Cannot find token for \(name)")
	exit(1)
}

let client = DeezerClient(withToken: token)

do {
	// try client.authorize()

	let pls = try client.playlists()

	_ = pls.map { pl in
		print("The playlist \(pl.title) has \(pl.nb_tracks) tracks")
	}
	// let pl = try client.playlist(named: "Mai")

	// print(pl?.nb_tracks)
	exit(0)
} catch {
	print("Unexpected error: \(error).")
}

dispatchMain()