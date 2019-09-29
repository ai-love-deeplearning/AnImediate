// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import AppModel
import Foundation
import Swinject
import SwinjectStoryboard

final class ProfileEditViewControllerInjecter {
    class func setup(container: Container) {
        container.register(ModuleActionCreatable.self) { r in
            ModuleActionCreator(connector: r.resolve(Mdulable.self)!)
        }

        container.register(Example1ActionCreatable.self) { r in
            Example1ActionCreator(connector: r.resolve(Mdulable.self)!)
        }

        container.register(Example2ActionCreatable.self) { r in
            Example2ActionCreator(connector: r.resolve(Mdulable.self)!)
        }

        container.storyboardInitCompleted(ProfileEditVC.self) { r, c in
            c.inject(ModuleActionCreator: r.resolve(ModuleActionCreatable.self)!, Example1ActionCreator: r.resolve(Example1ActionCreatable.self)!, Example2ActionCreator: r.resolve(Example2ActionCreatable.self)!)
        }
    }
}
