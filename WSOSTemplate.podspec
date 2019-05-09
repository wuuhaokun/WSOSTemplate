#
# Be sure to run `pod lib lint WSOSTemplate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WSOSTemplate'
  s.version          = '0.0.7'
  s.summary          = 'A short description of WSOSTemplate.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wuuhaokun/WSOSTemplate'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wuuhaokun' => 'w.sirius@gmail.com' }
  s.source           = { :git => 'https://github.com/wuuhaokun/WSOSTemplate.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'WSOSTemplate/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WSOSTemplate' => ['WSOSTemplate/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  #s.dependency 'ESTabBarController-swift'
  s.dependency 'AMScrollingNavbar'
  s.dependency 'ReachabilitySwift'
  s.dependency 'MJRefresh'
  s.dependency 'Toast-Swift'
  s.dependency 'SwiftyJSON'
  s.dependency 'Cache', '~> 5.2.0'
  s.dependency 'Alamofire'
  s.dependency 'ObjectMapper'
  s.dependency 'MBProgressHUD'
  s.dependency 'SnapKit'
end
