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

/// 宽度系数比
public let scaleWidth : CGFloat = kScreenW / 375.0

public let scaleHeight : CGFloat = kScreenH / 667.0


/// iPhoneX 系列机型
public let kIPhoneX = kScreenW >= 375 && kScreenH >= 812 && (UIDevice.current.systemVersion as NSString).floatValue >= Float(11.0) && !(UIDevice.current.model as NSString).isEqual(to: "iPad")

/// 适配iPhoneX
// 获取底部的安全距离，全面屏手机为34pt，非全面屏手机为0pt
// 底部的安全距离
public let bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0

/// 顶部的安全距离
public let topSafeAreaHeight = CGFloat(bottomSafeAreaHeight == 0 ? 0 : 24)

/// 状态栏高度
public let statusBarHeight = UIApplication.shared.statusBarFrame.height;

/// 导航栏高度
public let navigationHeight = CGFloat(bottomSafeAreaHeight == 0 ? 64 :88)

/// tabbar 高度
public let tabBarHeight = CGFloat(bottomSafeAreaHeight + 49)

// MARK: 闭包
public typealias ClickBlockVoid = ()->()
