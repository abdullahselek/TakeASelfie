platform :ios, '11.0'
use_frameworks!

def product_pods
	pod 'TakeASelfie', :path => '.'
end

workspace 'TakeASelfie.xcworkspace'
project 'TakeASelfie.xcodeproj'

target 'TakeASelfie' do
  	target 'TakeASelfieTests' do
    	 inherit! :search_paths
    end
end

target 'SampleApp' do
	project 'SampleApp/SampleApp.xcodeproj'
	inherit! :search_paths
	product_pods
end
