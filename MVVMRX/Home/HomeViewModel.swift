//
//  HomeViewModel.swift
//  MVVMRX
//
//  Created by Nagiz on 03/11/2021.
//

import Foundation
import RxSwift
import RxCocoa


class HomeViewModel {
    
    // MARK: - Variables
    
    var branchesList = ["1","2","3"]
    private var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var loadingObservable: Observable<Bool> {
        return loadingBehavior.asObservable()
    }
    
    private var isTableHiddenBehavior = BehaviorRelay<Bool>(value: false)
    var isTableHiddenObservable: Observable<Bool> {
        return isTableHiddenBehavior.asObservable()
    }
    
    private var modelSubject = PublishSubject<[String]>()
    var returnedBranches: Observable<[String]> {
        return modelSubject.asObservable()
    }
    
    // MARK: - Functions
    
    func getData() {
        loadingBehavior.accept(true)
        modelSubject.onNext(branchesList)
        if branchesList.count > 0 {
            isTableHiddenBehavior.accept(false)
        }else {
            isTableHiddenBehavior.accept(true)
        }
        loadingBehavior.accept(false)
        
    }
}
