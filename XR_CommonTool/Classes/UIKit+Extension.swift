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
extension Array {
    /// 避免数组越界
    public func safeObject(_ index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
    
    // 去重
    public func filterDuplicates<T: Equatable>(_ filter: (Element) -> T) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
    
    /// 自定义下标写法
    /// subscript用于更方便的访问集合中的数据
    /// indices.contains用于判断索引值是否在区间类
    /// - Parameter index: 索引值
    public subscript(safe index:Int) ->Element?{
        if(indices.contains(index)){
            return self[index];
        }else{
            return nil;
        }
    }
    
    /// 普通写法
    ///
    /// - Parameter index: 索引值
    /// - Returns:
    public func indexSafe(index:Int) ->Element?{
        if(index > 0 && index < count){
            return self[index];
        }
        
        return nil;
    }
}

extension Array where Element : Equatable {

    
    /// 获取数组中的指定元素的索引值
    /// - Parameter item: 元素
    /// - Returns: 索引值数组
    public func indexes(of item: Element) -> [Int] {
        var indexes = [Int]()
        for index in 0..<count where self[index] == item {
            indexes.append(index)
        }
        return indexes
    }
    
    
    /// 获取元素首次出现的位置
    /// - Parameter item: 元素
    /// - Returns: 索引值
    public func firstIndex(of item: Element) -> Int? {
        for (index, value) in lazy.enumerated() where value == item {
            return index
        }
        return nil
    }
    
    
    /// 获取元素最后出现的位置
    /// - Parameter item: 元素
    /// - Returns: 索引值
    public func lastIndex(of item: Element) -> Int? {
        return indexes(of: item).last
    }
    
}

//MARK:删除
extension Array where Element : Equatable {
    
    /// 删除数组中的指定元素
    ///
    /// - Parameter object: 元素
    public mutating func remove(object:Element) -> Void {
        for idx in self.indexes(of: object).reversed() {
            self.remove(at: idx)
        }
    }
}

/// 二分法插入元素
extension Array where Element: Comparable {
    private func binarySearchIndex(for element: Element) -> Int {
        var min = 0
        var max = count
        while min < max {
            let index = (min+max)/2
            let other = self[index]
            if other == element {
                return index
            } else if other < element {
                min = index+1
            } else {
                max = index
            }
        }
        return min
    }
    
    public mutating func binaryInsert(_ element: Element) {
        insert(element, at: binarySearchIndex(for: element))
    }
}

// MARK: - 指定位数进行四舍五入操作
extension Double {
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Float {
    public func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CGFloat {
    public func roundTo(places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}






