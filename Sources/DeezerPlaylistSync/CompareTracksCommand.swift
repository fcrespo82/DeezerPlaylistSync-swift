import Command
import Foundation

struct CompareTracksCommand: Command {
  var arguments: [CommandArgument] {
    return [
      .argument(name: "user_a", help: ["User A that will be compared"]),
      .argument(name: "user_b", help: ["User B that will be compared"]),
      .argument(name: "playlists", help: ["Playlists to compare"]),
    ]
  }

  var options: [CommandOption] {
    return [
      .flag(name: "show-from-both", short: "b", help: ["Show what is common to both users"]),
      // .flag(name: "verbose", short: "v", help: ["Show more details"]),
    ]
  }

  var help: [String] {
    return ["Compare tracks in playlists between users"]
  }

  func run(using context: CommandContext) throws -> Future<Void> {
    let user_a = try context.argument("user_a")
    let user_b = try context.argument("user_b")
    let playlists = try context.argument("playlists")
    let show_from_both = Bool(context.options["show-from-both"] ?? "false")!

    // let verbose = Bool(context.options["verbose"] ?? "false")!

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

    _ = playlists.components(separatedBy: ",").map { playlist in
      let tracks_a = client_a.tracks(fromPlaylistNamed: playlist)
      let tracks_b = client_b.tracks(fromPlaylistNamed: playlist)
      let only_in_a = tracks_a.subtracting(tracks_b).sorted()
      let only_in_b = tracks_b.subtracting(tracks_a).sorted()
      let in_both = tracks_a.intersection(tracks_b).sorted()

      context.console.print(context.console.centered(playlist, padding: "="))
      context.console.print(context.console.two_columns(leftString: user_a, leftFormatter: context.console.halfCentered, rightString: user_b, rightFormatter: context.console.halfCentered, padding: "="))
      _ = zipToLongest(only_in_a, only_in_b, firstFillValue: nil, secondFillValue: nil).map { item in
        var title_a = ""
        var title_b = ""
        if let pl_a = item.0 {
          title_a = pl_a.title
        }
        if let pl_b = item.1 {
          title_b = pl_b.title
        }
        context.console.print(context.console.two_columns(leftString: title_a, leftFormatter: context.console.halfLeft, rightString: title_b, rightFormatter: context.console.halfLeft, padding: " "))
      }

      if show_from_both {
            context.console.print(context.console.centered("In both users", padding: "-"))

        _ = in_both.map { track in
          context.console.print(context.console.left(track.title))
        }
      }
    }

    context.console.print(context.console.centered("", padding: "="))
    return .done(on: context.container)
  }
}