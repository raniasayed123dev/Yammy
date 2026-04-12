# Uncomment the next line to define a global platform for your project
platform :ios, '18.0'

target 'Yammy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'SDWebImage'
  pod 'FirebaseStorage'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
    end
  end
end
