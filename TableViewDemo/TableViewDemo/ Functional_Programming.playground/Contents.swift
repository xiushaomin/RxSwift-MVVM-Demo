//: A UIKit based Playground for presenting user interface
  
import UIKit

// 1-10的偶数
// 创建一个空数组
var evens = [Int]()
// 1-10循环迭代
for i in 1...10 {
    // 符合条件
    if i % 2 == 0 {
        // 则添加到数组内
        evens.append(i)
    }
}
print(evens)

// 改写为函数式
// 一级函数
func isEven(number: Int) -> Bool {
    return number % 2 == 0
}
//将isEven函数作为参数传递给了filter函数，
evens = Array(1...10).filter(isEven)
print(evens)

// 但记住函数仅仅是有名字的闭包
evens = Array(1...10).filter { (number) in number % 2 == 0 }
print(evens)

// 参数简写 隐式返回
evens = Array(1...10).filter { $0 % 2 == 0 }
print(evens)

// 函数式语言所具有的一些有趣的特性：
// 1.高阶函数：这种函数的参数是一个函数，或者返回值是一个函数。filter就是一个高阶函数，它可以接收一个函数作为参数。
// 2.一级函数：你可以将函数当做是任意变量，可以将它们赋值给变量，也可以将它们作为参数传给其他函数。
// 3.闭包：实际上就是匿名函数。


// filter 两个参数  array， 以及一个判定函数 （参数为T 返回值为bool）
func myFilter<T>(source: [T], predicate: (T) -> Bool) -> [T] {
    var result = [T]()
    for i in source {
        if predicate(i) {
            result.append(i)
        }
    }
    return result
}

evens = myFilter(source: Array(1...10)) { (number) -> Bool in
    return number % 2 == 0
}
print(evens)

evens = myFilter(source: Array(1...10), predicate: { $0 % 2 == 0})
print(evens)

var a = 0
var b = 1
var c = 2
a = b + c
b = 2

/*
在网上流传一个非常经典的解释｀响应式编程的概念｀ 
在程序开发中：a ＝ b ＋ c
赋值之后 b 或者 c 的值变化后，a 的值不会跟着变化
响应式编程，目标就是，如果 b 或者 c 的数值发生变化，a 的数值会同时发生变化；
 
// 逼格说法：建立了一个动态的数据流关系
*/
