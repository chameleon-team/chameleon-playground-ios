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
    [nvc setNavigationBarHidden:YES];
    self.window.rootViewController = nvc;
    
    // show window
    [self.window makeKeyAndVisible];
    
    // open homepage of weex
    [[[OpenPage alloc] init] open:HOME_URL];

    return YES;
}

- (void) initWeexSDK {
    
    //初始化SDK实例
    [CMLSDKEngine initSDKEnvironment];
    
    //设置渲染引擎为weex
    [CMLEnvironmentManage chameleon].serviceType = CMLServiceTypeWeex;
    
    // regist open_event
    [WXSDKEngine registerHandler:[WXEventModule new] withProtocol:@protocol(WXEventModuleProtocol)];
    [WXSDKEngine registerModule:@"event" withClass:[WXEventModule class]];
    
    // regist title event
    [WXSDKEngine registerModule:@"titleBar" withClass:NSClassFromString(@"WXTitleBarModule")];
    
//    // 图片加载
//    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
}

@end
