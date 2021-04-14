//
//  AuthViewController.swift
//  Nudge
//
//  Created by Dennis John on 2/5/21.
//  Copyright © 2021 Nudge BG, Inc. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var authCodeTextField: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    var phoneNumber:String!
    
    var delegate: OnboardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authCodeTextField.becomeFirstResponder()

    }
    
    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func validateTapped(_ sender: Any) {
        validateCode()
    }
    
    func validateCode () {
        //these URLs need to be externalized
        
        let settingsController = navigationController?.viewControllers.filter({$0 is SettingsTableViewController})
        if settingsController == nil || settingsController?.count != 1 {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        
        PatientRemoteDataManager.shared.getPatient(phoneNumber: phoneNumber!, authCode: authCodeTextField.text!) { [weak self] patient in
            if patient != nil {
                if patient!.loginPermitted {
                    LocalStorageManager.shared.patient = patient
                    self?.delegate?.onboardComplete()
                } else {
                    self?.showAlert("There seems to be a problem", "Your validation code seems to be incorrect, please try again.")
                }
                DispatchQueue.main.async {
                    self?.navigationController?.popToViewController(settingsController![0], animated: true)
                }
            } else {
                self?.showAlert("Unauthorized", "You are not authorized to use Nudge.") { action in
                    DispatchQueue.main.async {
                        self?.navigationController?.popToViewController(settingsController![0], animated: true)
                    }
                }
            }
            
        }
    }
    
    func showAlert(_ title: String, _ text: String, _ handler: ((UIAlertAction)->())? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Unauthorized", message: "You are not authorized to use Nudge.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
            self?.present(alert, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AuthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        validateButton.isEnabled = count == 6
        
        return count <= 6
    }
}
