Pod::Spec.new do |s|
  s.name             = 'GABoardGameGeek'
  s.version          = '0.1.0'
  s.summary          = 'A Swift Library for interacting with the BoardGameGeek XMLAPI2'

  s.description      = <<-DESC
This library provides easy-to-use abstractions for interacting with the BoardGameGeek (BGG) XMLAPI2,
as well as convenient models which provide provide programmatic access to the data, without having
to deal with the complexities of parsing and error-checking the XML.
                       DESC

  s.homepage         = 'https://github.com/gca3020/GABoardGameGeek'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Geoff Amey' => 'gca3020@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/gca3020/GABoardGameGeek.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'GABoardGameGeek/Classes/**/*'

  s.dependency 'Alamofire', '~> 3.0'
  s.dependency 'SWXMLHash', '~> 2.2'
end
