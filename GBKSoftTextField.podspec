
Pod::Spec.new do |spec|

  spec.name         = "GBKSoftTextField"
  spec.version      = "0.0.6"
  spec.summary      = "Material like UITextField for GBKSoft iOS team needs"
  spec.license      = "MIT"
  spec.author       = { "Artem Korzh" => "korzh.aa@gbksoft.com" }
  spec.homepage     = "https://gitlab.gbksoft.net/korzh-aa/gbksofttextfield"
  spec.source       = { :git => "https://gitlab.gbksoft.net/korzh-aa/gbksofttextfield", :tag => "#{spec.version}" }
  spec.ios.deployment_target = "10.0"
  spec.swift_version = "5.1"
  spec.source_files  = "GBKSoftTextField/*.swift"

end
