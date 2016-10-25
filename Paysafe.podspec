#
#  Be sure to run `pod spec lint Paysafe.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/


Pod::Spec.new do |s|
    
  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
    
  s.name             = 'Paysafe'
  s.version          = '1.2.0'
  s.summary          = 'A Paysafe apple pay SDK.'
  s.homepage         = 'https://github.com/paysafegroup/paysafe_sdk_ios'
  
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  
  s.license          = 'MIT'
  
  # Or just: s.author    = "paysafe"
  # s.authors            = { "Paysafe" => "DeveloperCentre@OptimalPayments.com" }

  
  s.author           = { 'Paysafe' => 'DeveloperCentre@OptimalPayments.com' }
  
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #
  
  s.source           = { :git => 'https://github.com/paysafegroup/paysafe_sdk_ios.git',:commit => '99791151d0a590bbfb2f7dda0166c1ed41e89b12', :tag => '1.2.0' }
  
  # s.platform     = :ios
  # When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  
  s.platform = :ios,'7.1'
  s.requires_arc = true
  
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #
  
  s.source_files = 'iOS_SDK/PaymentKit/*.{h,m}','iOS_SDK/MockPassKItLib/*.{h,m}'
  #s.exclude_files = "Classes/Exclude"
  
  # s.public_header_files = "Classes/**/*.h"
  
  
  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #
  
  s.resource  = 'iOS_SDK/MockPassKItLib/PaySafeMockPaymentSummaryViewController.xib'
  # s.resources = "Resources/*.png"
  
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  
  
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #
  
  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"
  
  
  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.
  
  # s.requires_arc = true
  
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
end
