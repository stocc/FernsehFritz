platform :tvos, '12.1'
use_frameworks!


abstract_target 'Fritzbox_DVBC' do
  pod 'SDWebImage'

  target :'Fritzbox_DVBC_CustomVLC'
  target :'Fritzbox_DVBC_Simulator'
  target 'Fritzbox_DVBC_VLCPod' do
      pod 'TVVLCKit', '~>3.3.0'
  end
end

