#
# Be sure to run `pod lib lint JSZVCR.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JSZVCR"
  s.version          = "0.7.8"
  s.summary          = "A simple way to record and replay network requests for testing"
  s.description      = <<-DESC
                       Provides an XCTestCase subclass for easily
                       recording and then replaying network requests
                       and responses during testing and testing development
                       DESC
  s.homepage         = "https://github.com/jzucker2/JSZVCR"
  s.license          = 'MIT'
  s.author           = { "Jordan Zucker" => "jordan.zucker@gmail.com" }
  s.source           = { :git => "https://github.com/jzucker2/JSZVCR.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jzucker'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true
  s.deprecated_in_favor_of = 'BeKindRewind'

#  s.framework = 'XCTest'
  s.dependency 'OHHTTPStubs', '~> 4.7.0'

  #s.source_files = 'JSZVCR/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'

  s.subspec 'Core' do |core|
    core.ios.deployment_target = '8.0'
    core.tvos.deployment_target = '9.0'
    core.osx.deployment_target = '10.9'
    core.watchos.deployment_target = '2.0'
    core.source_files = 'JSZVCR/Classes/**/*'
    core.exclude_files = "JSZVCR/Classes/XCTest/*"
  end

  s.subspec 'Testing' do |testing|
    testing.framework = 'XCTest'
    testing.dependency 'JSZVCR/Core'
    testing.source_files = "JSZVCR/Classes/XCTest/*"
    testing.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'JSZTESTING=1'  }
    testing.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'JSZTESTING=1'  }
  end

  s.default_subspec = 'Testing'

end
