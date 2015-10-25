#
# Be sure to run `pod lib lint DRYPagerViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DRYPagerViewController"
  s.version          = "1.0.0"
  s.summary          = "Container view controller, capable of paging view controllers infinitely."

  s.description      = <<-DESC
                        This is our alternative to the (somtimes too limited) UIPageViewController.
                       DESC

  s.homepage         = "https://github.com/appfoundry/DRYPagerViewController"
  s.license          = 'MIT'
  s.author           = { "Michael Seghers" => "mike@appfoundry.be" }
  s.source           = { :git => "https://github.com/appfoundry/DRYPagerViewController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/AppFoundryBE'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DRYPagerViewController' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit'
end
