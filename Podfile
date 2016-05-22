# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

# These are the pods used in both the app and the tests
def shared_pods
    pod 'Alamofire', '~> 3.3'
    pod 'SWXMLHash', '~> 2.3'
end

# The main target
target 'GABoardGameGeek' do
    shared_pods
end

# Unit Testing Pods
target 'GABoardGameGeekTests' do
    shared_pods
    pod 'Nimble', '~> 4.0'
    pod 'Quick', '~> 0.9'
    #pod 'DVR', '~> 0.3'
end