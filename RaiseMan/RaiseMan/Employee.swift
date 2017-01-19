//
//  Employee.swift
//  RaiseMan
//
//  Created by Sinkerine on 16/01/2017.
//  Copyright © 2017 sinkerine. All rights reserved.
//

import Foundation

class Employee : NSObject, NSCoding {
    var name: String? = "New Employee"
    var raise: Float = 0.05
    
    override init() {
        super.init()
    }
    
    override func validateValue(_ ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey inKey: String) throws {
        switch inKey {
        case "raise":
            let raiseNumber = ioValue.pointee
            if raiseNumber == nil {
                throw NSError(domain: "UserInputValidationErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Raise shound not be nil"])
            }
        default:
            throw NSError(domain: "UserInputValidationErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown key"])
        }
    }
    
    // MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        if let name = name {
            aCoder.encode(name, forKey: "name")
        }
        aCoder.encode(raise, forKey: "raise")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String?
        raise = aDecoder.decodeFloat(forKey: "raise")
        super.init()
    }
}
