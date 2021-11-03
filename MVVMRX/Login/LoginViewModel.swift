//
//  LoginViewModel.swift
//  MVVMRX
//
//  Created by Nagiz on 03/11/2021.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    // MARK: - Variables
    
    var phoneNumberBehavior = BehaviorRelay<String>(value: "")
    var passwordBehavior = BehaviorRelay<String>(value: "")
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    var isPhoneValid: Observable<Bool> {
        return phoneNumberBehavior.asObservable().map { (phone) -> Bool in
            let isPhoneEmpty = phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return !isPhoneEmpty
        }
    }
    
    var isPasswordValid: Observable<Bool> {
        return passwordBehavior.asObservable().map { (password) -> Bool in
            let isPasswordEmpty = password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return !isPasswordEmpty
        }
    }
    
    var isLoginButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isPhoneValid, isPasswordValid) { (isPhoneValid, isPasswordValid) in
            let loginValid = isPhoneValid && isPasswordValid
            return loginValid
        }
    }
    
    private var modelSubject = PublishSubject<String>()
    var returnedModel: Observable<String> {
        return modelSubject.asObserver()
    }
    
    // MARK: - Functions
    
    func validToLogin() {
        loadingBehavior.accept(true)
        modelSubject.onNext("Valid To Login")
        loadingBehavior.accept(false)
    }
    
    
    
}
