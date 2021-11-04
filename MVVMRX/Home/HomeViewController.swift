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
    @IBOutlet weak var branchesTableView: UITableView! {
        didSet {
            branchesTableView.register(UINib(nibName: branchTableViewCell, bundle: nil), forCellReuseIdentifier: branchTableViewCell)
        }
    }
    
    // MARK: - Variables
    
    let disposeBag = DisposeBag()
    let homeViewModel = HomeViewModel()
    let branchTableViewCell = "BranchTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupTableView()
        subscribeToLoading()
        subscribeToResponse()
        getData()
        bindToHiddenTable()
        subscribeToBranchSelection()
        
    }
    
    // MARK: - Functions

//    func setupTableView() {
//        branchesTableView.register(UINib(nibName: branchTableViewCell, bundle: nil), forCellReuseIdentifier: branchTableViewCell)
//    }
    func subscribeToLoading() {
        homeViewModel.loadingObservable.subscribe (onNext: { (isLoading) in
            if isLoading {
                print("Loading...")
            }else {
                print("Not Loading!!")
            }
        }).disposed(by: disposeBag)

    }
    func subscribeToResponse() {
        homeViewModel.returnedBranches.bind(to: branchesTableView.rx.items(cellIdentifier: branchTableViewCell, cellType: BranchTableViewCell.self)) { (index,branch,cell) in
            cell.textLabel?.text = branch
        }.disposed(by: disposeBag)
    }
    func bindToHiddenTable() {
        homeViewModel.isTableHiddenObservable.bind(to: branchesTableView.rx.isHidden).disposed(by: disposeBag)
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
