Pod::Spec.new do |s|
  s.name              	= "Paysafe_SDK"
  s.version           	= "2.1.0"
  s.summary           	= "Paysafe SDK handling 3DS 2 and Apple Pay"

  s.license           	= "MIT"
  s.author            	= { 'Paysafe' => 'DeveloperCentre@OptimalPayments.com' }
  s.documentation_url 	= "https://developer.paysafe.com/en/sdks/mobile/ios/overview/"
  s.homepage          	= "https://github.com/paysafegroup/paysafe_sdk_ios"

  s.source              = { :git => "https://github.com/paysafegroup/paysafe_sdk_ios.git", :tag => s.version }
  s.source_files      	= 'Paysafe_SDK/**/*.{swift,h,m}'
  s.resources         	= 'Paysafe_SDK/**/*.html','**/*paysafe_sdk_versioning-Info.plist'

  s.platform          	= :ios, "10.0"
  s.swift_version       = '5.0'
  s.requires_arc        = true
  s.vendored_frameworks = "Frameworks/CardinalMobile.framework"

end
