#
#  Be sure to run `pod spec lint Paysafe.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/


Pod::Spec.new do |s|
  s.name             = 'Paysafe'
  s.version          = '1.1.0'
  s.summary          = 'A Paysafe apple pay SDK.'
  s.homepage         = 'https://github.com/paysafegroup/paysafe_sdk_ios.git'
  s.license          = 'MIT'
  s.author           = { 'Paysafe' => 'DeveloperCentre@OptimalPayments.com' }
  s.source           = { :git => 'https://github.com/paysafegroup/paysafe_sdk_ios.git',:commit => '40d4ef74cb3d3ec8371ab49a757d7f227b564498', :tag => '1.1.1' }
  s.platform = :ios,'7.1'
  s.requires_arc = true
  s.source_files = 'iOS_SDK/PaymentKit/*.{h,m}','iOS_SDK/MockPassKItLib/*.{h,m}'
  s.resource  = 'iOS_SDK/MockPassKItLib/PaySafeMockPaymentSummaryViewController.xib'
end
