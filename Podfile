# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Embraced' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Embraced
  pod 'ChameleonFramework', '~> 2.1'
  pod 'ReachabilitySwift', '~> 3'
  pod 'Alamofire', '~> 4.4'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
