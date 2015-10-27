Pod::Spec.new do |s|
  s.name         = "SwiftySwift"
  s.version      = "1.0.1"
  s.summary      = "SwiftySwift is a collection of useful extensions for Swift types and Cocoa objects."
  s.homepage     = "https://github.com/adeca/SwiftySwift"
  s.license      = { :type => 'MIT' }
  s.authors      = { "Agustin de Cabrera" => "agustindc@gmail.com" }
  s.source       = { :git => "https://github.com/adeca/SwiftySwift.git", :tag => s.version.to_s }
  s.source_files = 'SwiftySwift/*.swift'
  s.requires_arc = true
  s.platform     = :ios, '8.0'
  s.ios.deployment_target 	= "8.0"
end
