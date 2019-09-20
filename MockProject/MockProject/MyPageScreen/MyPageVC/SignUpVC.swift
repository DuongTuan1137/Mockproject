//
//  SignUpVC.swift
//  MockProject
//
//  Created by AnhDCT on 9/19/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signupView: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        signupView.layer.cornerRadius = 5
        signupView.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func alert(message : String){
        let a = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        a.addAction(cancel)
        present(a, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTF()
        switch textField {
        case emailTF:
            guard let email = emailTF.text, email.count > 0 else {return}
            if isValidEmail(emailStr: email) == false{
                alert(message: "Định dạng email không đúng")
            }

        case passwordTF:
            guard let pass = passwordTF.text, pass.count > 0 else {return}
            if pass.count > 16 || pass.count < 6 {
                alert(message: "Độ dài mật khẩu phải từ 6-16 kí tự")
            }

        default:
            break
        }
    }
    
    private func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    private func checkTF() {
        guard let name = nameTF.text, let email = emailTF.text, let pass = passwordTF.text else {return}
        if name.count > 0, email.count > 0, pass.count > 0 {
            signupView.isEnabled = true
        }
    }
    
    @IBAction func signupButton(_ sender: UIButton) {
        let url = "http://812f8957.ngrok.io/18175d1_mobile_100_fresher/public/api/v0/register"
        postGenericData(urlString: url, parameters: ["name" : nameTF.text, "email" : emailTF.text, "password": passwordTF.text]) { (json: ResponseSample) in
            DispatchQueue.main.async {
                if json.status == 1 {
                    User.user.token = json.response?.token
                    User.user.login = true
//                    let meVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeVC")
//                    self.navigationController?.pushViewController(meVC, animated: true)
                    TabBarVC.instance.setTabBar()
                    self.tabBarController?.selectedIndex = 3
                } else {
                    self.alert(message: json.error_message ?? "Can not sign up, pleas try again")
                }
            }
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(login, animated: true)
        
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
