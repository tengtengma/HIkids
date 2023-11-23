# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

target 'Hikids' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Hikids
  
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
  end

    pod 'SDWebImage'
    pod 'AFNetworking'
    pod 'Masonry'
    pod 'MJExtension'
    pod 'MBProgressHUD'
    pod 'MJRefresh'
    pod 'lottie-ios'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'BaiduMobStatCodeless'
#    pod 'JPush'   


end
