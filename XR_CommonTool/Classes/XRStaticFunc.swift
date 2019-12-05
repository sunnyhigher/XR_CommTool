//
//  JFStaticFunc.swift
//  HouDaAnalysis
//
//  Created by 波 on 2017/11/20.
//  Copyright © 2017年 厚大经分. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import KRProgressHUD

//适配iOS11 的滚动 @available(iOS 11.0, *)
public func adaptScrollViewAdjust(_ scrollView :UIScrollView){
    if #available(iOS 11.0, *) {
        scrollView.contentInsetAdjustmentBehavior = .never
    }
}


// MARK: - 适配 ios11的tabelView的section的高度问题
public func adaptTabelViewSectionHeight(_ tableView:UITableView) {
    if #available(iOS 11.0, *) {
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
    }
}

/// 设置字体
public func XRFont_Regular(_ fontsize :CGFloat) ->UIFont{
    if #available(iOS 9.0, *) {
        return UIFont.init(name: "PingFangSC-Regular", size: fontsize)!
    }else {
        return UIFont.systemFont(ofSize: fontsize)
    }
}

public func XRFont_Bold(_ fontsize :CGFloat) ->UIFont{
    if #available(iOS 9.0, *) {
        return UIFont.init(name: "PingFangSC-Medium", size: fontsize)!
    }else {
        return UIFont.boldSystemFont(ofSize: fontsize)
    }
}

/// 根据颜色生成图片
public func getImageWithColor(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
}

// MARK: - 打印
public func XXLog<T>(_ message: T,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line) {
    
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent.components(separatedBy: ".swift").first ?? "未知"
    print("\n************** printStart *******************\n")
    
    print("\(fileName)[\(line)], \(method):\n\(message)")
    
    print("\n************** printEnd *****************\n")
    
    #endif
}

/// HUDView
public class HUDView: UIView {
    
    public var activityIndicatorView: NVActivityIndicatorView?
    
    public init() {
        super.init(frame: kScreen)
        
        self.isUserInteractionEnabled = true
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = kScreen
        blurView.alpha = 0.6
        self.addSubview(blurView)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect:vibrancyEffect)
        vibrancyView.frame = kScreen
        blurView.contentView.addSubview(vibrancyView)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        //ballSpinFadeLoader
        activityIndicatorView = NVActivityIndicatorView(frame: .zero, type:.ballRotateChase)
        activityIndicatorView?.frame.size = CGSize(width: 100, height: 100)
        activityIndicatorView?.center = CGPoint(x: kScreenW/2, y: kScreenH/2 * 0.9)
        activityIndicatorView?.backgroundColor = .white
        activityIndicatorView?.color = UIColor.black.withAlphaComponent(0.6)
        
        activityIndicatorView?.padding = 20
        activityIndicatorView?.cornerRadius = 10
        self.addSubview(activityIndicatorView!)
    }
    
    public func startLoading() {
        activityIndicatorView?.startAnimating()
    }
    
    
    public func remove() {
        activityIndicatorView?.stopAnimating()
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

/// 是否被授权
public func photoAlbumIsAuthorized() -> Bool {
    if !PhotoAlbumUtil.isAuthorized() {
        photoAlbumPermissions()
        return false
    }
    return true
}


public typealias actionBlock = (_ index: Int, _ action: UIAlertAction) -> Void

/// 快速调用UIAleartSheet
/// - Parameters:
///   - title: 标题显示
///   - message: 详细内容显示
///   - buttonTitles: 按钮标题数组
///   - cancel: 取消按钮显示内容
///   - actionBlock: 点击回调
public func showAleartSheet(title: String? = nil, message: String? = nil, buttonTitles: [String] = [], cancel: String? = nil, actionBlock: @escaping actionBlock) {
    
    guard !photoAlbumIsAuthorized() else { return }
    
    let aleartController = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
    
    
    for (index, title) in buttonTitles.enumerated() {
        let action = UIAlertAction(title: title, style: .default) { (action) in
            actionBlock(index, action)
        }
        aleartController.addAction(action)
    }
    
    if let cancel = cancel {
        let action = UIAlertAction(title: cancel, style: .cancel) { (action) in
            actionBlock(buttonTitles.count, action)
        }
        aleartController.addAction(action)
    }
    
    getCurrentViewController()?.present(aleartController, animated: true, completion: nil)
}

/// 打开相机
/// - Parameter target: 遵守代理的对象
public func camera(_ target: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    if UIImagePickerController.isSourceTypeAvailable(.camera){
        let  cameraPicker = UIImagePickerController()
        cameraPicker.delegate = target
        cameraPicker.allowsEditing = true
        cameraPicker.sourceType = .camera
        //在需要的地方present出来
        getCurrentViewController()?.present(cameraPicker, animated: true, completion: nil)
    } else {
        print("不支持拍照")
    }
}

/// 打开相册
/// - Parameter target: 遵守代理的对象
public func photoAlbum(_ target: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    let photoPicker =  UIImagePickerController()
    photoPicker.delegate = target
    photoPicker.allowsEditing = true
    photoPicker.sourceType = .photoLibrary
    //在需要的地方present出来
    getCurrentViewController()?.present(photoPicker, animated: true, completion: nil)
}

/// 弹出隐私权限
public func photoAlbumPermissions() {
    let alertSheet = UIAlertController(title: "Ops...", message: "The app needs access to your library to save pictures!", preferredStyle: .alert)
    // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
    let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    
    let settings = UIAlertAction(title: "Settings", style: .default) { action in
        if #available(iOS 10, *) {
            UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:],
                                      completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL.init(string: UIApplication.openSettingsURLString)!)
        }
    }
    
    alertSheet.addAction(cancelAction)
    alertSheet.addAction(settings)
    getCurrentViewController()?.present(alertSheet, animated: true, completion: nil)
}

// MARK: - 获取当前活动的viewcontroller
public func getCurrentViewController() -> UIViewController? {
    var window = UIApplication.shared.keyWindow
    //是否为当前显示的window
    if window?.windowLevel != UIWindow.Level.normal{
        let windows = UIApplication.shared.windows
        for  windowTemp in windows{
            if windowTemp.windowLevel == UIWindow.Level.normal{
                window = windowTemp
                break
            }
        }
    }
    let vc = window?.rootViewController
    return getTopVC(withCurrentVC: vc)
}

///根据控制器获取 顶层控制器
public func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
    if VC == nil {
        print("🌶： 找不到顶层控制器")
        return nil
    }
    if let presentVC = VC?.presentedViewController {
        //modal出来的 控制器
        return getTopVC(withCurrentVC: presentVC)
    } else if let tabVC = VC as? UITabBarController {
        // tabBar 的跟控制器
        if let selectVC = tabVC.selectedViewController {
            return getTopVC(withCurrentVC: selectVC)
        }
        return nil
    } else if let naiVC = VC as? UINavigationController {
        // 控制器是 nav
        return getTopVC(withCurrentVC:naiVC.visibleViewController)
    } else {
        // 返回顶控制器
        return VC
    }
}


