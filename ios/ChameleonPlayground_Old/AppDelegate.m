//
//  AppDelegate.m
//  ChameleonPlayground
//
//  Created by gaozhenze on 2019/1/3.
//  Copyright © 2019 Sun Li. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoDefine.h"
#import "CMLSDKEngine.h"
#import "WXSDKEngine.h"
#import "CMLWeexRenderPage.h"
#import "CMLWeexOperationViewController.h"
#import "WXEventModule.h"
#import "WXImgLoaderDefaultImpl.h"
#import "OpenPage.h"
#import "WXTitleBarModule.h"
#import "CMLWeexRenderPage+Playground.h"

@interface AppDelegate ()
@property UINavigationController *nvc;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // create window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    // init weex sdk
    [self initWeexSDK];
    
    // init navigationController
    UINavigationController *nvc = [[UINavigationController alloc] init];
    self.window.rootViewController = nvc;
    
    // show window
    [self.window makeKeyAndVisible];
    
    // open homepage of weex
    [[[OpenPage alloc] init] open:HOME_URL];

    return YES;
}

- (void) initWeexSDK {
    [CMLSDKEngine registerModule:@"cml" className:@"CMLCommonModule"];
    
    //设置服务类型为weex
    [CMLEnvironmentManage chameleon].serviceType = CMLServiceTypeWeex;
//    [CMLEnvironmentManage chameleon].weexService.config.prefetchContents = @[@"http%3A%2F%2F172.22.139.32%3A8000%2Fweex%2Fchameleon-bridge.js%3Ft%3D1546502643623"];
//    [[CMLEnvironmentManage chameleon].weexService setupPrefetch];
    
    // regist open_event
    [WXSDKEngine registerHandler:[WXEventModule new] withProtocol:@protocol(WXEventModuleProtocol)];
    [WXSDKEngine registerModule:@"event" withClass:[WXEventModule class]];
    
    // regist title event
    [WXSDKEngine registerModule:@"titleBar" withClass:NSClassFromString(@"WXTitleBarModule")];
    
    // 图片加载
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
}

@end
