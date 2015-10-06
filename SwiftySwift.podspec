Pod::Spec.new do |spec|
  spec.name         = 'SwiftySwift'
  spec.version      = '0.1.0'
  spec.source_files = 'SwiftySwift/*.swift'
  spec.ios.deployment_target = "8.0"
  spec.source  		= { :git => "https://github.com/adeca/SwiftySwift.git", :branch => "master"}
end
