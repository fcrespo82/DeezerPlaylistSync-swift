import Command
import Foundation

struct PlaylistsCommand: Command {
  var arguments: [CommandArgument] {
    return [
      .argument(name: "user", help: ["Show playlists from user"]),
    ]
  }

  var options: [CommandOption] {
    return [
      .flag(name: "verbose", short: "v", help: ["Show more details"]),
    ]
  }

  var help: [String] {
    return ["Lists playlists from user"]
  }

  func run(using context: CommandContext) throws -> Future<Void> {
    let user = try context.argument("user")
    let verbose = Bool(context.options["verbose"] ?? "false")!

    guard let token = DeezerToken.forUser(user) else {
      print("Cannot find token for \(user)")
      exit(1)
    }
    let client = DeezerClient(withToken: token)

    context.console.print(context.console.centered("Playlists from \(user)", padding: "="))
    _ = try client.playlists().sorted().map { playlist in
      if verbose {
        context.console.print(context.console.two_columns(leftString: playlist.title, leftFormatter: context.console.halfLeft, rightString: "\(playlist.nb_tracks) tracks", rightFormatter: context.console.halfRight, separator: ""))
      } else {
        context.console.print(context.console.left(playlist.title))
      }
    }

    return .done(on: context.container)
  }
}