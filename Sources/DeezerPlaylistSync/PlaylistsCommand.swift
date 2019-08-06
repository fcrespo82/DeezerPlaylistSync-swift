import Command
import Foundation

struct PlaylistsCommand: Command {
  var arguments: [CommandArgument] {
    return [
      .argument(name: "user"),
    ]
  }

  var options: [CommandOption] {
    return [
      .flag(name: "verbose", short: "v"),
    ]
  }

  var help: [String] {
    return ["Lists playlists from user"]
  }

  func run(using context: CommandContext) throws -> Future<Void> {
    let user = try context.argument("user")
    let verbose = context.options["verbose"] ?? "false"

    guard let token = DeezerToken.forUser(user) else {
      print("Cannot find token for \(user)")
      exit(1)
    }
    let client = DeezerClient(withToken: token)

    context.console.print("\nPlaylists from \(user)")
    _ = try client.playlists().map { playlist in
      print("\(playlist.title) \t - \(playlist.nb_tracks) tracks")
    }

    return .done(on: context.container)
  }
}