//
//  ViewController.swift
//  QuickSearchSwift
//
//  Created by Ben Gordon on 11/25/14.
//  Copyright (c) 2014 IMC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var people = IMPerson.randomPeople(200)
        var filter = IMQuickSearchFilter(searchArray: people, keys: ["firstName","lastName"])
        var q = IMQuickSearch(filters: [filter])
        var a = q.filteredObjects("a")
        println(a)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

