#
# Be sure to run `pod lib lint XR_CommonTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'XR_CommonTool'
    s.version          = '0.0.3'
    s.summary          = '公司自用工具集合.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/sunnyhigher/XR_CommTool'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Mr.Xr' => 'q562115005@outlook.com' }
    s.source           = { :git => 'https://github.com/sunnyhigher/XR_CommTool.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    s.swift_version = '5.0'
    s.ios.deployment_target = '11.0'
    
    s.source_files = 'XR_CommonTool/Classes/**/*'
    
    # s.resource_bundles = {
    #   'XR_CommonTool' => ['XR_CommonTool/Assets/*.png']
    # }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit'
    # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency "KRProgressHUD"
    s.dependency "SVProgressHUD"
    s.dependency "NVActivityIndicatorView"
    
end
