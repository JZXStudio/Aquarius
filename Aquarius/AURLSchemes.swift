//
//  AURLSchemes.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/4/29.
//

import Foundation

public struct AURLSchemesParameter {
    public var name: String = ""
    public var value: Any
}
/// URLSchemes的类型
public enum AURLSchemesType {
    /// scheme://action/value?parameter.name=parameter.value&parameter.name=parameter.value
    case Action
    /// scheme://parameter.name=parameter.value,parameter.name=parameter.value
    ///
    /// Note: **参数之间不要有空格**
    case Parameter
}
/// URLSchemes中的相关数据
public struct AURLSchemes {
    /// 完整的路径
    public var urlString: String = ""
    /// type ID
    public var scheme: String? = ""
    /// 执行的类别
    public var action: String = ""
    /// 对应的值
    public var value: String = ""
    /// 相关的参数
    public var parameters: [AURLSchemesParameter]?
    /// 构造器
    /// - Parameters:
    ///   - url: 发送的url
    ///   - type: 类型，默认为Normal
    public init(_ url: URL, _ type: AURLSchemesType = .Action) {
        self.urlString = url.absoluteString
        self.scheme = url.scheme
        
        if type == .Action {
            configAction(url)
        } else if type == .Parameter {
            configParameter(url)
        }
    }
    
    private mutating func configAction(_ url: URL) {
        let queryAction = urlString.components(separatedBy: "/").filter{ !$0.isEmpty }
        let actionTemp: String = queryAction[1]
        
        let temp = actionTemp.components(separatedBy: "?")
        action = temp[0]
        
        if queryAction.count > 2 {
            let queryValue = queryAction[2].components(separatedBy: "?")
            value = queryValue[0]
        }
        
        let query: String? = url.query
        if query != nil {
            parameters = parseParameters(query!, segment: "&")
        }
    }
    
    private func parseParameters(_ string: String,  segment: String = "&") -> [AURLSchemesParameter] {
        var schemeParameters: [AURLSchemesParameter] = []
        
        let parameters = string.components(separatedBy: segment)
        if parameters.count > 0 {
            for currentParameter: String in parameters {
                let keyValue = currentParameter.components(separatedBy: "=")
                let schemeParameter: AURLSchemesParameter = AURLSchemesParameter(name: keyValue[0], value: keyValue[1])
                schemeParameters.append(schemeParameter)
            }
        }
        
        return schemeParameters
    }
    
    private mutating func configParameter(_ url: URL) {
        let queryParameters = urlString.components(separatedBy: "/").filter{ !$0.isEmpty }
        parameters = parseParameters(queryParameters[1], segment: ",")
    }
}
