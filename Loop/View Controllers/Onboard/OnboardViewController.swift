//
//  OnboardViewController.swift
//  Nudge
//
//  Created by Dennis John on 1/19/21.
//  Copyright © 2021 Nudge BG, Inc. All rights reserved.
//

import UIKit
import PhoneNumberKit

protocol OnboardDelegate {
    func onboardComplete()
}

struct VerificationResponse:Codable {
    var authstatus: String
}

class OnboardViewController: UIViewController {

    @IBOutlet weak var phoneTextField: PhoneNumberTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let dispatchGroup = DispatchGroup()
    var delegate: OnboardDelegate?
    var isValidPhone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTextField.delegate = self
        phoneTextField.becomeFirstResponder()
//        phoneTextField.withFlag = true
//        phoneTextField.withPrefix = true
//        phoneTextField.withExamplePlaceholder = true
    }

    @IBAction func validateTapped(_ sender: Any) {
        sendCode()
    }
    
    func sendCode() {
        let phone = phoneTextField.text!.digits
        
        PatientRemoteDataManager.shared.sendCode(phone: phone) { [weak self] response in
            if response != nil {
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "authCode", sender: nil)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "There seems to be a problem", message: "There was a problem sending your validation code.\n\nPlease check your phone number and internet connection and try again.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? AuthViewController
        destination?.delegate = delegate
        destination?.phoneNumber = phoneTextField.text?.digits
    }
}

extension OnboardViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var fullString = textField.text ?? ""
        fullString.append(string)

        sendButton.isEnabled = fullString.digits.count == 10
        
        return true
    }
}

extension RangeReplaceableCollection where Self: StringProtocol {
    var digits: Self { filter(\.isWholeNumber) }
}

