//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import RxSwift
import RxCocoa

class MyViewController : UIViewController {
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    @objc let scrollView = UIScrollView()
    let tableView = UITableView()
    let bag = DisposeBag()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        view.addSubview(button)
        button.backgroundColor = .red
        
        let observerble = Observable<Int>.create { (observer) -> Disposable in
            for i in 1...3 {
                observer.onNext(i)
            }
            observer.onCompleted()
            return Disposables.create()
        }
        .share(replay: 1, scope: .forever)
    
        observerble.subscribe { (event) in
            print("one \(event)")
        }
        
        observerble.subscribe { (event) in
            print("two \(event)")
        }
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = BehaviorRelay(value: subject1)
        
        variable.asObservable()
            .flatMapLatest {
                $0
            }
            .subscribe({ (event) in
                print("flatMapLatest:\(event)")
            })
            .disposed(by: bag)
        
        subject1.onNext("B")
        variable.accept(subject2)
        subject2.onNext("2")
        subject1.onNext("C")
        
//        let imageView = UIImageView()
//        let image = UIImage(named: "123.jpg")
//        imageView.image = image
//        
//        let rximage: Observable<UIImage?> = Observable.just(image)
//        rximage.bind(to: imageView.rx.image)
        let observerble1 = Observable<Int>.create { (observer) -> Disposable in
            for i in 1...3 {
                observer.onNext(i)
            }
            observer.onCompleted()
            return Disposables.create()
            }
            .share(replay: 1, scope: .forever)
        
        observerble1.subscribe { (event) in
            print("one \(event)")
        }
        
        observerble1.subscribe { (event) in
            print("two \(event)")
        }
        test1()
        test6()
    }

    // 点击事件
    func test1() {
        button.rx.tap.subscribe(onNext: {
            print("aaa")
        })
        .disposed(by: bag)
    }
    
    //代理
    func test2() {
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
            ])
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: bag)
    }
    
    // 闭包回调
    func test3() {
        URLSession.shared.rx
            .data(request: URLRequest(url: URL(string: "www.baidu.com")!))
            .subscribe(onNext: { (data) in
                print("xxxx")
            }, onError: { (error) in
                print("error")
            })
            .disposed(by: bag)
    }
    
    // 通知
    func test4() {
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: { (notification) in
                print("Application Will Enter Foreground")
            })
            .disposed(by: bag)
    }
    
    // KVO
    func tset5() {
        scrollView.rx.observe(CGPoint.self, #keyPath(scrollView.contentOffset))
            .subscribe(onNext: { newValue in
                print("do something with newValue")
            })
            .disposed(by: bag)
    }
    
    // 两个任务合并成一个 例如网络请求
    func test6() {
        Observable.zip(
            Api.teachersCount(),
            Api.studentsCount()
            )
            .subscribe(onNext: { (teacherCount, commentCount) in
                print("student\(teacherCount),\(commentCount)")
            }, onError: { error in
                print(error)
            })
            .disposed(by: bag)

        
        Observable.merge([Api.teachersCount().map { $0 as AnyObject }, Api.studentsCount().map{ $0 as AnyObject }]).subscribe({ event  in
            print("merge : \(event)")
        })
    }
    
    
    
}

/// 用 Rx 封装接口
enum Api {
    
    /// 取得老师的详细信息
    static func teachersCount() -> Observable<Int> {
        return Observable.just(2)
    }
    
    /// 取得老师的评论
    static func studentsCount() -> Observable<String> {
        return Observable.create({ (observe) -> Disposable in
            observe.onNext("123")
            observe.onCompleted()
            return Disposables.create()
        })
    }
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
