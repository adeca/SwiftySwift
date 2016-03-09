Pod::Spec.new do |s|
  s.name         = "SwiftySwift"
  s.version      = "1.0.2"
  s.summary      = "SwiftySwift is a collection of useful extensions for Swift types and Cocoa objects."
  s.homepage     = "https://github.com/adeca/SwiftySwift"
  s.license      = { :type => 'MIT' }
  s.authors      = { "Agustin de Cabrera" => "agustindc@gmail.com" }
  s.source       = { :git => "https://github.com/adeca/SwiftySwift.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.platform     = :ios, '8.0'
  s.ios.deployment_target 	= "8.0"

  s.subspec 'Core' do |sub|
    sub.source_files = 'SwiftySwift/SwiftySwift.swift'
  end

  s.subspec 'Cocoa' do |sub|
    sub.source_files = 'SwiftySwift/SwiftyCocoa.swift'
    sub.dependency 'SwiftySwift/Core'
  end

  s.subspec 'Geometry' do |sub|
    sub.source_files = 'SwiftySwift/SwiftyGeometry.swift'
    sub.dependency 'SwiftySwift/Core'
  end

  s.subspec 'UIKit' do |sub|
    sub.source_files = 'SwiftySwift/SwiftyUIKit.swift'
    sub.dependency 'SwiftySwift/Cocoa'
  end

  s.subspec 'MultiRange' do |sub|
    sub.source_files = 'SwiftySwift/MultiRange.swift'
  end
end
