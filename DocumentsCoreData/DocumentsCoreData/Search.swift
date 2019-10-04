//
//  Search.swift
//  DocumentsCoreData
//
//  Created by Megan Wilson on 10/3/19.
//  Copyright © 2019 Megan Wilson. All rights reserved.
//

import Foundation


enum Search: String {
    case everything
    case name
    case content
    
    static var title: [String] {
        get{
            return [Search.everything.rawValue, Search.name.rawValue, Search.content.rawValue]
        }
    }
    
    static var lookfor: [Search]{
        get{
            return [Search.everything, Search.name, Search.content]
        }
    }
}
