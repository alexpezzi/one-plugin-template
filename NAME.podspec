
Pod::Spec.new do |s|
  s.name             = '${POD_PLUGIN_NAME}'
  s.version          = '0.1.0'
  s.summary          = '${POD_PLUGIN_NAME} description.'
  s.homepage         = 'https://github.com/Accedo-Products/one-client-apple'
  s.author           = { '${USER_NAME}' => '${USER_EMAIL}' }
  s.source           = { :git => 'https://github.com/Accedo-Products/one-client-apple.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  
  s.info_plist = { 'NSPrincipalClass' => '${POD_PLUGIN_NAME}' }

  s.source_files = 'Classes/**/*'
  
  s.frameworks = 'Foundation'
  
  s.dependency 'OneCore'
  
end
