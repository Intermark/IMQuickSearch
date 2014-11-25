//
//  IMQuickSearch.swift
//  IMQuickSearch
//
//  Created by Ben Gordon on 11/25/14.
//  Copyright (c) 2014 Intermark. All rights reserved.
//

import UIKit

typealias IMQuickSearchFilterCompletion = (objects: [AnyObject]?) -> ()

class IMQuickSearch: NSObject {
    // MARK: - Properties
    var masterArray: [IMQuickSearchFilter] = []
    
    
    // MARK: - Init
    init(filters: [IMQuickSearchFilter]) {
        super.init()
        masterArray = filters
    }
    
    
    // MARK: - Filtered Objects
    func filteredObjects(value: String?) -> [AnyObject] {
        // Set Up
        var filteredSet = NSMutableSet()
        let filters = masterArray
        
        // Filter each object based on value
        for filter in filters {
            filteredSet.unionSet(filter.filteredObjects(value))
        }
        
        // Return it
        return filteredSet.allObjects
    }
    
    func asynchronouslyFilteredObjects(value: String?, completion: IMQuickSearchFilterCompletion) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            let filteredObj = self.filteredObjects(value)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(objects: filteredObj)
            })
        })
    }
    
    
    // MARK: - Filter Management
    func add(filter: IMQuickSearchFilter) {
        masterArray.append(filter)
    }
    
    func remove(filter: IMQuickSearchFilter) {
        var filterToDeleteIndex = -1
        for (var i = 0; i < masterArray.count; i++) {
            let f = masterArray[i]
            if (f == filter) {
                filterToDeleteIndex = i
            }
        }
        
        if (filterToDeleteIndex >= 0) {
            masterArray.removeAtIndex(filterToDeleteIndex)
        }
    }
}

class IMQuickSearchFilter: NSObject {
    // MARK: - Properties
    var searchSet: NSSet = NSSet()
    var lastSearchSet: NSSet? = nil
    var lastSearchValue: NSString? = nil
    var keys: [String]? = nil
    
    
    // MARK: - Init
    init(searchArray: [AnyObject]!, keys: [String]) {
        super.init()
        self.searchSet = NSSet(array: searchArray)
        self.keys = keys
    }
    
    
    // MARK: - Filtering Objects
    func filteredObjects(value: String?) -> NSSet {
        if let v = value {
            // If value's length == 0, return all results
            if (NSString(string: v).length == 0) {
                return searchSet
            }
            
            // Set Up
            let shouldUseLastSearch = valueContains(v, containsValue: lastSearchValue)
            var newSearchSet = (lastSearchSet != nil && shouldUseLastSearch) ? lastSearchSet : searchSet
            
            // Create predicate
            var predicate = quickSearchPredicate(keys, value: v)
            var filteredSet = newSearchSet!.filteredSetUsingPredicate(predicate)
            
            // Save
            lastSearchSet = filteredSet
            lastSearchValue = v
        }
        
        // No value, return all sets
        return searchSet
    }
    
    
    // MARK: - Create predicate
    func quickSearchPredicate(keys: [String]?, value: String) -> NSPredicate {
        if let k = keys {
            var predicates: [NSPredicate] = []
            for key in k {
                var existsPredicate = NSPredicate({ (evalObject, bindings) -> Bool in
                    return evalObject.respondsToSelector(Selector(value))
                })
                var containsPredicate = NSPredicate(format: "(%K.description CONTAINS[cd] %@)", key, value)
                predicates.append(NSCompoundPredicate.andPredicateWithSubpredicates([existsPredicate, containsPredicate!]))
            }
            
            return NSCompoundPredicate.orPredicateWithSubpredicates(predicates)
        }
        
        return NSPredicate()
    }
    
    
    // MARK: - Check string
    func valueContains(value: String?, containsValue value2: String?) -> Bool {
        if (value == nil || value2 == nil) {
            return false
        }
        
        // Unwrap and test for 0 length
        let v1 = value!
        let v2 = value2!
        if (NSString(string: v2).length == 0) {
            return true
        }
        
        // Return predicate evaluation
        let p = NSPredicate(format: "SELF CONTAINS[cd] %@", v2)
        return p!.evaluateWithObject(v1)
    }
}