Pod::Spec.new do |s|
    s.name             = "LDBusMediator"
    s.version          = "1.0.0"
    s.summary          = "Bus中间件，用于URL导航和服务调用"
    s.description      = "通过BusMediator＋connector进行业务组件的组件化通信，主要完成URL页面跳转，以及服务调用"
    s.license          = {:type => 'MIT', :file => 'LICENSE'}
    s.homepage         = 'https://git.ms.netease.com/commonlibraryios/LDBusMediator.git'
    s.author           = { "huipang" => "huipang@corp.netease.com" }
    s.source           = { :git => "https://git.ms.netease.com/commonlibraryios/LDBusMediator.git", :tag => "#{s.version}" }

    s.platform              = :ios, '7.0'
    s.ios.deployment_target = '7.0'
    s.public_header_files = 'LDBusMediator/LDBusConnectorPrt.h','LDBusMediator/LDBusMediator.h', 'LDBusMediator/LDBusNavigator.h', 'LDBusMediator/UIViewController+NavigationTip.h'
    s.source_files = 'LDBusMediator/*.{h,m}'
    s.prefix_header_contents = '#import <LDBusMediator/LDBusMediator.h>', '#import <LDBusMediator/LDBusConnectorPrt.h>'
    s.requires_arc = true
end
