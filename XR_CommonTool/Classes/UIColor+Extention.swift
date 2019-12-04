//
//  UIColor+Extention.swift
//  HouDaAnalysis
//
//  Created by 波 on 2017/11/1.
//  Copyright © 2017年 厚大经分. All rights reserved.
//


// MARK: - 颜色
public extension UIColor{
    
    convenience init(_ hex:UInt32, _ alpha:CGFloat = 1){
        self.init(red: CGFloat(((hex & 0xFF0000) >> 16))/255.0, green: CGFloat(((hex & 0xFF00) >> 8))/255.0, blue: CGFloat(((hex & 0xFF)))/255.0, alpha: alpha)
    }
    
    // rgb 为 0-255 的浮点数
    convenience init(r: CGFloat,g : CGFloat ,b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    convenience init(r :CGFloat, g :CGFloat, b :CGFloat, a :CGFloat = 1){
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    convenience init(r: Int,g : Int ,b : Int) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1){
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    class func randomColor() -> UIColor {
        let random = CGFloat(arc4random_uniform(256))
        return UIColor(r: random, g: random, b: random)
    }
    
    
    class func getRGBColor(firstColor : UIColor,endColor : UIColor) -> (CGFloat,CGFloat,CGFloat){
        let fristRGB = firstColor.getRGB()
        let endRGB = endColor.getRGB()
        return (fristRGB.0 - endRGB.0,fristRGB.1 - endRGB.1,fristRGB.2 - endRGB.2)
    }
    
    
    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255, green * 255, blue * 255)
    }
}
