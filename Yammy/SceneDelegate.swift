import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let isSocialLoggedIn = UserDefaults.standard.bool(forKey: "isSocialLogin")
        let isFirebaseLoggedIn = Auth.auth().currentUser != nil
        
        if isFirebaseLoggedIn || isSocialLoggedIn {
            let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBar")
            window?.rootViewController = homeVC
        } else {
            if let initialVC = storyboard.instantiateInitialViewController() {
                window?.rootViewController = initialVC
            } else {
                let loginVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
                window?.rootViewController = loginVC
            }
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

