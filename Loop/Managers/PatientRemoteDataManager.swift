//
//  PatientRemoteDataManager.swift
//  Nudge
//
//  Created by Dennis John on 2/28/21.
//  Copyright © 2021 Nudge BG, Inc. All rights reserved.
//

import Foundation
import Alamofire

class PatientRemoteDataManager {
    
    static let shared = PatientRemoteDataManager()
    
    private init() {
    }
    
    func getPatient(patientID: String, callback: @escaping (_ patient: Patient?)->Void) {
        let urlString = "\(PListManager.instance.getSettings()!.awsURLPrefix)/patient/\(patientID)"
        
        AF.request(urlString).responseJSON { response in
            do {
                if response.response?.statusCode == 200, let data = response.data {
                    let decoder = JSONDecoder()
                    let patient = try decoder.decode(Patient.self, from: data)
                    callback(patient)
                }
            } catch {
                callback(nil)
            }
        }
    }
    
    func getPatient(phoneNumber:String, authCode:String, callback: @escaping (_ patient: Patient?)->Void) {
        let urlString = "\(PListManager.instance.getSettings()!.awsURLPrefix)/validateAuth/\(phoneNumber)/\(authCode)"
        
        AF.request(urlString).responseJSON { response in
            do {
                if response.response?.statusCode == 200, let data = response.data {
                    let decoder = JSONDecoder()
                    let patient = try decoder.decode(Patient.self, from: data)
                    callback(patient)
                }
            } catch {
                callback(nil)
            }
        }
    }
    
    func sendCode(phone:String, callback: @escaping (_ response:VerificationResponse?)->Void) {
        let urlString = "\(PListManager.instance.getSettings()!.awsURLPrefix)/sendAuth/\(phone)"
//
        if let url = URL(string: urlString) {
            AF.request(url).responseJSON { response in
                do {
                    let decoder = JSONDecoder()
                    if let data = response.data {
                    let vResp = try decoder.decode(VerificationResponse.self, from: data)
                        callback(vResp)
                    } else {
                        callback(nil)
                    }
                } catch {
                    callback(nil)
                }
            }
        }
    }
}
