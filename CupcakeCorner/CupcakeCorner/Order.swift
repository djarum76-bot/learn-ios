//
//  Order.swift
//  CupcakeCorner
//
//  Created by habil . on 22/12/23.
//

import Foundation

@Observable
class Order: Codable{
    enum CodingKeys: String, CodingKey{
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        let nameValid = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let streetValid = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let cityValid = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let zipValid = zip.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if nameValid.isEmpty || streetValid.isEmpty || cityValid.isEmpty || zipValid.isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Decimal{
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // complicated cake get more
        cost += Decimal(type) / 2
        
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    var userAddress: UserAddress{
        get{
            return UserAddress(name: name, streetAddress: streetAddress, city: city, zip: zip)
        }
        set{
            name = newValue.name
            streetAddress = newValue.streetAddress
            city = newValue.city
            zip = newValue.zip
            
            saveUserAddressToUserDefaults()
        }
    }
    
    func saveUserAddressToUserDefaults(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userAddress){
            UserDefaults.standard.set(encoded, forKey: "userAddress")
        }
    }
    
    func loadUserAddressFromUserDefaults() {
        if let savedAddress = UserDefaults.standard.object(forKey: "userAddress") as? Data {
            let decoder = JSONDecoder()
            if let decodedAddress = try? decoder.decode(UserAddress.self, from: savedAddress) {
                userAddress = decodedAddress
            }
        }
    }
    
    init(){
        loadUserAddressFromUserDefaults()
    }
}

struct UserAddress: Codable {
    var name: String
    var streetAddress: String
    var city: String
    var zip: String
}
