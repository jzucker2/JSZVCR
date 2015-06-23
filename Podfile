source 'https://github.com/CocoaPods/Specs.git'
workspace 'JSZVCR.xcworkspace'
xcodeproj 'Example/JSZVCR.xcodeproj'
use_frameworks!

plugin 'slather'

target 'JSZVCR_Tests', :exclusive => true do
  platform :ios, '7.0'
  xcodeproj 'Example/JSZVCR.xcodeproj'
  pod "JSZVCR", :path => "."
end
