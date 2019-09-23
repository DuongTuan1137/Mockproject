//
//  ForgotPasswordVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/20/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var viewLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        viewLogin.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTF()
        guard let email = emailTF.text, email.count > 0 else {return}
        if isValidEmail(emailStr: email) == false{
            alert(title: "Lỗi", message: "Định dạng email không đúng")
        }
    }
    
    private func checkTF() {
        guard let email = emailTF.text else {return}
        if  email.count > 0 {
            viewLogin.isEnabled = true
        }
    }
    
    private func alert(title : String, message : String){
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        a.addAction(cancel)
        present(a, animated: true, completion: nil)
    }
    
    private func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let url = "http://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/resetPassword"
        postGenericData(urlString: url, parameters: ["email" : emailTF.text]) { (json: ResponseSample) in
            DispatchQueue.main.async {
                if json.status == 1{
                    self.alert(title: "Thành Công", message:"" )
                } else {
                    self.alert(title: "Thất bại", message: json.error_message ?? "")
                }
            }
        }
    }
    

}
