import Command
import Foundation

struct CompareCommand: Command {
  var arguments: [CommandArgument] {
    return [
      .argument(name: "user_a"),
      .argument(name: "user_b"),
    ]
  }

  var options: [CommandOption] {
    return [
      .flag(name: "playlist", short: "p"),
      .flag(name: "verbose", short: "v"),
    ]
  }

  var help: [String] {
    return ["Compare between users"]
  }

  func run(using context: CommandContext) throws -> Future<Void> {
    let user_a = try context.argument("user_a")
    // let token_a = DeezerToken.forUser(user_a)
    guard let token_a = DeezerToken.forUser(user_a) else {
      print("Cannot find token for \(user_a)")
      exit(1)
    }
    let client_a = DeezerClient(withToken: token_a)

    let user_b = try context.argument("user_b")
    // let token_b = DeezerToken.forUser(user_b)
    guard let token_b = DeezerToken.forUser(user_b) else {
      print("Cannot find token for \(user_b)")
      exit(1)
    }
    let client_b = DeezerClient(withToken: token_b)

    let verbose = context.options["verbose"] ?? "false"
    context.console.print("Comparing \(user_a) to \(user_b)\n")

    context.console.print("\nPlaylists from \(user_a)")
    _ = try client_a.playlists().map { playlist in
      print("\(playlist.title) \t - \(playlist.nb_tracks) tracks")
    }

    context.console.print("\nPlaylists from \(user_b)")
    _ = try client_b.playlists().map { playlist in
      print("\(playlist.title) \t - \(playlist.nb_tracks) tracks")
    }
    return .done(on: context.container)
  }
}