//
//  Employee.swift
//  RaiseMan
//
//  Created by Sinkerine on 16/01/2017.
//  Copyright © 2017 sinkerine. All rights reserved.
//

import Foundation

class Employee : NSObject {
    var name: String? = "New Employee"
    var raise: Float = 0.05
    
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
}
