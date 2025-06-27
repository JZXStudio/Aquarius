//
//  ATableView.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/5/10.
//

import UIKit
import Foundation

open class ATableView: UITableView {
    internal var heightForRowAtBlock: ((_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat)?
    internal var numberOfRowsInSectionBlock: ((_ tableView: UITableView, _ section: Int) -> Int)?
    internal var cellForRowAtBlock: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?
    internal var didSelectRowAtBlock: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?
    internal var willDisplayBlock: ((_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?
    internal var numberOfSectionsBlock: ((_ tableView: UITableView) -> Int)?
    internal var heightForFooterInSectionBlock: ((_ tableView: UITableView, _ section: Int) -> CGFloat)?
    internal var viewForFooterInSectionBlock: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
    internal var editingStyleForRowAtBlock: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle)?
    internal var commitForRowAtBlock: ((_ tableView: UITableView, _ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void)?
    internal var heightForHeaderInSectionBlock: ((_ tableView: UITableView, _ section: Int) -> CGFloat)?
    internal var viewForHeaderInSectionBlock: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
    
    deinit {
        self.delegate = nil
        self.dataSource = nil
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfRowsInSection(_ block: @escaping ((_ tableView: UITableView, _ section: Int) -> Int)) {
        numberOfRowsInSectionBlock = block
    }
    
    public func cellForRowAt(_ block: @escaping ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)) {
        cellForRowAtBlock = block
    }
    
    public func heightForRowAt(_ block: @escaping ((_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat)) {
        heightForRowAtBlock = block
    }
    
    public func didSelectRowAt(_ block: @escaping ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)) {
        didSelectRowAtBlock = block
    }
    
    public func willDisplay(_ block: @escaping ((_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)) {
        willDisplayBlock = block
    }
    
    public func numberOfSections(_ block: @escaping ((_ tableView: UITableView) -> Int)) {
        numberOfSectionsBlock = block
    }
    
    public func heightForFooterInSection(_ block: @escaping ((_ tableView: UITableView, _ section: Int) -> CGFloat)) {
        heightForFooterInSectionBlock = block
    }
    
    public func editingStyleForRowAt(_ block: @escaping ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle)) {
        editingStyleForRowAtBlock = block
    }
    
    public func viewForFooterInSection(_ block: @escaping ((_ tableView: UITableView, _ section: Int) -> UIView?)) {
        viewForFooterInSectionBlock = block
    }
    
    public func commitForRowAt(_ block: @escaping ((_ tableView: UITableView, _ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void)) {
        commitForRowAtBlock = block
    }
    
    public func heightForHeaderInSection(_ block: @escaping ((_ tableView: UITableView, _ section: Int) -> CGFloat)) {
        heightForHeaderInSectionBlock = block
    }
    
    public func viewForHeaderInSection(_ block: @escaping ((_ tableView: UITableView, _ section: Int) -> UIView?)) {
        viewForHeaderInSectionBlock = block
    }
}

extension ATableView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if heightForRowAtBlock != nil {
            return heightForRowAtBlock!(tableView, indexPath)
        } else {
            return 1.0
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if numberOfRowsInSectionBlock != nil {
            return numberOfRowsInSectionBlock!(tableView, section)
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cellForRowAtBlock != nil {
            return cellForRowAtBlock!(tableView, indexPath)
        } else {
            return A.ui.tableViewCell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if didSelectRowAtBlock != nil {
            didSelectRowAtBlock!(tableView, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if willDisplayBlock != nil {
            willDisplayBlock!(tableView, cell, indexPath)
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if numberOfSectionsBlock != nil {
            return numberOfSectionsBlock!(tableView)
        } else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if heightForFooterInSectionBlock != nil {
            return heightForFooterInSectionBlock!(tableView, section)
        } else {
            return 1.0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewForFooterInSectionBlock != nil {
            return viewForFooterInSectionBlock!(tableView, section)
        } else {
            return A.ui.view
        }
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if editingStyleForRowAtBlock != nil {
            return editingStyleForRowAtBlock!(tableView, indexPath)
        } else {
            return .none
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if commitForRowAtBlock != nil {
            commitForRowAtBlock!(tableView, editingStyle, indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if heightForHeaderInSectionBlock != nil {
            return heightForHeaderInSectionBlock!(tableView, section)
        } else {
            return 1.0
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewForHeaderInSectionBlock != nil {
            return viewForHeaderInSectionBlock!(tableView, section)
        } else {
            return A.ui.view
        }
    }
}
