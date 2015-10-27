Pod::Spec.new do |spec|
  spec.name         = 'SwiftySwift'
  spec.version      = '1.0.0'
  spec.source_files = 'SwiftySwift/*.swift'
  spec.ios.deployment_target = "8.0"
  spec.source  		= { :git => "https://github.com/adeca/SwiftySwift.git", :tag => "1.0.0" }
end
