Pod::Spec.new do |s|
    s.name         = 'FancyAlert'
    s.version      = '0.1.0'
    s.summary      = 'fancy alert'
    s.homepage     = 'https://github.com/ChaselAn/FancyAlert'
    s.license      = 'MIT'
    s.authors      = {'ChaselAn' => '865770853@qq.com'}
    s.platform     = :ios, '9.0'
    s.source       = {:git => 'https://github.com/ChaselAn/FancyAlert.git', :tag => s.version}
    s.source_files = 'FancyAlertDemo/FancyAlert/*.swift'
    s.requires_arc = true
end
