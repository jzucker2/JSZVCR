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
  s.version          = "0.7.1"
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

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.framework = 'XCTest'
  s.dependency 'OHHTTPStubs', '~> 4.7.0'

  s.source_files = 'JSZVCR/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
end
