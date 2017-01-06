Pod::Spec.new do |s|

  s.name         = "CYCircularScrollView"
  s.version      = "1.0.0"
  s.summary      = "Used for picture banner or information display like announcement."

  # s.description  = <<-DESC
  #                 DESC

  s.homepage     = "https://github.com/lxypeter/CYCircularScrollView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  s.author             = { "CY.Lee" => "lxypeter@sina.com" }
  # Or just: s.author    = "CY.Lee"
  # s.authors            = { "CY.Lee" => "lxypeter@sina.com" }
  # s.social_media_url   = "http://twitter.com/CY.Lee"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/lxypeter/CYCircularScrollView.git", :tag => "1.0.0" }

  s.source_files  = ["CYCircularScrollView/*", "CYCircularScrollView/Kingfisher/*"]

  # s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "Kingfisher", "~> 3.0.0"

end
