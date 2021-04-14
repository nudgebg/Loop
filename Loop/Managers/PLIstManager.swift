//
//  PLIstManager.swift
//  Nudge
//
//  Created by Dennis John on 2/9/21.
//  Copyright © 2021 Nudge BG, Inc. All rights reserved.
//

import Foundation

struct Settings: Codable {
    var awsURLPrefix:String
}


class PListManager {
    static let instance = PListManager()
    
    func getSettings() ->Settings? {
        if let path = Bundle.main.path(forResource: "Settings", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let settings = try? PropertyListDecoder().decode(Settings.self, from: xml)
        {
            return settings
        }
        return nil
    }
}
