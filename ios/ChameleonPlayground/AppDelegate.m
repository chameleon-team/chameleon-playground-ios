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

#define CHAMELEON_COLOR [UIColor colorWithRed:0.11372 green:0.4313725 blue:0.94117647 alpha:1]

@interface AppDelegate ()
@property UINavigationController *nvc;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect rect = [[UIScreen mainScreen] bounds];
    // create window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // init weex sdk
    [self initWeexSDK];
    
    // init navigationController
    UINavigationController *nvc = [[UINavigationController alloc] init];
    [nvc setNavigationBarHidden:YES];
    self.window.rootViewController = nvc;
    
    // show window
    [self.window makeKeyAndVisible];
    
    [self startSplashScreen];
    
    // open homepage of weex
    [[[OpenPage alloc] init] open:HOME_URL];

    return YES;
}

- (void)startSplashScreen
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIView* splashView = [[UIView alloc] initWithFrame:rect];
    splashView.backgroundColor = CHAMELEON_COLOR;
    
    UIImageView *bgImageView = [UIImageView new];
    UIImage *bg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bg" ofType:@"png"]];
    bgImageView.image = bg;
    bgImageView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    bgImageView.center = splashView.center;
    [splashView addSubview:bgImageView];
    
    UIImageView *iconImageView = [UIImageView new];
    UIImage *icon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chameleon" ofType:@"png"]];
    if ([icon respondsToSelector:@selector(imageWithRenderingMode:)]) {
        iconImageView.image = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        iconImageView.tintColor = [UIColor whiteColor];
    } else {
        iconImageView.image = icon;
    }
  
    iconImageView.frame = CGRectMake(100, 100, rect.size.width - 200, rect.size.height - 200);
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.center = splashView.center;
    [splashView addSubview:iconImageView];
    
    [self.window addSubview:splashView];
    
    float animationDuration = 1.4;
    CGFloat shrinkDuration = animationDuration * 0.3;
    CGFloat growDuration = animationDuration * 0.7;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:shrinkDuration delay:1.0 usingSpringWithDamping:0.7f initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.75, 0.75);
            iconImageView.transform = scaleTransform;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:growDuration animations:^{
                CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
                iconImageView.transform = scaleTransform;
                splashView.alpha = 0;
            } completion:^(BOOL finished) {
                [splashView removeFromSuperview];
            }];
        }];
    } else {
        [UIView animateWithDuration:shrinkDuration delay:1.0 options:0 animations:^{
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.75, 0.75);
            iconImageView.transform = scaleTransform;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:growDuration animations:^{
                CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
                iconImageView.transform = scaleTransform;
                splashView.alpha = 0;
            } completion:^(BOOL finished) {
                [splashView removeFromSuperview];
            }];
        }];
    }
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
