//
//  UIControl++.swift
//  Aquarius
//
//  Created by SONG JIN on 2022/9/30.
//

import UIKit
import Foundation

extension UIControl {
    internal struct UIControlTemp {
        public static var events: Array<Dictionary<String, Any>> = []
    }
    
    public func addEventBlock(_ event: UIControl.Event, block: ((UIControl) -> Void)?) {
        let dict: Dictionary<UInt, ((UIControl) -> Void)?> = [event.rawValue : block]
        
        let res = String.init(format: "%018p", unsafeBitCast(self, to: Int.self))
        let dict2: Dictionary<String, Any> = ["address" : res, "object" : dict]
        
        UIControlTemp.events.append(dict2)
        
        switch event {
        case .touchDown:
            addTarget(self, action: #selector(touchDownBlock), for: event)
            break
        case .touchDownRepeat:
            addTarget(self, action: #selector(touchDownRepeatBlock), for: event)
            break
        case .touchDragInside:
            addTarget(self, action: #selector(touchDragInsideBlock), for: event)
            break
        case .touchDragOutside:
            addTarget(self, action: #selector(touchDragOutsideBlock), for: event)
            break
        case .touchDragEnter:
            addTarget(self, action: #selector(touchDragEnterBlock), for: event)
            break
        case .touchDragExit:
            addTarget(self, action: #selector(touchDragExitBlock), for: event)
            break
        case .touchUpInside:
            addTarget(self, action: #selector(touchUpInsideBlock), for: event)
            break
        case .touchUpOutside:
            addTarget(self, action: #selector(touchUpOutsideBlock), for: event)
            break
        case .touchCancel:
            addTarget(self, action: #selector(touchCancelBlock), for: event)
            break
        case .valueChanged:
            addTarget(self, action: #selector(valueChangedBlock), for: event)
            break
        case .editingDidBegin:
            addTarget(self, action: #selector(editingDidBeginBlock), for: event)
            break
        case .editingChanged:
            addTarget(self, action: #selector(editingChangedBlock), for: event)
            break
        case .editingDidEnd:
            addTarget(self, action: #selector(editingDidEndBlock), for: event)
            break
        case .editingDidEndOnExit:
            addTarget(self, action: #selector(editingDidEndOnExitBlock), for: event)
            break
        case .allTouchEvents:
            addTarget(self, action: #selector(allTouchEventsBlock), for: event)
            break
        case .allEditingEvents:
            addTarget(self, action: #selector(allEditingEventsBlock), for: event)
            break
        case .applicationReserved:
            addTarget(self, action: #selector(applicationReservedBlock), for: event)
            break
        case .systemReserved:
            addTarget(self, action: #selector(systemReservedBlock), for: event)
            break
        case .allEvents:
            addTarget(self, action: #selector(allEventsBlock), for: event)
            break
        default:
            if #available(iOS 9.0, *) {
                if event == .primaryActionTriggered {
                    addTarget(self, action: #selector(primaryActionTriggeredBlock), for: event)
                }
            }
            if #available(iOS 14.0, *) {
                if event == .menuActionTriggered {
                    addTarget(self, action: #selector(menuActionTriggeredBlock), for: event)
                }
            }
            break
        }
    }
    
    public func addTouchDownBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.touchDown, block: block)
    }
    
    public func addTouchDownRepeatBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.touchDownRepeat, block: block)
    }
    
    public func addTouchDragInsideBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.touchDragInside, block: block)
    }
    
    public func addTouchDragOutsideBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.touchDragOutside, block: block)
    }
    
    public func addTouchDragEnterBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.touchDragEnter, block: block)
    }
    
    public func addTouchDragExitBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.touchDragExit, block: block)
    }
    
    public func addTouchUpInsideBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.touchUpInside, block: block)
    }
    
    public func addTouchUpOutsideBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.touchUpOutside, block: block)
    }
    
    public func addTouchCancelBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.touchCancel, block: block)
    }
    
    public func addValueChangedBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.valueChanged, block: block)
    }
    
    public func addEditingDidBeginBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.editingDidBegin, block: block)
    }
    
    public func addEditingChangedBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.editingChanged, block: block)
    }
    
    public func addEditingDidEndBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.editingDidEnd, block: block)
    }
    
    public func addEditingDidEndOnExitBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.editingDidEndOnExit, block: block)
    }
    
    public func addAllTouchEventsBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.allTouchEvents, block: block)
    }
    
    public func addAllEditingEventsBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.allEditingEvents, block: block)
    }
    @available(iOS 9.0, *)
    public func addApplicationReservedBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.applicationReserved, block: block)
    }
    @available(iOS 14.0, *)
    public func addSystemReservedBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.systemReserved, block: block)
    }
    
    public func addAllEventsBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.allEvents, block: block)
    }
    
    public func addPrimaryActionTriggeredBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.primaryActionTriggered, block: block)
    }
    
    public func addMenuActionTriggeredBlock(_ block: ((UIControl) -> Void)?) {
        addEventBlock(.menuActionTriggered, block: block)
    }
    
    public func checkAndRemoveAllEventBlock() {
        var i: Int = 0
        let res = String.init(format: "%018p", unsafeBitCast(self, to: Int.self))
        for dict: [String : Any] in UIControlTemp.events {
            let address: String = dict["address"] as! String
            if address != res {
                i++
                continue
            }
            
            let dict: Dictionary<UInt, ((UIControl) -> Void)?> = dict["object"] as! Dictionary<UInt, ((UIControl) -> Void)?>
            let eventKey: UInt = dict.getUIntKey()
            UIControlTemp.events.remove(at: i)
            
            switch eventKey {
            case Event.touchDown.rawValue:
                removeTarget(self, action: #selector(touchDownBlock), for: .touchDown)
                break
            case Event.touchDownRepeat.rawValue:
                removeTarget(self, action: #selector(touchDownRepeatBlock), for: .touchDownRepeat)
                break
            case Event.touchDragInside.rawValue:
                removeTarget(self, action: #selector(touchDragInsideBlock), for: .touchDragInside)
                break
            case Event.touchDragOutside.rawValue:
                removeTarget(self, action: #selector(touchDragOutsideBlock), for: .touchDragOutside)
                break
            case Event.touchDragEnter.rawValue:
                removeTarget(self, action: #selector(touchDragEnterBlock), for: .touchDragEnter)
                break
            case Event.touchDragExit.rawValue:
                removeTarget(self, action: #selector(touchDragExitBlock), for: .touchDragExit)
                break
            case Event.touchUpInside.rawValue:
                removeTarget(self, action: #selector(touchUpInsideBlock), for: .touchUpInside)
                break
            case Event.touchUpOutside.rawValue:
                removeTarget(self, action: #selector(touchUpOutsideBlock), for: .touchUpOutside)
                break
            case Event.touchCancel.rawValue:
                removeTarget(self, action: #selector(touchCancelBlock), for: .touchCancel)
                break
            case Event.valueChanged.rawValue:
                removeTarget(self, action: #selector(valueChangedBlock), for: .valueChanged)
                break
            case Event.editingDidBegin.rawValue:
                removeTarget(self, action: #selector(editingDidBeginBlock), for: .editingDidBegin)
                break
            case Event.editingChanged.rawValue:
                removeTarget(self, action: #selector(editingChangedBlock), for: .editingChanged)
                break
            case Event.editingDidEnd.rawValue:
                removeTarget(self, action: #selector(editingDidEndBlock), for: .editingDidEnd)
                break
            case Event.editingDidEndOnExit.rawValue:
                removeTarget(self, action: #selector(editingDidEndOnExitBlock), for: .editingDidEndOnExit)
                break
            case Event.allTouchEvents.rawValue:
                removeTarget(self, action: #selector(allTouchEventsBlock), for: .allTouchEvents)
                break
            case Event.allEditingEvents.rawValue:
                removeTarget(self, action: #selector(allEditingEventsBlock), for: .allEditingEvents)
                break
            case Event.applicationReserved.rawValue:
                removeTarget(self, action: #selector(applicationReservedBlock), for: .applicationReserved)
                break
            case Event.systemReserved.rawValue:
                removeTarget(self, action: #selector(systemReservedBlock), for: .systemReserved)
                break
            case Event.allEvents.rawValue:
                removeTarget(self, action: #selector(allEventsBlock), for: .allEvents)
                break
            default:
                if #available(iOS 9.0, *) {
                    if eventKey == Event.primaryActionTriggered.rawValue {
                        removeTarget(self, action: #selector(primaryActionTriggeredBlock), for: .primaryActionTriggered)
                    }
                }
                if #available(iOS 14.0, *) {
                    if eventKey == Event.menuActionTriggered.rawValue {
                        removeTarget(self, action: #selector(menuActionTriggeredBlock), for: .menuActionTriggered)
                    }
                }
                break
            }
            
            break
        }
    }
    
    public func removeEventBlock(_ event: UIControl.Event) {
        for index in 0..<UIControlTemp.events.count {
            let dict2: Dictionary<String, Any> = UIControlTemp.events[index]
            let res = String.init(format: "%018p", unsafeBitCast(self, to: Int.self))
            let address: String = dict2["address"] as! String
            if address != res {
                continue
            }
            
            let dict: Dictionary<UInt, ((UIControl) -> Void)?> = dict2["object"] as! Dictionary<UInt, ((UIControl) -> Void)?>
            let eventKey: UInt = Array(dict.keys)[0]
            if eventKey == event.rawValue {
                UIControlTemp.events.remove(at: index)
                
                switch event {
                case .touchDown:
                    removeTarget(self, action: #selector(touchDownBlock), for: event)
                    break
                case .touchDownRepeat:
                    removeTarget(self, action: #selector(touchDownRepeatBlock), for: event)
                    break
                case .touchDragInside:
                    removeTarget(self, action: #selector(touchDragInsideBlock), for: event)
                    break
                case .touchDragOutside:
                    removeTarget(self, action: #selector(touchDragOutsideBlock), for: event)
                    break
                case .touchDragEnter:
                    removeTarget(self, action: #selector(touchDragEnterBlock), for: event)
                    break
                case .touchDragExit:
                    removeTarget(self, action: #selector(touchDragExitBlock), for: event)
                    break
                case .touchUpInside:
                    removeTarget(self, action: #selector(touchUpInsideBlock), for: event)
                    break
                case .touchUpOutside:
                    removeTarget(self, action: #selector(touchUpOutsideBlock), for: event)
                    break
                case .touchCancel:
                    removeTarget(self, action: #selector(touchCancelBlock), for: event)
                    break
                case .valueChanged:
                    removeTarget(self, action: #selector(valueChangedBlock), for: event)
                    break
                case .editingDidBegin:
                    removeTarget(self, action: #selector(editingDidBeginBlock), for: event)
                    break
                case .editingChanged:
                    removeTarget(self, action: #selector(editingChangedBlock), for: event)
                    break
                case .editingDidEnd:
                    removeTarget(self, action: #selector(editingDidEndBlock), for: event)
                    break
                case .editingDidEndOnExit:
                    removeTarget(self, action: #selector(editingDidEndOnExitBlock), for: event)
                    break
                case .allTouchEvents:
                    removeTarget(self, action: #selector(allTouchEventsBlock), for: event)
                    break
                case .allEditingEvents:
                    removeTarget(self, action: #selector(allEditingEventsBlock), for: event)
                    break
                case .applicationReserved:
                    removeTarget(self, action: #selector(applicationReservedBlock), for: event)
                    break
                case .systemReserved:
                    removeTarget(self, action: #selector(systemReservedBlock), for: event)
                    break
                case .allEvents:
                    removeTarget(self, action: #selector(allEventsBlock), for: event)
                    break
                default:
                    if #available(iOS 9.0, *) {
                        if event == .primaryActionTriggered {
                            removeTarget(self, action: #selector(primaryActionTriggeredBlock), for: event)
                        }
                    }
                    if #available(iOS 14.0, *) {
                        if event == .menuActionTriggered {
                            removeTarget(self, action: #selector(menuActionTriggeredBlock), for: event)
                        }
                    }
                    break
                }
                
                break
            }
        }
    }
    
    public func removeAllEventBlock(_ event: UIControl.Event) {
        for index in 0..<UIControlTemp.events.count {
            let dict2: Dictionary<String, Any> = UIControlTemp.events[index]
            let dict: Dictionary<UInt, ((UIControl) -> Void)?> = dict2["object"] as! Dictionary<UInt, ((UIControl) -> Void)?>
            let eventKey: UInt = Array(dict.keys)[0]
            if eventKey == event.rawValue {
                UIControlTemp.events.remove(at: index)
                
                switch event {
                case .touchDown:
                    removeTarget(self, action: #selector(touchDownBlock), for: event)
                    break
                case .touchDownRepeat:
                    removeTarget(self, action: #selector(touchDownRepeatBlock), for: event)
                    break
                case .touchDragInside:
                    removeTarget(self, action: #selector(touchDragInsideBlock), for: event)
                    break
                case .touchDragOutside:
                    removeTarget(self, action: #selector(touchDragOutsideBlock), for: event)
                    break
                case .touchDragEnter:
                    removeTarget(self, action: #selector(touchDragEnterBlock), for: event)
                    break
                case .touchDragExit:
                    removeTarget(self, action: #selector(touchDragExitBlock), for: event)
                    break
                case .touchUpInside:
                    removeTarget(self, action: #selector(touchUpInsideBlock), for: event)
                    break
                case .touchUpOutside:
                    removeTarget(self, action: #selector(touchUpOutsideBlock), for: event)
                    break
                case .touchCancel:
                    removeTarget(self, action: #selector(touchCancelBlock), for: event)
                    break
                case .valueChanged:
                    removeTarget(self, action: #selector(valueChangedBlock), for: event)
                    break
                case .editingDidBegin:
                    removeTarget(self, action: #selector(editingDidBeginBlock), for: event)
                    break
                case .editingChanged:
                    removeTarget(self, action: #selector(editingChangedBlock), for: event)
                    break
                case .editingDidEnd:
                    removeTarget(self, action: #selector(editingDidEndBlock), for: event)
                    break
                case .editingDidEndOnExit:
                    removeTarget(self, action: #selector(editingDidEndOnExitBlock), for: event)
                    break
                case .allTouchEvents:
                    removeTarget(self, action: #selector(allTouchEventsBlock), for: event)
                    break
                case .allEditingEvents:
                    removeTarget(self, action: #selector(allEditingEventsBlock), for: event)
                    break
                case .applicationReserved:
                    removeTarget(self, action: #selector(applicationReservedBlock), for: event)
                    break
                case .systemReserved:
                    removeTarget(self, action: #selector(systemReservedBlock), for: event)
                    break
                case .allEvents:
                    removeTarget(self, action: #selector(allEventsBlock), for: event)
                    break
                default:
                    if #available(iOS 9.0, *) {
                        if event == .primaryActionTriggered {
                            removeTarget(self, action: #selector(primaryActionTriggeredBlock), for: event)
                        }
                    }
                    if #available(iOS 14.0, *) {
                        if event == .menuActionTriggered {
                            removeTarget(self, action: #selector(menuActionTriggeredBlock), for: event)
                        }
                    }
                    break
                }
            }
        }
    }
    
    private func checkAndBlock(_ event: UIControl.Event) {
        /*
         let dict: Dictionary<UInt, ((UIControl) -> Void)?> = [event.rawValue : block]
         
         let res = String.init(format: "%018p", unsafeBitCast(self, to: Int.self))
         let dict2: Dictionary<String, Any> = ["address" : res, "object" : dict]
         */
        let res = String.init(format: "%018p", unsafeBitCast(self, to: Int.self))
        for currentDict: Dictionary<String, Any> in UIControlTemp.events {
            let address: String = currentDict["address"] as! String
            if address != res {
                continue
            }
            
            let dict: Dictionary<UInt, ((UIControl) -> Void)?> = currentDict["object"] as! Dictionary<UInt, ((UIControl) -> Void)?>
            
            let eventKey: UInt = Array(dict.keys)[0]
            if eventKey == event.rawValue {
                let executeBlock: ((UIControl) -> Void)? = Array(dict.values)[0]
                executeBlock?(self)
                break
            }
        }
    }
    
    @objc internal func touchDownBlock() {
        checkAndBlock(.touchDown)
    }
    
    @objc internal func touchDownRepeatBlock() {
        checkAndBlock(.touchDownRepeat)
    }
    
    @objc internal func touchDragInsideBlock() {
        checkAndBlock(.touchDragInside)
    }
    
    @objc internal func touchDragOutsideBlock() {
        checkAndBlock(.touchDragOutside)
    }
    
    @objc internal func touchDragEnterBlock() {
        checkAndBlock(.touchDragEnter)
    }
    
    @objc internal func touchDragExitBlock() {
        checkAndBlock(.touchDragExit)
    }
    
    @objc internal func touchUpInsideBlock() {
        checkAndBlock(.touchUpInside)
    }
    
    @objc internal func touchUpOutsideBlock() {
        checkAndBlock(.touchUpOutside)
    }
    
    @objc internal func touchCancelBlock() {
        checkAndBlock(.touchCancel)
    }
    
    @objc internal func valueChangedBlock() {
        checkAndBlock(.valueChanged)
    }
    @available(iOS 9.0, *)
    @objc internal func primaryActionTriggeredBlock() {
        checkAndBlock(.primaryActionTriggered)
    }
    
    @available(iOS 14.0, *)
    @objc internal func menuActionTriggeredBlock() {
        checkAndBlock(.menuActionTriggered)
    }
    
    @objc internal func editingDidBeginBlock() {
        checkAndBlock(.editingDidBegin)
    }
    
    @objc internal func editingChangedBlock() {
        checkAndBlock(.editingChanged)
    }
    
    @objc internal func editingDidEndBlock() {
        checkAndBlock(.editingDidEnd)
    }
    
    @objc internal func editingDidEndOnExitBlock() {
        checkAndBlock(.editingDidEndOnExit)
    }
    
    @objc internal func allTouchEventsBlock() {
        checkAndBlock(.allTouchEvents)
    }
    
    @objc internal func allEditingEventsBlock() {
        checkAndBlock(.allEditingEvents)
    }
    
    @objc internal func applicationReservedBlock() {
        checkAndBlock(.applicationReserved)
    }
    
    @objc internal func systemReservedBlock() {
        checkAndBlock(.systemReserved)
    }
    
    @objc internal func allEventsBlock() {
        checkAndBlock(.allEvents)
    }
    
    override public
    func styleDesign(_ design: any DesignStyleProtocol) {
        super.styleDesign(design)
        
        if design.contentVerticalAlignment != nil {
            contentVerticalAlignment = design.contentVerticalAlignment as! UIControl.ContentVerticalAlignment
        }
        
        if design.contentHorizontalAlignment != nil {
            contentHorizontalAlignment = design.contentHorizontalAlignment as! UIControl.ContentHorizontalAlignment
        }
    }
}
