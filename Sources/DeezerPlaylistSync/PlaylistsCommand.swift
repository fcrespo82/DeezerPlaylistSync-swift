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
    context.console.print("teste \(user) \(verbose)")

    return .done(on: context.container)
  }
}