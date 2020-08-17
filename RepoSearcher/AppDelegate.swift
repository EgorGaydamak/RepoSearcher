import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: searchViewController)
        SearchConfigurator.configureScene(around: searchViewController)

        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

