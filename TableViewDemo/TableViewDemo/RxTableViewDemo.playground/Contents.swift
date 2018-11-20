//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import RxSwift
import RxCocoa

class MyViewController : UIViewController {
    
    // 它的本质其实也是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建
    // BehaviorRelay 有一个 value 属性，我们通过这个属性可以获取最新值。而通过它的 accept() 方法可以对值进行修改
    let tableData = BehaviorRelay<[String]>(value: [])
    //当前是否正在加载序列
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40), style: .plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        // Driver 是一种特殊的序列，它的目标是提供一种简便的方式在 UI 层编写响应式代码
        // 如果代码存在 drive，那么这个序列不会产生错误事件并且一定在主线程监听。这样我们就可以安全的绑定 UI 元素
        self.tableData.asDriver()
            .drive(tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(row+1)、\(element)"
                return cell
                
            }
            .disposed(by: disposeBag)
        
        //表格尾部的上拉加载视图显示绑定
        self.isLoading.asDriver()
            .drive(onNext: {
                if $0 {
                    self.tableView.tableFooterView = UIView()
                } else {
                    self.tableView.tableFooterView = nil
                }
            })
            .disposed(by: disposeBag)
        
        //上拉加载数据
        self.getRandomResult().asObservable()
            .subscribe(onNext: { [weak self] items in
                if let tableData = self?.tableData {
                    tableData.accept(tableData.value + items )
                }
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
        
        
        //        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
        //            self?.showMessage("选中项的indexPath为：\(indexPath)")
        //        }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { [weak self] item in
            self?.showMessage("选中项的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        
        tableView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
            print("将要显示单元格indexPath为：\(indexPath)")
            print("将要显示单元格cell为：\(cell)\n")
        }).disposed(by: disposeBag)
    }
    
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: message, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //获取随机数据
    func getRandomResult() -> Driver<[String]> {
        self.isLoading.accept(true)
        //随机生成20条数据
        let items = Array(0..<20).map { _ in "随机\(arc4random())"}
        let observable = Observable.just(items)
        return observable
            // 假装有网络请求
            .delay(2.5, scheduler: MainScheduler.instance)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()



