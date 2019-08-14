import Command
import Foundation

struct TracksCommand: Command {
  var arguments: [CommandArgument] {
    return [
      .argument(name: "user", help: ["User"]),
      .argument(name: "playlists", help: ["Playlists to show tracks from"]),
    ]
  }

  var options: [CommandOption] {
    return [
      .flag(name: "verbose", short: "v", help: ["Show more details"]),
    ]
  }

  var help: [String] {
    return ["Lists tracks from playlists from user"]
  }

  func run(using context: CommandContext) throws -> Future<Void> {
    let user = try context.argument("user")
    let playlists = try context.argument("playlists")
    let verbose = Bool(context.options["verbose"] ?? "false")!

    guard let token = DeezerToken.forUser(user) else {
      print("Cannot find token for \(user)")
      exit(1)
    }
    let client = DeezerClient(withToken: token)

    context.console.print(context.console.centered(" User: \(user) ", padding: "="))

    _ = playlists.components(separatedBy: ",").compactMap { playlist in
      context.console.print(context.console.centered(" Playlist: \(playlist) ", padding: "-"))
      _ = client.tracks(fromPlaylistNamed: playlist).compactMap { track in
        context.console.print(track.title)
      }
    }
    context.console.print(context.console.centered("", padding: "="))

    return .done(on: context.container)
  }
}