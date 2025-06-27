//
//  AUI.swift
//  Aquarius
//
//  Created by SONG JIN on 2024/9/13.
//

import UIKit
import WebKit
import Foundation

open class AUI: NSObject {
    public static let shared = AUI()
    //MARK: - View
    public var view: UIView {
        get {
            return UIView(frame: .zero)
        }
    }
    
    public lazy var lazyView: UIView = UIView(frame: .zero)
    
    public func view(_ view: UIView) -> UIView {
        let newView: UIView = UIView(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var imageView: UIImageView {
        get {
            return UIImageView(frame: .zero)
        }
    }
    
    public lazy var lazyImageView: UIImageView = UIImageView(frame: .zero)
    
    public func imageView(_ view: UIView) -> UIImageView {
        let newView: UIImageView = UIImageView(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var button: UIButton {
        get {
            return UIButton(frame: .zero)
        }
    }
    
    public lazy var lazyButton: UIButton = UIButton(frame: .zero)
    
    public func button(_ view: UIView) -> UIButton {
        let newView: UIButton = UIButton(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var label: UILabel {
        get {
            return UILabel(frame: .zero)
        }
    }
    
    public lazy var lazyLabel: UILabel = UILabel(frame: .zero)
    
    public func label(_ view: UIView) -> UILabel {
        let newView: UILabel = UILabel(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var aLabel: ALabel {
        get {
            return ALabel(frame: .zero)
        }
    }
    
    public lazy var lazyALabel: ALabel = ALabel(frame: .zero)
    
    public func aLabel(_ view: UIView) -> ALabel {
        let newView: ALabel = ALabel(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var collectionView: UICollectionView {
        get {
            return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        }
    }
    
    public lazy var lazyCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    public func collectionView(_ view: UIView) -> UICollectionView {
        let newView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(newView)
        return newView
    }
    
    public
    func collectionView(_ collectionViewLayout: UICollectionViewLayout) -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    }
    
    public func collectionView(_ collectionViewLayout: UICollectionViewLayout, _ view: UIView) -> UICollectionView {
        let newView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(newView)
        return newView
    }
    
    public var collectionViewCell: UICollectionViewCell {
        get {
            return UICollectionViewCell(frame: .zero)
        }
    }
    
    public lazy var lazyCollectionViewCell: UICollectionViewCell = UICollectionViewCell(frame: .zero)
    
    public func collectionViewCell(_ view: UIView) -> UICollectionViewCell {
        let newView: UICollectionViewCell = UICollectionViewCell(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var datePicker: UIDatePicker {
        get {
            return UIDatePicker(frame: .zero)
        }
    }
    
    public lazy var lazyDatePicker: UIDatePicker = UIDatePicker(frame: .zero)
    
    public func datePicker(_ view: UIView) -> UIDatePicker {
        let newView: UIDatePicker = UIDatePicker(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var navigationController: UINavigationController {
        get {
            return UINavigationController()
        }
    }
    
    public lazy var lazyNavigationController: UINavigationController = UINavigationController()
    
    public var navigationItem: UINavigationItem {
        get {
            return UINavigationItem()
        }
    }
    
    public lazy var lazyNavigationItem: UINavigationItem = UINavigationItem()
    
    public var pickerView: UIPickerView {
        get {
            return UIPickerView(frame: .zero)
        }
    }
    
    public lazy var lazyPickerView: UIPickerView = UIPickerView(frame: .zero)
    
    public func pickerView(_ view: UIView) -> UIPickerView {
        let newView: UIPickerView = UIPickerView(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var scrollView: UIScrollView {
        get {
            return UIScrollView(frame: .zero)
        }
    }
    
    public lazy var lazyScrollView: UIScrollView = UIScrollView(frame: .zero)
    
    public func scrollView(_ view: UIView) -> UIScrollView {
        let newView: UIScrollView = UIScrollView(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var _switch: UISwitch {
        get {
            return UISwitch(frame: .zero)
        }
    }
    
    public lazy var lazySwitch: UISwitch = UISwitch(frame: .zero)
    
    public func _switch(_ view: UIView) -> UISwitch {
        let newView: UISwitch = UISwitch(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var tabBarController: UITabBarController {
        get {
            return UITabBarController()
        }
    }
    
    public lazy var lazyTabBarController: UITabBarController = UITabBarController()
    
    public var tabBarItem: UITabBarItem {
        get {
            return UITabBarItem()
        }
    }
    
    public lazy var lazyTabBarItem: UITabBarItem = UITabBarItem()
    
    public var tableView: UITableView {
        get {
            return UITableView(frame: .zero)
        }
    }
    
    public lazy var lazyTableView: UITableView = UITableView(frame: .zero)
    
    public func tableView(_ view: UIView) -> UITableView {
        let newView: UITableView = UITableView(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public
    func tableView(_ style: UITableView.Style) -> UITableView {
        return UITableView(frame: .zero, style: style)
    }
    
    public func tableView(_ style: UITableView.Style, _ view: UIView) -> UITableView {
        let newView: UITableView = UITableView(frame: .zero, style: style)
        view.addSubview(newView)
        return newView
    }
    
    public var plainTableView: UITableView {
        get {
            return UITableView(frame: .zero, style: .plain)
        }
    }
    
    public lazy var lazyPlainTableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    public func plainTableView(_ view: UIView) -> UITableView {
        let newView: UITableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(newView)
        return newView
    }
    
    public var groupTableView: UITableView {
        get {
            return UITableView(frame: .zero, style: .grouped)
        }
    }
    
    public lazy var lazyGroupTableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    public func groupTableView(_ view: UIView) -> UITableView {
        let newView: UITableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(newView)
        return newView
    }
    
    @available(iOS 13.0, *)
    public var insetGroupTableView: UITableView {
        get {
            return UITableView(frame: .zero, style: .insetGrouped)
        }
    }
    @available(iOS 13.0, *)
    public lazy var lazyInsetGroupTableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    
    @available(iOS 13.0, *)
    public func insetGroupTableView(_ view: UIView) -> UITableView {
        let newView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
        view.addSubview(newView)
        return newView
    }
    
    public var tableViewCell: UITableViewCell {
        get {
            return UITableViewCell(frame: .zero)
        }
    }
    
    public lazy var lazyTableViewCell: UITableViewCell = UITableViewCell(frame: .zero)
    
    public func tableViewCell(_ view: UIView) -> UITableViewCell {
        let newView: UITableViewCell = UITableViewCell(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var aTableView: ATableView {
        get {
            return ATableView(frame: .zero)
        }
    }
    
    public lazy var lazyATableView: ATableView = ATableView(frame: .zero)
    
    public func aTableView(_ view: UIView) -> ATableView {
        let newView: ATableView = ATableView(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public func aTableView(_ style: UITableView.Style) -> ATableView {
        return ATableView(frame: .zero, style: style)
    }
    
    public func aTableView(_ style: UITableView.Style, _ view: UIView) -> ATableView {
        let newView: ATableView = ATableView(frame: .zero, style: style)
        view.addSubview(newView)
        return newView
    }
    
    public var plainATableView: ATableView {
        get {
            return ATableView(frame: .zero, style: .plain)
        }
    }
    
    public lazy var lazyPlainATableView: ATableView = ATableView(frame: .zero, style: .plain)
    
    public func plainATableView(_ view: UIView) -> ATableView {
        let newView: ATableView = ATableView(frame: .zero, style: .plain)
        view.addSubview(newView)
        return newView
    }
    
    public var groupATableView: ATableView {
        get {
            return ATableView(frame: .zero, style: .grouped)
        }
    }
    
    public lazy var lazyGroupATableView: ATableView = ATableView(frame: .zero, style: .grouped)
    
    public func groupATableView(_ view: UIView) -> ATableView {
        let newView: ATableView = ATableView(frame: .zero, style: .grouped)
        view.addSubview(newView)
        return newView
    }
    
    @available(iOS 13.0, *)
    public var insetGroupATableView: ATableView {
        get {
            return ATableView(frame: .zero, style: .insetGrouped)
        }
    }
    
    @available(iOS 13.0, *)
    public lazy var lazyInsetGroupATableView: ATableView = ATableView(frame: .zero, style: .insetGrouped)
    
    @available(iOS 13.0, *)
    public func insetGroupATableView(_ view: UIView) -> ATableView {
        let newView: ATableView = ATableView(frame: .zero, style: .insetGrouped)
        view.addSubview(newView)
        return newView
    }
    
    public var textField: UITextField {
        get {
            return UITextField(frame: .zero)
        }
    }
    
    public lazy var lazyTextField: UITextField = UITextField(frame: .zero)
    
    public func textField(_ view: UIView) -> UITextField {
        let newView: UITextField = UITextField(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var viewController: UIViewController {
        get {
            return UIViewController()
        }
    }
    
    public lazy var lazyViewController: UIViewController = UIViewController()
    
    public var searchBar: UISearchBar {
        get {
            return UISearchBar(frame: .zero)
        }
    }
    
    public lazy var lazySearchBar: UISearchBar = UISearchBar(frame: .zero)
    
    public func searchBar(_ view: UIView) -> UISearchBar {
        let newView: UISearchBar = UISearchBar(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var textView: UITextView {
        get {
            return UITextView(frame: .zero)
        }
    }
    
    public lazy var lazyTextView: UITextView = UITextView(frame: .zero)
    
    public func textView(_ view: UIView) -> UITextView {
        let newView: UITextView = UITextView(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var a_textView: ATextView {
        get {
            return ATextView(frame: .zero)
        }
    }
    
    public lazy var lazyATextView: ATextView = ATextView(frame: .zero)
    
    public func a_textView(_ view: UIView) -> ATextView {
        let newView: ATextView = ATextView(frame: .zero)
        view.addSubview(newView)
        return newView
    }
    
    public var refreshControl: UIRefreshControl {
        get {
            return UIRefreshControl()
        }
    }
    
    public lazy var lazyRefreshControl: UIRefreshControl = UIRefreshControl()
    
    public var activityIndicatorView: UIActivityIndicatorView {
        get {
            return UIActivityIndicatorView()
        }
    }
    
    public lazy var lazyActivityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    public var webView: WKWebView {
        get {
            return WKWebView()
        }
    }
    
    public lazy var lazyWebView: WKWebView = WKWebView()
    
    public var progressView: UIProgressView {
        get {
            return UIProgressView()
        }
    }
    
    public lazy var lazyProgressView: UIProgressView = UIProgressView()
    
    public var alert: UIAlertController {
        get {
            return UIAlertController(title: "", message: "", preferredStyle: .alert)
        }
    }
    
    public lazy var lazyAlert: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    public var actionSheet: UIAlertController {
        get {
            return UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        }
    }
    
    public lazy var lazyActionSheet: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
}
