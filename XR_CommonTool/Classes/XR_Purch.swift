//
//  XR_Purch.swift
//  MagicStickers
//
//  Created by Mr.Xr on 2019/11/8.
//  Copyright © 2019 炬点. All rights reserved.
//
public class XR_Purch: NSObject {
    
    public let XR_kIsPay               = "app.isPay.com"
    public let XR_kHasTrail            = "app.hasTrail.com"
    public let XR_kWeeklyPrice         = "app.weeklyPrice.com"
    public let XR_kMonthlyPrice        = "app.monthlyPrice.com"
    public let XR_kYearlyPrice         = "app.yearlyPrice.com"
    public let XR_kTrialDescribeString = "app.trialDescribe.com"
    
    public let XR_kIsTrialWeek         = "app.kIsTrialWeek.com"
    public let XR_kIsTrialMonth        = "app.kIsTrialMonth.com"
    public let XR_kIsTrialYear         = "app.kIsTrialYear.com"
    
    
    public static let shared = XR_Purch()
    
    /// 是否已经购买
    public var XR_hasPay: Bool {
        get {
            let hasPay = UserDefaults.standard.bool(forKey: XR_kIsPay)
            return hasPay
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kIsPay)
            user.synchronize()
        }
    }
    
    /// 是否有试用
    public var XR_hasTrail: Bool {
        get {
            return UserDefaults.standard.bool(forKey: XR_kHasTrail)
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kHasTrail)
            user.synchronize()
        }
    }
    
    /// 周订阅价格字符串
    public var XR_weekPriceString: String {
        get {
            return UserDefaults.standard.string(forKey: XR_kWeeklyPrice) ?? "     3-day trial,then $9.99 for 1 week"
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kWeeklyPrice)
            user.synchronize()
        }
    }
    
    /// 月订阅价格字符串
    public var XR_monthPriceString: String {
        get {
            return UserDefaults.standard.string(forKey: XR_kMonthlyPrice) ?? "     3-day trial,then $19.99 for 1 mouth"
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kMonthlyPrice)
            user.synchronize()
        }
    }

    /// 年订阅价格字符串
    public var XR_yearPriceString: String {
        get {
            return UserDefaults.standard.string(forKey: XR_kYearlyPrice) ?? "     3-day trial,then $49.99 for 1 year"
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kYearlyPrice)
            user.synchronize()
        }
    }
    
    /// 使用展示字符
    public var XR_trialDescribeString: String {
        get {
            return UserDefaults.standard.string(forKey: XR_kTrialDescribeString) ?? "     3-day trial,then $49.99 for 1 year"
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kTrialDescribeString)
            user.synchronize()
        }
    }
    
    /// 周是否试用
    public var XR_hasTrialWeek: Bool {
        get {
            return UserDefaults.standard.bool(forKey: XR_kHasTrail)
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kHasTrail)
            user.synchronize()
        }
    }
    
    /// 月是否试用
    public var XR_hasTrialMonth: Bool {
        get {
            return UserDefaults.standard.bool(forKey: XR_kIsTrialMonth)
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kIsTrialMonth)
            user.synchronize()
        }
    }
    
    /// 年是否试用
    public var XR_hasTrialYear: Bool {
        get {
            return UserDefaults.standard.bool(forKey: XR_kIsTrialYear)
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kIsTrialYear)
            user.synchronize()
        }
    }
    
    /// 是否获取到价格信息
    public var requestState: Bool = false
}


