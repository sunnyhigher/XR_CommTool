//
//  XRConfig.swift
//  Ringme&ColorCallBack
//
//  Created by Mr.Xr on 2019/10/23.
//  Copyright © 2019 炬点. All rights reserved.
//

public let kScreenW = UIScreen.main.bounds.size.width
public let kScreenH = UIScreen.main.bounds.size.height
public let kScreen = UIScreen.main.bounds
public let kScale = Int(UIScreen.main.scale)

public let kWindow = UIApplication.shared.keyWindow!

public let myAppDelegate = UIApplication.shared.delegate

/// 适配系数-宽 以6为标准
public let scaleWidth : CGFloat = kScreenW / 375.0

/// 适配系数-高 以6为标准
public let scaleHeight : CGFloat = kScreenH / 667.0


/// iPhoneX 系列机型
public let kIPhoneX = kScreenW >= 375 && kScreenH >= 812 && (UIDevice.current.systemVersion as NSString).floatValue >= Float(11.0) && !(UIDevice.current.model as NSString).isEqual(to: "iPad")


//适配iPhoneX
//获取状态栏的高度，全面屏手机的状态栏高度为44pt，非全面屏手机的状态栏高度为20pt
//状态栏高度
public let statusBarHeight = UIApplication.shared.statusBarFrame.height;

//导航栏高度
public let navigationHeight = CGFloat(statusBarHeight + 44)

//tabbar高度
public let tabBarHeight = CGFloat(statusBarHeight == 44 ? 83 : 49)

//顶部的安全距离
public let topSafeAreaHeight = CGFloat(statusBarHeight - 20)

//底部的安全距离
public let bottomSafeAreaHeight = CGFloat(tabBarHeight - 49)

// MARK: 闭包
public typealias ClickBlockVoid = ()->()
