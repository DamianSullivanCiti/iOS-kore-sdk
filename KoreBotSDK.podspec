Pod::Spec.new do |s|
    s.name = 'KoreBotSDK'
    s.version = '0.2'
    s.license  = {:type => 'MIT', :file => 'KoreBotSDK/LICENSE' }
    s.summary = 'Citi customisation of KoreSDK'
    s.homepage = 'https://kore.ai'
    s.author = {'Srinivas Vasadi' => 'srinivas.vasadi@kore.com'}
    s.source = {:git => 'https://github.com/DamianSullivanCiti/iOS-kore-sdk.git', :tag => s.version, :submodules => true }
    s.requires_arc = true

    s.public_header_files = 'KoreBotSDK/Library/KoreBotSDK/KoreBotSDK/KoreBotSDK.h'
    s.source_files = 'KoreBotSDK/Library/KoreBotSDK/KoreBotSDK/KoreBotSDK.h'

    s.ios.deployment_target = '8.0'
    s.swift_version = '4.0'

    s.subspec 'Library' do |ss|
        ss.ios.deployment_target = '8.0'
        ss.source_files = 'KoreBotSDK/Library/KoreBotSDK/KoreBotSDK/**/*.{h,m,swift}', 'KoreBotSDK/Library/Widgets/Widgets/**/*.{h,m,txt,swift}'

        ss.exclude_files = 'KoreBotSDK/Library/KoreBotSDK/KoreBotSDK/KoreBotSDK.{h}'
        ss.exclude_files = 'KoreBotSDK/KoreBotSDKDemo/*.{*}'
        ss.exclude_files = 'KoreBotSDK/Library/SpeechToText/*.{*}'
        ss.exclude_files = 'KoreBotSDK/Library/TextParser/*.{*}'
        ss.exclude_files = 'KoreBotSDK/Library/Widgets/*.{*}'
        
        ss.resource_bundles = {
            'Widgets' => ['KoreBotSDK/Library/Widgets/Widgets/**/*.xib']
        }
        
        ss.dependency 'Mantle', '2.0.2'
        ss.dependency 'AFNetworking', '3.2.0'
        ss.dependency 'Starscream', '~> 3.0.2'

        ss.ios.frameworks = 'SystemConfiguration', 'GD', 'MessageUI', 'AdSupport', 'QuickLook', 'CoreData', 'Security', 'CFNetwork', 'MobileCoreServices', 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'LocalAuthentication'
        ss.ios.libraries = 'stdc++', 'z'

        ss.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO'}
    end
end
