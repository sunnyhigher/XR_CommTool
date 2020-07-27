//
//  Data+Extension.swift
//  KRActivityIndicatorView
//
//  Created by Mr.Xr on 2020/7/25.
//

// MARK: - NSObject
extension NSObject {
    
    // MARK:返回className
    public var ClassName:String {
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
