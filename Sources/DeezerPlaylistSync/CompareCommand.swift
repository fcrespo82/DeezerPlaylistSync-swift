import Command
import Foundation

struct CompareCommand: Command {
  var arguments: [CommandArgument] {
    return [
      .argument(name: "user_a", help: ["User A that will be compared"]),
      .argument(name: "user_b", help: ["User B that will be compared"]),
    ]
  }

  var options: [CommandOption] {
    return [
      .flag(name: "show-from-both", short: "b", help: ["Show what is common to both users"]),
      .flag(name: "include-tracks", short: "t", help: ["Include tracks in comparison"]),
      .flag(name: "verbose", short: "v", help: ["Show more details"]),
    ]
  }

  var help: [String] {
    return ["Comparision between users"]
  }

  func run(using context: CommandContext) throws -> Future<Void> {
    let user_a = try context.argument("user_a")
    let user_b = try context.argument("user_b")
    let show_from_both = Bool(context.options["show-from-both"] ?? "false")!

    guard let token_a = DeezerToken.forUser(user_a) else {
      print("Cannot find token for \(user_a)")
      exit(1)
    }
    let client_a = DeezerClient(withToken: token_a)

    guard let token_b = DeezerToken.forUser(user_b) else {
      print("Cannot find token for \(user_b)")
      exit(1)
    }
    let client_b = DeezerClient(withToken: token_b)

    context.console.print(context.console.centered("Comparing \(user_a) to \(user_b)", padding: "="))

    let playlists_a = try client_a.playlists()
    let playlists_b = try client_b.playlists()
    let only_in_a = playlists_a.subtracting(playlists_b).sorted()
    let only_in_b = playlists_b.subtracting(playlists_a).sorted()
    let in_both = playlists_a.intersection(playlists_b).sorted()

    context.console.print(context.console.two_columns(leftString: user_a, leftFormatter: context.console.halfCentered, rightString: user_b, rightFormatter: context.console.halfCentered, padding: "-"))
    _ = zipToLongest(only_in_a, only_in_b, firstFillValue: nil, secondFillValue: nil).map { pl in
      let title_a = pl.0?.title ?? ""
      let title_b = pl.1?.title ?? ""
      context.console.print(context.console.two_columns(leftString: title_a, leftFormatter: context.console.halfLeft, rightString: title_b, rightFormatter: context.console.halfLeft))
    }

    if show_from_both {
      context.console.print(context.console.centered("Playlists in both users", padding: "="))

      _ = in_both.map { playlist in
        context.console.print(playlist.title)
      }
    }
    context.console.print(context.console.centered("", padding: "="))
    return .done(on: context.container)
  }
}