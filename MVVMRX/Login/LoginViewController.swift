//
//  ViewController.swift
//  MVVMRX
//
//  Created by Nagiz on 03/11/2021.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    // MARK: - Variables
    
    let loginViewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        observePhoneTF()
        bindTextFieldsToViewModel()
        subscribeToLoading()
        subscribeToResponseModel()
        subscribeOnLoginButtonEnabled()
        subscribeOnLoginButtonTapped()
    }

    
    // MARK: - Functions
    
    func bindTextFieldsToViewModel() {
        phoneNumberTF.rx.text.orEmpty.bind(to: loginViewModel.phoneNumberBehavior).disposed(by: disposeBag)
        passwordTF.rx.text.orEmpty.bind(to: loginViewModel.passwordBehavior).disposed(by: disposeBag)
    }
    
    
    func subscribeToLoading() {
        loginViewModel.loadingBehavior.subscribe (onNext: {(isLoading) in
            if isLoading {
                print("Loading")
            }else {
                print("Not Loading")
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponseModel() {
        loginViewModel.returnedModel.subscribe {[weak self] (returnedModel) in
            guard let self = self else {return}
            print(returnedModel.element ?? "")
            guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {return}
            self.present(homeVC, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    func subscribeOnLoginButtonEnabled() {
        loginViewModel.isLoginButtonEnabled.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func subscribeOnLoginButtonTapped() {
        loginButton.rx.tap
//            .throttle(RxTimeInterval.seconds(1),
//                      scheduler: MainScheduler.instance)
            .subscribe {[weak self] (_) in
            guard let self = self else {return}
            self.loginViewModel.validToLogin()
        }.disposed(by: disposeBag)

    }
    
    
//    func observePhoneTF() {
//        phoneNumberTF.rx.text.subscribe { (text) in
//            print(text != "" ? "Filled And Happe" : "Empty And Sad")
//        }.disposed(by: disposeBag)
//    }
    
    
}

