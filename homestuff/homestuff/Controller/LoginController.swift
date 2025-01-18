//
//  LoginController.swift
//  homestuff
//
//  Created by Muhammad Daffa Izzati on 18/01/25.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func registerLinkPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "moveToRegister", sender: sender)
        print("Move to register")
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "moveToHome", sender: sender)
        print("Signed in")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToRegister" {
                if let destinationVC = segue.destination as? RegisterController {
                    // Kirim data ke RegisterViewController jika diperlukan
                    // destinationVC.someProperty = someValue
                }
            }
    }
}
