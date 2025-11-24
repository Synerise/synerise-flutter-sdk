#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint synerise_flutter_sdk.podspec` to validate before publishing.
#

SYNERISE_SDK_FRAMEWORK_VERSION = '5.9.1'

Pod::Spec.new do |s|
  s.name             = 'synerise_flutter_sdk'
  s.version          = '2.6.1'
  s.summary          = 'Synerise SDK plugin for Flutter'
  s.description      = 'Flutter plugin for Synerise SDK'
  s.homepage         = 'http://synerise.com'
  s.license          = { :type => "Apache License 2.0", :file => "../LICENSE" }
  s.author           = { 'Synerise' => 'developer@synerise.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'SyneriseSDK', "#{SYNERISE_SDK_FRAMEWORK_VERSION}"
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
