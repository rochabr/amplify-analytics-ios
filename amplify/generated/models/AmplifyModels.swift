// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "1af656fd2aa282fe7529922daf7ecb60"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Deal.self)
  }
}