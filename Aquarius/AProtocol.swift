//
//  AProtocol.swift
//  Aquarius
//
//  Created by JZXStudio on 2024/2/5.
//

import Foundation

public struct AProtocol {
    public static let delegate: String = "delegate"
    public static let emptyDelegate: String = "emptyDelegate"
    public static let dataSource: String = "dataSource"
    
    public static let delegateAndDataSource: [String] = [
        AProtocol.delegate,
        AProtocol.dataSource
    ]
}
