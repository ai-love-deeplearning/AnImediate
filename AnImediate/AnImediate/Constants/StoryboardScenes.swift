// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit
import MXParallaxHeader

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum AnimeDetails: StoryboardType {
    internal static let storyboardName = "AnimeDetails"

    internal static let initialScene = InitialSceneType<MXScrollViewController>(storyboard: AnimeDetails.self)

    internal static let animeDetail = SceneType<AnimeDetailTopVC>(storyboard: AnimeDetails.self, identifier: "animeDetail")

    internal static let episodes = SceneType<AnimeDetailEpisodesVC>(storyboard: AnimeDetails.self, identifier: "episodes")

    internal static let info = SceneType<AnimeDetailInfoVC>(storyboard: AnimeDetails.self, identifier: "info")

    internal static let reviews = SceneType<UIKit.UIViewController>(storyboard: AnimeDetails.self, identifier: "reviews")

    internal static let rinks = SceneType<UIKit.UIViewController>(storyboard: AnimeDetails.self, identifier: "rinks")
  }
  internal enum AnimeList: StoryboardType {
    internal static let storyboardName = "AnimeList"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: AnimeList.self)
  }
  internal enum AnimeListTable: StoryboardType {
    internal static let storyboardName = "AnimeListTable"

    internal static let initialScene = InitialSceneType<AnimeListTableVC>(storyboard: AnimeListTable.self)
  }
  internal enum ExchangeAccept: StoryboardType {
    internal static let storyboardName = "ExchangeAccept"

    internal static let initialScene = InitialSceneType<ExchangeAcceptVC>(storyboard: ExchangeAccept.self)
  }
  internal enum ExchangeSearch: StoryboardType {
    internal static let storyboardName = "ExchangeSearch"

    internal static let initialScene = InitialSceneType<ExchangeSearchVC>(storyboard: ExchangeSearch.self)
  }
  internal enum Home: StoryboardType {
    internal static let storyboardName = "Home"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Home.self)

    internal static let homeArchiveListSB = SceneType<HomeArchiveListVC>(storyboard: Home.self, identifier: "HomeArchiveListSB")

    internal static let notSeeSB = SceneType<HomeNotSeeVC>(storyboard: Home.self, identifier: "notSeeSB")

    internal static let sawSB = SceneType<HomeSawVC>(storyboard: Home.self, identifier: "sawSB")

    internal static let seeingSB = SceneType<HomeSeeingVC>(storyboard: Home.self, identifier: "seeingSB")

    internal static let willSeeSB = SceneType<HomeWillSeeVC>(storyboard: Home.self, identifier: "willSeeSB")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Login: StoryboardType {
    internal static let storyboardName = "Login"

    internal static let initialScene = InitialSceneType<LoginVC>(storyboard: Login.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<UIKit.UITabBarController>(storyboard: Main.self)
  }
  internal enum ProfileEdit: StoryboardType {
    internal static let storyboardName = "ProfileEdit"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: ProfileEdit.self)

    internal static let navigationController = SceneType<UIKit.UINavigationController>(storyboard: ProfileEdit.self, identifier: "NavigationController")
  }
  internal enum Result: StoryboardType {
    internal static let storyboardName = "Result"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Result.self)

    internal static let both = SceneType<ResultBothCardVC>(storyboard: Result.self, identifier: "both")

    internal static let me = SceneType<ResultMeCardVC>(storyboard: Result.self, identifier: "me")

    internal static let recomm = SceneType<ResultRecommCardVC>(storyboard: Result.self, identifier: "recomm")

    internal static let you = SceneType<ResultYouCardVC>(storyboard: Result.self, identifier: "you")
  }
  internal enum Search: StoryboardType {
    internal static let storyboardName = "Search"

    internal static let initialScene = InitialSceneType<SearchVC>(storyboard: Search.self)

    internal static let broadcast = SceneType<BroadcastTableVC>(storyboard: Search.self, identifier: "broadcast")

    internal static let genre = SceneType<UIKit.UIViewController>(storyboard: Search.self, identifier: "genre")

    internal static let property = SceneType<UIKit.UIViewController>(storyboard: Search.self, identifier: "property")

    internal static let title = SceneType<SearchTitleVC>(storyboard: Search.self, identifier: "title")
  }
  internal enum SearchResult: StoryboardType {
    internal static let storyboardName = "SearchResult"
  }
  internal enum Setting: StoryboardType {
    internal static let storyboardName = "Setting"

    internal static let initialScene = InitialSceneType<UIKit.UINavigationController>(storyboard: Setting.self)
  }
  internal enum SettingText: StoryboardType {
    internal static let storyboardName = "SettingText"

    internal static let initialScene = InitialSceneType<SettingTextVC>(storyboard: SettingText.self)
  }
  internal enum SignUp: StoryboardType {
    internal static let storyboardName = "SignUp"

    internal static let initialScene = InitialSceneType<SignUpVC>(storyboard: SignUp.self)
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
