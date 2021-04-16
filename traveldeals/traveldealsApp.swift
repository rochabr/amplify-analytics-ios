//
//  traveldealsApp.swift
//  traveldeals
//
//  Created by Rocha Silva, Fernando on 2021-03-02.
//

import SwiftUI

import Amplify
import AmplifyPlugins
import AWSPinpoint
import UserNotifications


@main
struct traveldealsApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @ObservedObject var sessionManager = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                LoginView()
                    .environmentObject(sessionManager)
            
            case .signUp:
                SignUpView()
                    .environmentObject(sessionManager)
            
            case .confirmCode(let username):
                ConfirmationView(username: username)
                    .environmentObject(sessionManager)
                
            case .session(let user):
                SessionView(user: user)
                    .environmentObject(sessionManager)
            }
        }
    }

    init() {
        
        registerForPushNotifications()
        
        do{
            //Auth
            try Amplify.add(plugin:AWSCognitoAuthPlugin())

            //DataStore
            let models = AmplifyModels()
            let dataStorePlugin = AWSDataStorePlugin(modelRegistration: models)
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: AWSAPIPlugin())
            
            //analytics
            try Amplify.add(plugin: AWSPinpointAnalyticsPlugin())
            
            //configure plugins
            try Amplify.configure()
            print("Amplify succesfully configured")
        } catch {
            print("could not initialize amplify", error)
        }
        
        //gets current authenticated user
        sessionManager.getCurrentAuthUser()
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options:[.alert, .sound, .badge]) { granted, error in
                print("Permission granted: \(granted)")
                guard granted else { return }

                // Only get the notification settings if user has granted permissions
                self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }

            DispatchQueue.main.async {
                // Register with Apple Push Notification service
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

}

//*** Implement App delegate ***//
class AppDelegate: NSObject, UIApplicationDelegate {
    
    var pinpoint: AWSPinpoint?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        do {
            let plugin = try Amplify.Analytics.getPlugin(for: "awsPinpointAnalyticsPlugin") as! AWSPinpointAnalyticsPlugin
            pinpoint = plugin.getEscapeHatch()
            print("Sucessfully got AWSPinpoint instance from escape hatch")
        } catch {
            print("Get escape hatch failed with error - \(error)")
        }
        
        return true
    }
    
    func application(_ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")

        // Register the device token with Pinpoint as the endpoint for this user
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    func application(_ application: UIApplication,
                      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if (application.applicationState == .active) {
            let alert = UIAlertController(title: "Notification Received",
                                          message: userInfo.description,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            
            keyWindow?.rootViewController?.present(
                alert, animated: true, completion:nil)
        }

        pinpoint!.notificationManager.interceptDidReceiveRemoteNotification(userInfo)
    }
    
}
