//
//  AInject.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/3/21.
//

import Foundation

public struct AInject {
    //MARK: - inject
    public static func inject() {
        #if DEBUG
        do {
            let injectionBundle = Bundle.init(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")
            if let bundle = injectionBundle{
                try bundle.loadAndReturnError()
            } else {
                debugPrint("Injection 注入失败,未能检测到 Injection")
            }
        } catch {
            debugPrint("Injection 注入失败 \(error)")
        }
        #endif
    }
}
