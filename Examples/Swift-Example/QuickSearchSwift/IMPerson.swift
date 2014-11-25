//
//  IMPerson.swift
//  QuickSearchSwift
//
//  Created by Ben Gordon on 11/25/14.
//  Copyright (c) 2014 IMC. All rights reserved.
//

import UIKit

let firstNames = ["Bob","Alan","Nancy","Jennifer","Jessica","Jim","Pam","Abdul","Fred","Ben","Wallace","Nick","Gus","Robert","Alexandra","Timothy","Demetrius","Catherine","Kathy","Erica","Mary"]
let lastNames = ["Clark","Stephens","Gordon","Peterson","Robertson","Frederickson","Smith","Davidson","Wood","Jackson","Sampson","Alberts","West","Breland","Richardson","Ingram","Upchurch","Upshaw"]

class IMPerson: NSObject {
    var firstName: String? = nil
    var lastName: String? = nil
    
    class func randomPerson() -> IMPerson {
        var p = IMPerson()
        let f = Int(arc4random() % UInt32(firstNames.count))
        let l = Int(arc4random() % UInt32(lastNames.count))
        p.firstName = firstNames[f]
        p.lastName = lastNames[l]
        return p
    }
    
    class func randomPeople(count: Int) -> [IMPerson] {
        var people: [IMPerson] = []
        for (var i = 0; i < count; i++) {
            people.append(IMPerson.randomPerson())
        }
        return people
    }
}
