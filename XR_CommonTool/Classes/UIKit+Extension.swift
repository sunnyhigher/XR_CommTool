//
//  UIKit+Extension.swift
//  News
//
//  Created by 杨蒙 on 2017/12/12.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import CoreText

public protocol StoryboardLoadable {}
public extension StoryboardLoadable where Self: UIViewController {
    /// 提供 加载方法
    static func loadStoryboard() -> Self {
        return UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}

public protocol NibLoadable {}
public extension NibLoadable {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}

public protocol RegisterCellFromNib {}
public extension RegisterCellFromNib {
    
    static var identifier: String { return "\(self)" }
    
    static var nib: UINib? { return UINib(nibName: "\(self)", bundle: nil) }
}

public extension UITableView {
    /// 注册  nib cell 的方法
    func XR_registerNibCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.identifier)
        }
        else {
            register(cell, forCellReuseIdentifier: T.identifier)
        }
    }
    
    /// 注册 cell 的方法
    func XR_registerCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        register(cell, forCellReuseIdentifier: T.identifier)
    }
    
    /// 从缓存池池出队已经存在的 cell
    func XR_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

public extension UICollectionView {
    /// 注册 nib cell 的方法
    func XR_registerNibCell<T: UICollectionViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        if let nib = T.nib {
            register(nib, forCellWithReuseIdentifier: T.identifier)
        }
        else {
            register(cell, forCellWithReuseIdentifier: T.identifier)
        }
        
    }
    
    /// 注册 cell 的方法
    func XR_registerCell<T: UICollectionViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        register(cell, forCellWithReuseIdentifier: T.identifier)
    }
    
    /// 从缓存池池出队已经存在的 cell
    func XR_dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    /// 注册头部
    func XR_registerSupplementaryHeaderView<T: UICollectionReusableView>(reusableView: T.Type) where T: RegisterCellFromNib {
        // T 遵守了 RegisterCellOrNib 协议，所以通过 T 就能取出 identifier 这个属性
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
        } else {
            register(reusableView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier)
        }
    }
    
    /// 获取可重用的头部
    func XR_dequeueReusableSupplementaryHeaderView<T: UICollectionReusableView>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}

// MARK: - 避免数组越界
public extension Array {
    /// 避免数组越界
    func safeObject(_ index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
    
    // 去重
    func filterDuplicates<T: Equatable>(_ filter: (Element) -> T) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}


public extension NSObject {
    
    // MARK:返回className
    var ClassName:String {
        get{
            let name = type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            } else {
                return name;
            }
        }
    }
}


