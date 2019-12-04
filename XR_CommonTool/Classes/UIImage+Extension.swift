//
//  UIImage+Extension.swift
//  HD_PublicLib_Example
//
//  Created by 波 on 2018/3/2.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

public extension UIImage {
    /// 原图
    func Original() -> UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }
    
    /**
     resize and crop image
     
     - parameter toSize: destnation size
     
     - returns: destination image
     */
    func resizeAndCropImage(toSize: CGSize) -> UIImage{
        
        let widthFactor = toSize.width / self.size.width
        let heightFactor =  toSize.height / self.size.height
        
        var positionX:CGFloat = 0
        var positionY:CGFloat = 0
        let scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor
        
        let scaleWidth = scaleFactor * self.size.width
        let scaleHeight = scaleFactor * self.size.height
        
        if widthFactor > heightFactor {
            positionY = (toSize.height - scaleHeight) * 0.5
        } else {
            positionX = (toSize.width - scaleWidth) * 0.5
        }
        
        UIGraphicsBeginImageContext(toSize)
        self.draw(in: CGRect(x: positionX, y: positionY, width: scaleWidth, height: scaleHeight))
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    
}

// MARK: - 修改图片尺寸
public extension UIImage {
    func scaleToSize(size:CGSize) -> UIImage {
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

// MARK: - 改变图片颜色
public extension UIImage {
    /// 改变图片颜色
    /// - Parameter color: 改变后的颜色
    func changeColor(color:UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)//kCGBlendModeNormal
        context?.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!);
        color.setFill()
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}

// MARK: - 绘制渐变图片
public extension UIImage {
    /// 绘制横向渐变
    /// - Parameter startColor: 开始颜色
    /// - Parameter endColor: 结束颜色
    /// - Parameter size: 尺寸
    class func drawLandscapeLinearGradient(startColor: UIColor, endColor: UIColor, size: CGSize) -> UIImage {
        
        //创建CGContextRef
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        let path = UIBezierPath.init()
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: 0, y: size.height))
        path.addLine(to: CGPoint.init(x: size.width, y: size.height))
        path.addLine(to: CGPoint.init(x: size.width, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations = [CGFloat(0.0), CGFloat(1.0)]
        let colors = [startColor.cgColor, endColor.cgColor]
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        let pathRect: CGRect = path.cgPath.boundingBox
        
        //具体方向可根据需求修改
        let startPoint = CGPoint.init(x: pathRect.minX, y: pathRect.midY)
        let endPoint = CGPoint.init(x: pathRect.maxX, y: pathRect.midY)
        
        context?.saveGState()
        context?.addPath(path.cgPath)
        context?.clip()
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context?.restoreGState()
        //获取绘制的图片
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    /// 绘纵向渐变
    /// - Parameter startColor: 开始颜色
    /// - Parameter endColor: 结束颜色
    /// - Parameter size: 尺寸
    class func drawPortraitLinearGradient(startColor: UIColor, endColor: UIColor, size: CGSize) -> UIImage {
        
        //创建CGContextRef
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        let path = UIBezierPath.init()
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: 0, y: size.height))
        path.addLine(to: CGPoint.init(x: size.width, y: size.height))
        path.addLine(to: CGPoint.init(x: size.width, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations = [CGFloat(0.0), CGFloat(1.0)]
        let colors = [startColor.cgColor, endColor.cgColor]
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        let pathRect: CGRect = path.cgPath.boundingBox
        
        //具体方向可根据需求修改
        let startPoint = CGPoint.init(x: pathRect.minX, y: pathRect.minY)
        let endPoint = CGPoint.init(x: pathRect.maxX, y: pathRect.maxY)
        
        context?.saveGState()
        context?.addPath(path.cgPath)
        context?.clip()
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context?.restoreGState()
        //获取绘制的图片
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
}

