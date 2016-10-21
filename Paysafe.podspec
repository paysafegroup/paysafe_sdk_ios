Pod::Spec.new do |s|
  s.name             = 'Paysafe'
  s.version          = '1.0.0'
  s.summary          = 'A Paysafe apple pay SDK.'
  s.homepage         = 'https://github.com/paysafegroup/paysafe_sdk_ios.git'
  s.license          = 'MIT'
  s.author           = { 'Paysafe' => 'DeveloperCentre@OptimalPayments.com' }
  s.source           = { :git => 'https://github.com/paysafegroup/paysafe_sdk_ios.git', :tag => '1.0.0' }
  s.platform = :ios
  s.requires_arc = true
  s.source_files = 'iOS_SDK/PaymentKit/*.{h,m}','iOS_SDK/MockPassKItLib/*.{h,m}'
  s.resource  = 'iOS_SDK/MockPassKItLib/PaySafeMockPaymentSummaryViewController.xib'

end
