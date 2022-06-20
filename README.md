# FlatMapProject
Observable에 있는 변환 연산자인 flatMap을 사용해서 깃허브 리포지토리를 검색하는 프로젝트를 구현했다.

## 프로젝트 기반 기술
- 최소 버전: iOS 13
- 사용 외부 라이브러리
    ```
    SnapKit, RxSwift
    RxAlamofire, Alamofire
    ```

## APIManager
- API 호출하는 함수를 구현한 클래스
- apiCall 메서드는 RxAlamofire를 사용해 Observable<[Repos]> 를 리턴한다.
```Swift
func apiCall(_ str: String) -> Observable<[Repos]> {

    let parameters: Parameters = [
        "q": str
    ]

    return RxAlamofire.requestData(.get, URL(string: "https://api.github.com/search/repositories")!, parameters: parameters)
        .map { (response, data) in
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ReposResult.self, from: data)
                return result.items
            } catch {
                return []
            }
        }
}
```

## ViewModel
- SearchBar가 입력한 값을 flatMap으로 API를 호출하고 Observable<Repos]> 리턴값을 전달받는다. 다음 줄에서 Observbale<[Repos]를 구독해 API 결과값을 results 변수에 accept
  ```Swift
  searchText
      .flatMap { self.apiManager.apiCall($0) }   // Observable<[Repos]> 리턴
      .subscribe(onNext: { self.result.accept($0) })
      .disposed(by: disposeBag)
  ```
  
## View
- SearchBar의 값을 ViewModel의 searchText로 바인딩한다.
  ```Swift
  searchBar.rx.text.orEmpty
      .bind(to: viewModel.searchText)
      .disposed(by: disposeBag)
  ```
- result값을 tableView에 바인딩 시킨다.
  ```Swift
  viewModel.result
      .bind(to: tableView.rx.items(cellIdentifier: "cell")) { (indexPath, cellViewModel, cell) in
          if #available(iOS 14.0, *) {
              var config = cell.defaultContentConfiguration()
              config.text = cellViewModel.fullName

              cell.contentConfiguration = config
          } else {
              cell.textLabel?.text = cellViewModel.fullName
          }
      }
      .disposed(by: disposeBag)
  ```
