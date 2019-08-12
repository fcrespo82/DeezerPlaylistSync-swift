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
      .flag(name: "include-tracks", short: "t"),
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

    let playlists_a = Set(try client_a.playlists())
    let playlists_b = Set(try client_b.playlists())

    context.console.print("\nPlaylists from \(user_a)")
    let only_in_a = playlists_a.subtracting(playlists_b).sorted()
    only_in_a.map { playlist in
      context.console.print(playlist.title)
    }
    context.console.print("\nPlaylists from \(user_b)")
    let only_in_b = playlists_b.subtracting(playlists_a).sorted()
    only_in_b.map { playlist in
      context.console.print(playlist.title)
    }

    let in_both = playlists_a.intersection(playlists_b).sorted()
    context.console.print("\nIn both")

    // print("\("teste", width: 10)")
    // print(FormattedString(string: "teste").width(10).rightJ().formatted)

    // Mostra
    print("\(user_a) - \(user_b)")
    zipToLongest(only_in_a, only_in_b, firstFillValue: nil, secondFillValue: nil).map { pl in
      let title_a = pl.0?.title
      let title_b = pl.1?.title
      print("\(title_a ?? "") - \(title_b ?? "")")

      // guard let title_b = pl.1?.title else { return }

      // let a = playlists_a.first { pl in
      //   pl.title == playlist.title
      // }
      // let b = playlists_b.first { pl in
      //   pl.title == playlist.title
      // }
      // print("\(playlist.title.padding(toLength: 40, withPad: " ", startingAt: 0)) \t - \(user_a): \(String(format: "%03d", a!.nb_tracks)) tracks \t- \(user_b): \(String(format: "%03d", b!.nb_tracks)) tracks")
    }

    return .done(on: context.container)
  }
}