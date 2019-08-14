import Command
import Foundation

struct AuthorizationCommand: Command {
  var arguments: [CommandArgument] {
    return [
      .argument(name: "user", help: ["User to authorizate"]),
      .argument(name: "appId", help: ["AppId"]),
      .argument(name: "secret", help: ["Secret"]),
    ]
  }

  var options: [CommandOption] {
    return [
      // .value(name: "redirectUri", default: "http://localhost:8080", help: ["User to authorizate"]),
      .value(name: "permissions", default: "basic_access", help: ["User to authorizate"]),
      .flag(name: "verbose", short: "v", help: ["Show more details"]),
    ]
  }

  var help: [String] {
    return ["Authorize this aplication to act on behalf of the user"]
  }

  func run(using context: CommandContext) throws -> Future<Void> {
    let user = try context.argument("user")
    let appId = try context.argument("appId")
    let secret = try context.argument("secret")
    let redirectUri = "http://localhost:8000" //context.options["redirectUri"] ?? "http://localhost:8000"
    let permissions = context.options["permissions"] ?? "basic_access"
    let verbose = Bool(context.options["verbose"] ?? "false")!

    let perms = permissions.split(separator: ",").compactMap { p in
      DeezerPermission(rawValue: "\(p)")
    }

    let client = DeezerClient(withUser: user, appId: appId, secret: secret, redirectUri: redirectUri, permissions: perms)

    try client.authorize()

    return .done(on: context.container)
  }
}