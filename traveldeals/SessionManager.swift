//
//  SessionManager.swift
//  traveldeals
//
//  Created by Rocha Silva, Fernando on 2021-02-19.
//

import Amplify
import AmplifyPlugins // Imports the Amplify plugin interface
import AWSPinpoint    // Imports the AWSPinpoint client escape hatch

//different auth states that a user can have
enum AuthState {
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
}

final class SessionManager : ObservableObject {
    @Published var authState: AuthState = .login
    
    //checks if user is currently logged in
    func getCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            authState = .session(user: user)
        } else {
            authState = .login
        }
    }
    
    func showSignUp(){
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    func identifyUser() {
//        Amplify.Auth.fetchUserAttributes() { result in
//                switch result {
//                case .success(let attributes):
//                    //print("User attributes - \(attributes)")
//                    for attribute in attributes {
//                        if attribute.key == AuthUserAttributeKey.email {
//                            let email = attribute.value
//
//                            do {
//                                //create escape hatch
//                                let plugin = try Amplify.Analytics.getPlugin(for: "awsPinpointAnalyticsPlugin") as! AWSPinpointAnalyticsPlugin
//                                let awsPinpoint = plugin.getEscapeHatch()
//
//                                //create batch item to update channel type
//                                let batchItem = AWSPinpointTargetingEndpointBatchItem()
//
//                                batchItem?.channelType = AWSPinpointTargetingChannelType.email
//                                batchItem?.address = email
//
//                                //create batch request w/ batch item(this is where I'm stuck)
//                                let batchRequest = AWSPinpointTargetingUpdateEndpointsBatchRequest()
//                                batchRequest.
//
//                                //update endpoint with the request
//                                AWSPinpointTargeting.default().updateEndpointsBatch(...)
//
//                                AnalyticsUserProfile.
//
//                                Amplify.Analytics.iden
//
//                            } catch {
//                                print("Get escape hatch failed with error - \(error)")
//                            }
//                            break
//                        }
//                    }
//                case .failure(let error):
//                    print("Fetching user attributes failed with error \(error)")
//                }
//            }

//        Amplify.Auth.fetchUserAttributes() { result in
//                   switch result {
//                   case .success(let attributes):
//                    for attribute in attributes {
//                        if attribute.key == AuthUserAttributeKey.email{
//                            let email = attribute.value
//
//                            let plugin = try Amplify.Analytics.getPlugin(for: "awsPinpointAnalyticsPlugin") as! AWSPinpointAnalyticsPlugin
//                            let awsPinpoint = plugin.getEscapeHatch()
//
//                            let pinpointTargetingClient =
//                                AWSMobileClient.sharedInstance.pinpoint!.targetingClient
//                            pinpointTargetingClient.addAttribute(["Lakers","Clippers"],
//                                forKey: "favoriteTeams")
//                            pinpointTargetingClient.updateEndpointProfile()
//
//
////                            guard let user = Amplify.Auth.getCurrentUser() else {
////                                print("Could not get user, perhaps the user is not signed in")
////                                return
////                            }
//
//                            break
//                        }
//                    }
//
//                   case .failure(let error):
//                       print("Fetching user attributes failed with error \(error)")
//                   }
//               }
    }
    
    func signUp(username: String, email: String, password: String){
        let attributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        _ = Amplify.Auth.signUp(
            username: username,
            password: password,
            options: options
        ) { [weak self] result in
            
            switch result {
            
            case .success(let signUpResult):
                print("Sign up result: ", signUpResult)
                
                switch signUpResult.nextStep {
                case .done:
                    print("Finished signing up")
                
                case .confirmUser(let details, _):
                    print (details ?? "no details")
                    
                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(username: username)
                    }
                }
                
            case .failure(let error):
                print("Sign up error: ", error)
            }
        }
    }
        
    func confirm(username: String, code: String){
        _ = Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: code
        ) { [weak self] result in
            
            switch result {
            case .success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete {
                    DispatchQueue.main.async {
                        self?.showLogin()
                    }
                }
            case .failure(let error):
                print("failed to confirm code ", error)
            }
        }
    }
    
    func login(username: String, password: String){
        _ = Amplify.Auth.signIn(
            username: username,
            password: password
        ) { [weak self] result in
            
            switch result {
            case .success(let signInResult):
                print(signInResult)
                
                if signInResult.isSignedIn {
                    DispatchQueue.main.async {
                        self?.getCurrentAuthUser()
                        self?.identifyUser()
                    }
                }
            case .failure(let error):
                print("Login error: ", error)
                self?.signOut()
            }
        }
    }
    
    func signOut(){
        _ = Amplify.Auth.signOut()
        { [weak self] result in
            switch result {
            case .success(let signOutResult):
                print(signOutResult)
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                }
                
                //send logout event to pinpoint
                let event = BasicAnalyticsEvent(name: "user-signOut")
                Amplify.Analytics.record(event: event)
                
                //Clear local data
                Amplify.DataStore.clear() { result in
                        switch result {
                        case .success:
                            print("Local data cleared successfully.")
                        case .failure(let error):
                            print("Local data not cleared \(error)")
                        }
                }
                
            case .failure(let error):
                print("sign out error: ", error)
            }
        }
    }
    
}
