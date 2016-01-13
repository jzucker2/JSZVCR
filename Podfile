source 'https://github.com/CocoaPods/Specs.git'
workspace 'JSZVCR.xcworkspace'
xcodeproj 'Example/JSZVCR.xcodeproj'
use_frameworks!

target 'Tests-iOS-ObjC', :exclusive => true do
  platform :ios, '8.0'
  xcodeproj 'Example/JSZVCR.xcodeproj'
  pod "JSZVCR", :path => "."
  pod 'AFNetworking', '~>3.0'
end

target 'Tests-OSX-ObjC', :exclusive => true do
    platform :osx, '10.9'
    xcodeproj 'Example/JSZVCR.xcodeproj'
    pod "JSZVCR", :path => "."
    pod 'AFNetworking', '~>3.0'
end

target 'Tests-tvOS-ObjC', :exclusive => true do
    platform :tvos, '9.0'
    xcodeproj 'Example/JSZVCR.xcodeproj'
    pod "JSZVCR", :path => "."
    pod 'AFNetworking', '~>3.0'
end

target 'CoreTests-iOS-ObjC', :exclusive => true do
    platform :ios, '8.0'
    xcodeproj 'Example/JSZVCR.xcodeproj'
    pod "JSZVCR/Core", :path => "."
    pod 'AFNetworking', '~>3.0'
end
