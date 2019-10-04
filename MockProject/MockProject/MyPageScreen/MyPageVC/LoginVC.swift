//
//  LoginVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/19/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class LoginVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var viewLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewLogin.layer.cornerRadius = 5
        viewLogin.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTF()
        switch textField {
        case emailTF:
            guard let email = emailTF.text, email.count > 0 else {return}
            if isValidEmail(emailStr: email) == false{
                alert(message: "Định dạng email không đúng")
            }
        default:
            break
        }
    }
    
    private func checkTF() {
        guard let email = emailTF.text, let pass = passTF.text else {return}
        if  email.count > 0, pass.count > 0 {
            viewLogin.isEnabled = true
        }
    }
    
    private func alert(message : String){
        let a = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        a.addAction(cancel)
        present(a, animated: true, completion: nil)
    }
    
    private func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    @IBAction func backtoSignUpVC(_ sender: UIButton) {
        if navigationController == nil {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let url = "http://f1fa6ab5.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/login"
        postGenericData(urlString: url, parameters: ["email" : emailTF.text, "password": passTF.text]) { (json: ResponseSample) in
            DispatchQueue.main.async {
                if json.status == 1 {
                    User.instance.token = json.response?.token
                    User.instance.login = true
                    guard let window = UIApplication.shared.keyWindow else {
                        return
                    }
                    window.rootViewController = TabBarVC.instance
                    TabBarVC.instance.selectedIndex = 3
                } else {
                    self.alert(message: json.error_message ?? "Can not sign up, pleas try again")
                }
            }
        }
    }
    
    @IBAction func pushtoFogotPassVC(_ sender: UIButton) {
        let fpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC")
        navigationController?.pushViewController(fpVC, animated: true)
    }
    

}
