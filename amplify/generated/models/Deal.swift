// swiftlint:disable all
import Amplify
import Foundation

public struct Deal: Model {
  public let id: String
  public var name: String
  public var category: String
  
  public init(id: String = UUID().uuidString,
      name: String,
      category: String) {
      self.id = id
      self.name = name
      self.category = category
  }
}