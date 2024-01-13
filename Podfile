platform :tvos, '15.0'
use_frameworks!


abstract_target 'a_Fritzbox_DVBC' do
  pod 'SDWebImage'

  target :'Fritzbox_DVBC_Simulator'
  target 'Fritzbox_DVBC' do
      pod 'TVVLCKit', '3.3.12'
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|

            # disable code signing for pods
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end
