Pod::Spec.new do |s|
  s.name         = "FYLNavigationController"
  s.version      = "1.0"
  s.summary      = "this UINavigationController Subclass Make push and Pop actions with swipe gestures"
  s.homepage     = "https://github.com/wangyangcc/FYLNavigationController"
  s.license      = 'MIT'
  s.authors      = { "wangyangcc" => "992609445@.com" " }
  s.source       = { :git => "https://github.com/wangyangcc/FYLNavigationController.git", :tag => "v#{s.version}" }
  s.platform     = :ios, '5.0'
  s.source_files = "FYLNavigationController/*.{h,m}"
  s.resources    = "FYLNavigationController/*.png"
  s.frameworks   = 'Foundation', 'UIKit'
  s.requires_arc = true
end
