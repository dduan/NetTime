Pod::Spec.new do |spec|
  spec.name                      = "NetTime"
  spec.version                   = "0.0.4"
  spec.summary                   = "RFC 3339 compliant date/time data types."
  spec.homepage                  = "https://github.com/dduan/NetTime"
  spec.license                   = { :type => "MIT", :file => "LICENSE.md" }
  spec.author                    = { "Daniel Duan" => "daniel@duan.ca" }
  spec.social_media_url          = "https://twitter.com/daniel_duan"
  spec.ios.deployment_target     = "8.0"
  spec.osx.deployment_target     = "10.10"
  spec.tvos.deployment_target    = "9.0"
  spec.watchos.deployment_target = "2.0"
  spec.swift_version             = '4.2.1'
  spec.source                    = { :git => "https://github.com/dduan/NetTime.git", :tag => "#{spec.version}" }
  spec.source_files              = "Sources/**/*.swift"
  spec.requires_arc              = true
  spec.module_name               = "NetTime"
end
