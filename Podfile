source 'https://github.com/CocoaPods/Specs.git'
workspace 'JSZVCR.xcworkspace'
xcodeproj 'Example/JSZVCR.xcodeproj'
use_frameworks!

begin  
	gem 'slather'
rescue Gem::LoadError
	puts 'install slather for code coverage ("sudo gem install slather")'
else
	plugin 'slather'
end

target 'JSZVCR_Tests', :exclusive => true do
  platform :ios, '7.0'
  xcodeproj 'Example/JSZVCR.xcodeproj'
  pod "JSZVCR", :path => "."
  pod 'AFNetworking', '~> 2.5'
end

target 'JSZVCR_Tests-Swift', :exclusive => true do
    platform :ios, '7.0'
    xcodeproj 'Example/JSZVCR.xcodeproj'
    pod "JSZVCR", :path => "."
end
