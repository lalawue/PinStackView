#
#  Be sure to run `pod spec lint PageEventBus.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "PinStackView"
  spec.version      = "0.2.20221225"
  spec.summary      = "Frame base StackView relies on PinLayout"
  spec.description  = "Frame base StackView relies on PinLayout, with inner padding, equal distribution, dynamic axis length, grow/shrink items capability"
  spec.platform     = :ios

  spec.homepage     = "https://github.com/lalawue/PinStackView"
  spec.license      = "MIT"

  spec.author       = "lalawue"

  spec.source       = { :git => "https://github.com/lalawue/PinStackView.git", :tag => "#{spec.version}" }

  spec.source_files  = 'PinStackView/Classes/**/*'

  spec.ios.deployment_target = '9.0'
  spec.swift_version = '4.2'

  spec.ios.dependency 'PinLayout'
end

