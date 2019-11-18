// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Segues

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardSegue {
  internal enum AnimeDetails: String, SegueType {
    case toAinmeDetailsHeader
    case toAnimeDetailsScroll
    case toDetails
    case toSimilar
  }
  internal enum AnimeList: String, SegueType {
    case fromRank
    case fromThisTerm
    case toDetails
  }
  internal enum AnimeListTable: String, SegueType {
    case toDetails
  }
  internal enum Exchange: String, SegueType {
    case toResult
    case toSearch
  }
  internal enum ExchangeResult: String, SegueType {
    case toContent
    case toHead
  }
  internal enum ExchangeSearch: String, SegueType {
    case toNotFound
    case toPopUpModal
  }
  internal enum Home: String, SegueType {
    case toContent
    case toDetails
    case toHead
  }
  internal enum Launch: String, SegueType {
    case toLogin
    case toMain
  }
  internal enum Login: String, SegueType {
    case loginToMain
  }
  internal enum Search: String, SegueType {
    case toAnimeListTable
    case toDetails
  }
  internal enum Setting: String, SegueType {
    case toAccount
    case toLogin
    case toMail
    case toText
  }
  internal enum SignUp: String, SegueType {
    case signUpToHome
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol SegueType: RawRepresentable {}

internal extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }
}

internal extension SegueType where RawValue == String {
  init?(_ segue: UIStoryboardSegue) {
    guard let identifier = segue.identifier else { return nil }
    self.init(rawValue: identifier)
  }
}

private final class BundleToken {}
