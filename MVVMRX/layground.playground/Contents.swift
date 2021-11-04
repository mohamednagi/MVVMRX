import UIKit
import RxSwift
import RxCocoa



let bag = DisposeBag()


// MARK: - PublishSubject

let pSub = PublishSubject<String>()
pSub.subscribe { (string) in
    print(string.element ?? "")
}.disposed(by: bag)
pSub.onNext("pSub")



// MARK: - BehaviorSubject

let bSub = BehaviorSubject<String>(value: "bSub initial value")
bSub.subscribe { (string) in
    print(string.element ?? "")
}.disposed(by: bag)
bSub.onNext("bSub")



// MARK: - ReplaySubject

let rSub = ReplaySubject<String>.create(bufferSize: 2)
rSub.onNext("rSub1")
rSub.onNext("rSub2")
rSub.onNext("rSub3")
rSub.subscribe { (string) in
    print(string.element ?? "")
}.disposed(by: bag)



// MARK: - AsyncSubject

let aSub = AsyncSubject<String>()
aSub.subscribe { (string) in
    print(string.element ?? "")
}.disposed(by: bag)
aSub.onNext("aSub1")
aSub.onNext("aSub2")
aSub.onCompleted()



// MARK: - PublishRelay

let pRelay = PublishRelay<String>()
pRelay.subscribe { (string) in
    print(string.element ?? "")
}.disposed(by: bag)
pRelay.accept("pRelay")

    

// MARK: - BehaviorRelay

let bRelay = BehaviorRelay<String>(value: "bRelay initial value")
bRelay.subscribe { (string) in
    print(string.element ?? "")
}.disposed(by: bag)
bRelay.accept("bRelay")
