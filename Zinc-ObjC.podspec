Pod::Spec.new do |s|
  s.name     = 'Zinc-ObjC'
  s.version  = '0.0.1'
  s.summary  = ''
  s.homepage = 'https://github.com/mindsnacks/Zinc-ObjC'
  s.author   = { 'Andy Mroczkowski' => 'andy@mrox.net' }
  s.source   = { :git => 'https://github.com/mindsnacks/Zinc-ObjC.git', :commit => '118995ca908dc947c8363dfd4e88033a73142c99' }
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.platform = :ios, '5.0'
  s.source_files = 'Zinc'
  s.public_header_files = 'Zinc/Zinc.h'

  s.frameworks = 'Foundation', 'CFNetwork', 'SystemConfiguration'
  s.libraries = 'libz'

  #s.xcconfig = { 'OTHER_LDFLAGS' => '-framework SomeRequiredFramework' }

  s.dependency 'AFNetworking', '~> 1.0'
  s.dependency 'AMFoundation', '~> 0.1.3'
end

