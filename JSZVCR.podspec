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
  s.version          = "0.3.7"
  s.summary          = "A simple way to record network requests"
#  s.description      = <<-DESC
#                       An optional longer description of JSZVCR
#
#                       * Markdown format.
#                       * Don't worry about the indent, we strip it!
#                       DESC
  s.homepage         = "https://github.com/jzucker2/JSZVCR"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jordan Zucker" => "jordan.zucker@gmail.com" }
  s.source           = { :git => "https://github.com/jzucker2/JSZVCR.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jzucker'

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.framework = 'XCTest'
  s.dependency 'OHHTTPStubs', '~> 4.0'

  s.source_files = 'JSZVCR/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
