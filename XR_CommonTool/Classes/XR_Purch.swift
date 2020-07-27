//
//  XR_Purch.swift
//  MagicStickers
//
//  Created by Mr.Xr on 2019/11/8.
//  Copyright © 2019 炬点. All rights reserved.
//
@objc  public class XR_Purch: NSObject {
    
    public let XR_kIsPay               = "app.isPay.com"
    public let XR_kHasTrail            = "app.hasTrail.com"
    public let XR_kWeeklyPrice         = "app.weeklyPrice.com"
    public let XR_kMonthlyPrice        = "app.monthlyPrice.com"
    public let XR_kYearlyPrice         = "app.yearlyPrice.com"
    public let XR_kTrialDescribeString = "app.trialDescribe.com"
    
    public let XR_kIsTrialWeek         = "app.kIsTrialWeek.com"
    public let XR_kIsTrialMonth        = "app.kIsTrialMonth.com"
    public let XR_kIsTrialYear         = "app.kIsTrialYear.com"
    
    //项目内购标题
    public let kLocalizedTitle         = "app.kLocalizedTitle.com"
    //USD
    public let kCurrencyCode        = "app.kCurrencyCode.com"
    //货币单位
    public let kCurrencyCodeUSB         = "app.kCurrencyCodeUSB.com"
    
 
    
    
    @objc public static let shared = XR_Purch()
    
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
   @objc public var XR_weekPriceString: String {
        get {
            return UserDefaults.standard.string(forKey: XR_kWeeklyPrice) ?? "     3 day trial,then $9.99/week"
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kWeeklyPrice)
            user.synchronize()
        }
    }
    
    /// 月订阅价格字符串
    @objc public var XR_monthPriceString: String {
        get {
            return UserDefaults.standard.string(forKey: XR_kMonthlyPrice) ?? "     3-day trial,then $19.99/month"
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kMonthlyPrice)
            user.synchronize()
        }
    }

    /// 年订阅价格字符串
    @objc public var XR_yearPriceString: String {
        get {
            return UserDefaults.standard.string(forKey: XR_kYearlyPrice) ?? "     3 day trial,then $49.99/year"
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kYearlyPrice)
            user.synchronize()
        }
    }
    
    /// 使用展示字符
    @objc public var XR_trialDescribeString: String {
        get {
            return UserDefaults.standard.string(forKey: XR_kTrialDescribeString) ?? "     3 day trial,then $49.99/year"
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: XR_kTrialDescribeString)
            user.synchronize()
        }
    }
    
    /// 周是否试用
    @objc public var XR_hasTrialWeek: Bool {
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
   @objc  public var XR_hasTrialMonth: Bool {
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
    @objc public var XR_hasTrialYear: Bool {
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
    
    /// 内购标题
    @objc public var XR_hasLocalizedTitle: String {
        
        get {
            return UserDefaults.standard.string(forKey: kLocalizedTitle) ?? "内购标题"
        }
        set {
            let user = UserDefaults.standard
            user.set(newValue, forKey: kLocalizedTitle)
            user.synchronize()
        }
    }
     
     /// 货币单位
    @objc  public var XR_hasCurrencyCode : String {
         get {
            return UserDefaults.standard.string(forKey: kCurrencyCode) ?? "$"
         }
         set {
             let user = UserDefaults.standard
             user.set(newValue, forKey: kCurrencyCode)
             user.synchronize()
         }
     }
     
     /// USD  货币符号
     @objc public var XR_hasCurrencyCodeUSB: String {
         get {
             return UserDefaults.standard.string(forKey: kCurrencyCodeUSB) ?? "USD"
         }
         set {
             let user = UserDefaults.standard
             user.set(newValue, forKey: kCurrencyCodeUSB)
             user.synchronize()
         }
     }
}
