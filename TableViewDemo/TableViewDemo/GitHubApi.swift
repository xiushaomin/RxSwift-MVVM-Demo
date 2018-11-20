//
//  GitHubApi.swift
//  TableViewDemo
//
//  Created by " " on 2018/11/19.
//  Copyright © 2018 " ". All rights reserved.
//

import UIKit
import Moya

//首先定义一个 provider，即请求发起对象。往后我们如果要发起网络请求就使用这个 provider。
//接着声明一个 enum 来对请求进行明确分类，这里我们定义两个枚举值分别表示获取频道列表、获取歌曲信息。
//最后让这个 enum 实现 TargetType 协议，在这里面定义我们各个请求的 url、参数、header 等信息。

//初始化GitHub请求的provider
let GitHubProvider = MoyaProvider<GitHubAPI>()


public enum GitHubAPI {
    case repositories(String)  //查询资源库
}


//请求配置
extension GitHubAPI: TargetType {
    //服务器地址
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    //请求类型
    public var method: Moya.Method {
        return .get
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        print("发起请求。")
        switch self {
        case .repositories(let query):
            var params: [String: Any] = [:]
            params["q"] = query
            params["sort"] = "stars"
            params["order"] = "desc"
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        }
    }
    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //请求头
    public var headers: [String: String]? {
        return nil
    }
}
