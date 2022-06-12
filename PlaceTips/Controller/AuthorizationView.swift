import Firebase
import UIKit

class AuthorizationView: UIViewController {
    var signUp: Bool = true
    
    override func viewDidLoad() {
        navigationItem.title = "Авторизация"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        // authorization
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registrationButton)
        view.addSubview(authorizationButton)
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
        setUpLoginConstraints()
        setUpPasswordConstraints()
        setUpAuthButtonConstraints()
        setUpRegButtonConstraints()
        
        // regestration
        view.addSubview(loginTextField)
        view.addSubview(regPasswordTextField)
        view.addSubview(regEmailTextField)
        view.addSubview(regRegistrationButton)
        
        loginTextField.delegate = self
        regPasswordTextField.delegate = self
        regEmailTextField.delegate = self
        
        loginTextField.isHidden = true
        regPasswordTextField.isHidden = true
        regEmailTextField.isHidden = true
        regRegistrationButton.isHidden = true
        
        regSetUpLoginConstraints()
        regSetUpPasswordConstraints()
        regSetUpEmailConstraints()
        regSetUpButtonConstraints()
    }
    
    // MARK: - Auth part
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Почта"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 17.5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.backgroundColor = ColorPalette.inputsBackground
        textField.layer.masksToBounds = true
        textField.returnKeyType = .done
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Пароль"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 17.5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.backgroundColor = ColorPalette.inputsBackground
        textField.layer.masksToBounds = true
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()
    
    let authorizationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 35/2
        button.addTarget(self, action: #selector(goToProfileView), for: .touchUpInside)
        return button
    }()
    
    @objc func goToProfileView(_: UITapGestureRecognizer) {
        let password = passwordTextField.text!
        let email = emailTextField.text!
        if !password.isEmpty && !email.isEmpty {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error == nil {
                    
                }
            }
        } else {
            print("auth error")
        }
    }
    
    let registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        button.setTitle("Регистрация", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 35/2
        button.addTarget(self, action: #selector(showRegistrationView), for: .allEvents)
        return button
    }()
    
    @objc func showRegistrationView(_: UITapGestureRecognizer) {
        loginTextField.isHidden = false
        regPasswordTextField.isHidden = false
        regEmailTextField.isHidden = false
        regRegistrationButton.isHidden = false
        
        navigationItem.title = "Регистрация"
        
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        registrationButton.isHidden = true
        authorizationButton.isHidden = true
        
        signUp = !signUp
    }
    
    func setUpLoginConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height/4),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50)
        ])
    }
    
    func setUpPasswordConstraints() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50)
        ])
    }
    
    func setUpRegButtonConstraints() {
        registrationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            registrationButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            registrationButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20)
        ])
    }
    
    func setUpAuthButtonConstraints() {
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            authorizationButton.topAnchor.constraint(equalTo: registrationButton.bottomAnchor, constant: 10)
        ])
    }
    
    // MARK: - Registration part
    
    let loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Логин"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 17.5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.backgroundColor = ColorPalette.inputsBackground
        textField.layer.masksToBounds = true
        textField.returnKeyType = .done
        return textField
    }()
    
    let regPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Пароль"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 17.5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.backgroundColor = ColorPalette.inputsBackground
        textField.layer.masksToBounds = true
        textField.returnKeyType = .done
        return textField
    }()
    
    let regEmailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Почта"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 17.5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textField.backgroundColor = ColorPalette.inputsBackground
        textField.layer.masksToBounds = true
        textField.returnKeyType = .done
        return textField
    }()
    
    let regRegistrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 35/2
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    }()
    // регистрация
    @objc func register(_: UITapGestureRecognizer) {
        let login = loginTextField.text!
        let regEmail = regEmailTextField.text!
        let regPassword = regPasswordTextField.text!

        if (!login.isEmpty && !regPassword.isEmpty && !regEmail.isEmpty && regPassword.count >= 6) {
            Auth.auth().createUser(withEmail: regEmail, password: regPassword) { result, error in
                if error == nil {
                    if let result = result {
                        print(result.user.uid)
                        let ref = Database.database().reference().child("users")
                        ref.child(result.user.uid).updateChildValues(["name": login,
                                                                      "email": regEmail])
                        let db = Firestore.firestore()
                        db.collection("users").document(result.user.uid).setData([
                            "login": login,
                            "email": regEmail,
                            "password": regPassword
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    }
                }
            }
        } else {
            print("Registration error") // приставить сюда алёрт
        }
    }
    
    func regSetUpLoginConstraints() {
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height/4),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    func regSetUpPasswordConstraints() {
        regPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            regPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regPasswordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 15),
            regPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            regPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    func regSetUpEmailConstraints() {
        regEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            regEmailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regEmailTextField.topAnchor.constraint(equalTo: regPasswordTextField.bottomAnchor, constant: 15),
            regEmailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            regEmailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    func regSetUpButtonConstraints() {
        regRegistrationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            regRegistrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regRegistrationButton.topAnchor.constraint(equalTo: regEmailTextField.bottomAnchor, constant: 25)
        ])
    }
}

extension AuthorizationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let password = passwordTextField.text!
        let email = emailTextField.text!
        
        let login = loginTextField.text!
        let regEmail = regEmailTextField.text!
        let regPassword = regPasswordTextField.text!
        
        if !signUp {
            if (!login.isEmpty && !regPassword.isEmpty && !regEmail.isEmpty && regPassword.count >= 6) {
                Auth.auth().createUser(withEmail: regEmail, password: regPassword) { result, error in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            
                            let db = Firestore.firestore()
                            db.collection("users").document(result.user.uid).setData([
                                "login": login,
                                "email": regEmail,
                                "password": regPassword
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                }
                            }
                        }
                    }
                }
            } else {
                print("Registration error") // приставить сюда алёрт
            }
        } else {
            if !password.isEmpty && !email.isEmpty {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if error == nil {
                        
                    }
                }
            } else {
                print("auth error")
            }
        }
        
        return true
    }
}
