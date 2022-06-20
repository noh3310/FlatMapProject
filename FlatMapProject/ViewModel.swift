//
//  ViewModel.swift
//  FlatMapProject
//
//  Created by 노건호 on 2022/06/20.
//

import Foundation
import RxSwift
import RxRelay

class ViewModel {
    
    private let apiManager = APIManager()
    
    private let disposeBag = DisposeBag()
    
    static let shared = ViewModel()
    private init() {
        searchText
            .flatMap { self.apiManager.apiCall($0) }   // Observable<[Repos] 리턴
            .subscribe(onNext: { self.result.accept($0) })
            .disposed(by: disposeBag)
    }
    
    let searchText = BehaviorRelay<String>(value: "")
    let result = PublishRelay<[Repos]>()
}
