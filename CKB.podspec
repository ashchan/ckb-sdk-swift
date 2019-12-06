Pod::Spec.new do |s|
  s.name         = "CKB"
  s.version      = "0.25.0"
  s.summary      = "Swift SDK for Nervos CKB"

  s.description  = <<-DESC
  Swift SDK for Nervos CKB.
  DESC

  s.homepage     = "https://github.com/ashchan/ckb-sdk-swift"
  s.license      = "MIT"
  s.author       = { "James Chen" => "james@ashchan.com" }
  s.source       = { git: "https://github.com/ashchan/ckb-sdk-swift.git", tag: "v#{s.version.to_s}" }

  s.swift_version = '5.1'
  s.module_name = 'CKB'
  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.13"
  s.source_files = "Source/**/*.{h,swift}"
  s.public_header_files = "Source/**/*.{h}"
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.dependency 'CryptoSwift', '~> 1.2.0'
  s.dependency 'Sodium', '~> 0.8.0'
  s.dependency 'secp256k1.swift', '~> 0.1.4'
end
