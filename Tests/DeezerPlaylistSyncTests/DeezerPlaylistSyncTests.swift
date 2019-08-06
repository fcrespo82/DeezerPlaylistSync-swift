import class Foundation.Bundle
import XCTest
import class DeezerPlaylistSync.DeezerToken

final class DeezerPlaylistSyncTests: XCTestCase {
  func loadToken() throws {
    let name = "fernando"
    let token = DeezerToken.forUser(name)
    // guard let token = token else {
    //   print("Cannot find token for \(name)")
    //   exit(1)
    // }
    XCTAssertNotNil(token, "Token should be loaded")
  }

  /// Returns path to the built products directory.
  var productsDirectory: URL {
    #if os(macOS)
      for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
        return bundle.bundleURL.deletingLastPathComponent()
      }
      fatalError("couldn't find the products directory")
    #else
      return Bundle.main.bundleURL
    #endif
  }

  static var allTests = [
    ("loadToken", loadToken),
  ]
}