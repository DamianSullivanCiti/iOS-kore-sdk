#
# Be sure to run `pod lib lint KoreBotSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name         = "KoreBotSDK"
  s.version      = "0.2.0"
  s.summary      = "Citi customisations of KoreBotSDK."
  s.homepage     = "https://github.com/damianjsullivan/KoreBotSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "DamianSullivanCiti" => "damian.sullivan@citi.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/damiansullivanciti/KoreBotSDK.git", :tag => "#{s.version}" }
  s.source_files = "Sources/**/*"
  s.requires_arc = true
  s.swift_version = '4.0'

  s.dependency "Mantle", "~> 2.0.2"
  s.dependency "Starscream", "~> 3.0.5"
  s.dependency "AFNetworking", "~> 3.2.0"

  s.ios.frameworks = 'SystemConfiguration', 'GD', 'MessageUI', 'AdSupport', 'QuickLook', 'CoreData', 'Security', 'CFNetwork', 'MobileCoreServices', 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'LocalAuthentication'
  s.ios.libraries = 'stdc++', 'z'

  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO'}

  s.resource_bundles = {
    'Widgets' => ['Sources/Widgets/**/*.xib']
  }

end
