# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def common_pods
	pod 'sdk', :path => 'sdk.podspec'
end

target 'APIExample-OC' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'FaceBeauty'
  common_pods
end

target 'Agora-ScreenShare-Extension-OC' do
  use_frameworks!
  
  common_pods
end

target 'SimpleFilter' do
  use_frameworks!
  
  common_pods
end

pre_install do |installer|
   system("sh .download_script.sh 4.5.0 true")
end
