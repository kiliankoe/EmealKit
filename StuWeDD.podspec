Pod::Spec.new do |s|
  s.name        = "StuWeDD"
  s.version     = "0.2.0"
  s.summary     = "Access Studentenwerk Dresden data"
  s.description = <<-DESC
    Access some of the data the Studentenwerk Dresden has to offer.
  DESC

  s.homepage         = "https://github.com/kiliankoe/StuWeDD"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Kilian Koeltzsch" => "me@kilian.io" }
  s.social_media_url = "https://twitter.com/kiliankoe"

  s.ios.deployment_target     = "8.0"
  s.osx.deployment_target     = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target    = "9.0"

  s.source       = { :git => "https://github.com/kiliankoe/StuWeDD.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"
  s.frameworks   = "Foundation"
end
