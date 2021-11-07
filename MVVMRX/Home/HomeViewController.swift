//
//  HomeViewController.swift
//  MVVMRX
//
//  Created by Nagiz on 03/11/2021.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var branchesTableView: UITableView!
    
    // MARK: - Variables
    
    let disposeBag = DisposeBag()
    let homeViewModel = HomeViewModel()
    let branchTableViewCell = "BranchTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        subscribeToLoading()
//        subscribeToResponse()
        bindSearch()
//        getData()
        
        bindToHiddenTable()
        bindToHiddenEmptyView()
        subscribeToBranchSelection()
        
    }
    
    // MARK: - Functions

    func setupTableView() {
        branchesTableView.register(UINib(nibName: branchTableViewCell, bundle: nil), forCellReuseIdentifier: branchTableViewCell)
    }
    
    func subscribeToLoading() {
        homeViewModel.loadingObservable.subscribe (onNext: { (isLoading) in
            if isLoading {
                print("Loading...")
            }else {
                print("Not Loading!!")
            }
        }).disposed(by: disposeBag)

    }
    
    func getObservableArray(array: [String]) -> Observable<[String]> {
        return Observable.create { observer in
            observer.onNext(array)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func bindSearch() {
        var shownResults = [String]()
        let shownResultsSubject = PublishSubject<[String]>()
        var shownResultsObservable: Observable<[String]> {
            return shownResultsSubject.asObserver()
        }
        
        shownResultsObservable
            .bind(to: branchesTableView
                    .rx
                    .items(cellIdentifier: branchTableViewCell,
                           cellType: BranchTableViewCell.self)) { (index,branch,cell) in
                cell.textLabel?.text = branch
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe ( onNext: {[weak self] (searchText) in
                guard let self = self else {return}
                shownResultsSubject.onNext(self.homeViewModel.homeArray.value.filter({ result in
                    searchText.isEmpty || result.lowercased().contains(searchText.lowercased())
                }))
                shownResults = self.homeViewModel.homeArray.value.filter({ result in
                    searchText.isEmpty || result.lowercased().contains(searchText.lowercased())
                })
                print("shownResults = ",shownResults)
            }).disposed(by: disposeBag)
    }
    
    func observeDataChanges(presentableData: [String]) {
        Observable.of(presentableData)
            .bind(to: self.branchesTableView
                    .rx
                    .items(cellIdentifier: self.branchTableViewCell,
                           cellType: BranchTableViewCell.self)) { (index,branch,cell) in
                cell.textLabel?.text = branch
            }
            .disposed(by: self.disposeBag)
    }
    
//    func subscribeToResponse() {
//        homeViewModel.returnedBranches
//            .bind(to: branchesTableView
//                    .rx
//                    .items(cellIdentifier: branchTableViewCell,
//                           cellType: BranchTableViewCell.self)) { (index,branch,cell) in
//            cell.textLabel?.text = branch
//        }
//            .disposed(by: disposeBag)
//    }
    
    func bindToHiddenTable() {
        homeViewModel.isTableHiddenObservable.bind(to: branchesTableView.rx.isHidden).disposed(by: disposeBag)
    }
    
    func bindToHiddenEmptyView() {
        homeViewModel.isEmptyViewHiddenObservable.bind(to: emptyView.rx.isHidden).disposed(by: disposeBag)
    }
    
    func subscribeToBranchSelection() {
        branchesTableView.rx.modelSelected(String.self).bind { branch in
            print("\(branch) Selected")
        }.disposed(by: disposeBag)
//        Observable.zip(branchesTableView.rx.itemSelected, branchesTableView.rx.modelSelected(String.self)).bind { index,branch in
//            print("\(branch) Selected")
//        }.disposed(by: disposeBag)
    }
    
    func getData() {
        homeViewModel.getData()
    }
}
