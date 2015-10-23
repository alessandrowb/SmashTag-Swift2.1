//
//  SearchHistory.swift
//  Smashtag
//
//  Created by Alessandro on 10/22/15.
//  Copyright © 2015 Alessandro Belardinelli. All rights reserved.
//

import Foundation

class SearchHistory {

    private let defaults = NSUserDefaults.standardUserDefaults()

    private struct DefaultValues {
        static let searchKey = "SearchHistory.Searches"
        static let maxNumberOfKeys = 100
    }

    var searches: [String] {
        get {
            return defaults.objectForKey(DefaultValues.searchKey) as? [String] ?? []
        }
        set {
            defaults.setObject(newValue, forKey: DefaultValues.searchKey)
        }
    }

    func addToHistory (searchValue :String) {
        let universalSearchValue = searchValue.lowercaseString //Twitter is not a case sensitive platform
        while let myIndex = searches.indexOf(universalSearchValue) {
            searches.removeAtIndex(myIndex)
        }
        searches.insert(universalSearchValue, atIndex: 0)
        while searches.count > DefaultValues.maxNumberOfKeys {
            searches.removeLast()
        }
    }
    
    func removeAtIndex(index: Int) {
        searches.removeAtIndex(index)
    }
    
}