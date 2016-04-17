//
// Created by Geoffrey Amey on 4/17/16.
// Copyright (c) 2016 Geoffrey Amey. All rights reserved.
//

import Foundation

internal class Utils {

    static func urlFrom(string: String?) -> NSURL? {
        return nil
    }

    static func getSortName(name: String, sortIndex: Int) -> String {
        if sortIndex <= 1 || sortIndex > name.characters.count {
            return name
        }
        else {
            return name.substringFromIndex(name.startIndex.advancedBy(sortIndex-1))
        }
    }
}
