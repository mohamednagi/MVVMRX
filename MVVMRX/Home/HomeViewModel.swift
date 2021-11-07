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
    
    let disposeBag = DisposeBag()
    
    var homeArray = BehaviorRelay.init(value: ["moe","nagi","ali"])
    private var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var loadingObservable: Observable<Bool> {
        return loadingBehavior.asObservable()
    }
    
    private var isEmptyViewHiddenBehavior = BehaviorRelay<Bool>(value: false)
    var isEmptyViewHiddenObservable: Observable<Bool> {
        return isEmptyViewHiddenBehavior.asObservable()
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
        modelSubject.subscribe {[weak self] (shownArray) in
            guard let self = self else {return}
            if let array = shownArray.element {
                if array.count > 0 {
                    self.showTable()
                }else {
                    self.hideTable()
                }
            }else {
                self.hideTable()
            }
        }.disposed(by: disposeBag)

        modelSubject.onNext(homeArray.value)
        loadingBehavior.accept(false)
        
    }
    
    func showTable() {
        self.isTableHiddenBehavior.accept(false)
        self.isEmptyViewHiddenBehavior.accept(true)
    }
    
    func hideTable() {
        self.isTableHiddenBehavior.accept(true)
        self.isEmptyViewHiddenBehavior.accept(false)
    }
}
