//
//  LocalStorageManager.swift
//  Nudge
//
//  Created by Dennis John on 1/19/21.
//  Copyright © 2021 Nudge BG, Inc. All rights reserved.
//

import Foundation

struct Patient:Codable {
    let id: String
    let phone: String
    let firstName: String
    let lastName: String
    let loginPermitted: Bool
}

final class LocalStorageManager {
    

    static let shared: LocalStorageManager = LocalStorageManager()

    var patient:Patient? {
        get {
            let defaults = UserDefaults.standard
            if let data = defaults.data(forKey: "nudge_patient") {
                let decoder = JSONDecoder()
                return try? decoder.decode(Patient.self, from: data)
            }
            return nil
        }
        set(val) {
            let defaults = UserDefaults.standard
            if val != nil {
                let encoder = JSONEncoder()
                if let data = try? encoder.encode(val) {
                    defaults.setValue(data, forKey: "nudge_patient")
                }
            } else {
                defaults.removeObject(forKey: "nudge_patient")
            }
        }
    }
}
