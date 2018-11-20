//: A UIKit based Playground for presenting user interface
  
import UIKit
import RxSwift

//public enum Event<Element> {
//    /// Next element is produced.
//    case next(Element)
//
//    /// Sequence terminated with an error.
//    case error(Swift.Error)
//
//    /// Sequence completed successfully.
//    case completed
//}

//传入一个默认值来初始化
Observable<Int>.just(5).subscribe { (event) in
   print("just: \(event)")
}

//5秒种后发出唯一的一个元素0
Observable<Int>.timer(5, scheduler: MainScheduler.instance).subscribe { (event) in
    print("timer: \(event)")
}

//延时5秒种后，每隔1秒钟发出一个元素
Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance).subscribe { event in
    print("timer: \(event)")
}

// 需要一个数组参数
Observable.from(["A", "B", "C"]).subscribe { (event) in
    print("from: \(event)")
}

// 受可变数量的参数（必需要是同类型的）
Observable.of("A", "B", "C").subscribe { (event) in
    print("of: \(event)")
}

// 创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
Observable<Int>.never().subscribe { (event) in
    print("never: \(event)")
}

// 创建一个空内容的 Observable 序列
Observable<Int>.empty().subscribe { (event) in
    print("empty: \(event)")
}

enum MyError: Error {
    case A
    case B
}

// 发送一个错误的 Observable 序列
Observable<Int>.error(MyError.A).subscribe { (event) in
    print("error: \(event)")
}


let obsevable = Observable<String>.create { observer in
    //对订阅者发出了.next事件，且携带了一个数据"你好"
    observer.onNext("你好")
    //对订阅者发出了.completed事件
    observer.onCompleted()
    //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要return一个Disposable
    return Disposables.create()
}

let subscribe = obsevable.subscribe { (event) in
    print("create: \(event)")
}

// 取消订阅
subscribe.dispose()


let subject = PublishSubject<String>()

subject.subscribe { (event) in
    print("subject1\(event)")
}

subject.subscribe { (event) in
    print("subject2\(event)")
}

subject.onNext("你好")


Observable.of("2", "3")
    .startWith("1")
    .debug("调试1")
    .subscribe(onNext: { print($0) })



//Observable.repeatElement(1).subscribe { (event) in
//    print("repeatElement: \(event)")
//}
