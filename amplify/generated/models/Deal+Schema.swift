// swiftlint:disable all
import Amplify
import Foundation

extension Deal {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case category
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let deal = Deal.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", operations: [.create, .delete, .update])
    ]
    
    model.pluralName = "Deals"
    
    model.fields(
      .id(),
      .field(deal.name, is: .required, ofType: .string),
      .field(deal.category, is: .required, ofType: .string)
    )
    }
}