
Pod::Spec.new do |spec|

  spec.name         = "GBKSoftTextField"
  spec.version      = "0.0.1"
  spec.summary      = "Material like UITextField for GBKSoft iOS team needs"

  spec.homepage     = "https://gitlab.gbksoft.net/korzh-aa/gbksofttextfield"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "Artem Korzh" => "korzh.aa@gbksoft.com" }

  spec.source       = { :git => "https://gitlab.gbksoft.net/korzh-aa/gbksofttextfield", :tag => "#{spec.version}" }

  spec.source_files  = "GBKSoftTextField.swift"

end
