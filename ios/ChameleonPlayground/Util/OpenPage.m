/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import "OpenPage.h"
#import "CMLWeexRenderPage.h"
#import "CMLEnvironmentManage.h"
#import <Foundation/Foundation.h>


//#import "WXEventModule.h"
//#import "CMLWeexRenderPage.h"
//#import "CMLWKWebView.h"
//#import "CMLEnvironmentManage.h"
//#import "WeexSDK.h"
//#import "PlaygroundUtil.h"
#import "WXScannerVC.h"
#import "ViewController.h"

@implementation OpenPage


- (void)open:(NSString *)url
{
    NSString *newURL = url;
    
    // open scan page
    if ([url hasPrefix:@"weex://go/scan"]){
        WXScannerVC * scannerVC = [WXScannerVC new];
        [self pushPage:scannerVC];
        return;
    }
    
    // auto prefix "http"
    if ([url hasPrefix:@"//"]) {
        newURL = [NSString stringWithFormat:@"http:%@", url];
    }
    
//    [self openWeexView:newURL];
//    return;
    
    // open weex page
    if([url containsString:@"cml_addr="] || [url containsString:@"wx_addr="]){
        newURL = [self getSchemaUrlTemp:url];
        [self openWeexView:newURL];
    
    // open webview
    } else {
        [self openNewWebView:newURL];
    }
    
}


-(void)openNewWebView: (NSString *)url{
    
    // auto add timestamp
    url = [self addTimeStamp:url];
    
    // create viewcontroller
    ViewController *newEmptyViewController = [ViewController new];
    
    // insert webview to viewcontroller
    CMLWKWebView *webView = [[CMLWKWebView alloc] initWithFrame:CGRectMake(0, 64, newEmptyViewController.view.frame.size.width, newEmptyViewController.view.frame.size.height)];
    [newEmptyViewController.view addSubview:webView];
    [self pushPage:newEmptyViewController];
    
    // load page
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    [webView loadRequest:request];
}

- (void)openWeexView:(NSString*)url
{
    // auto add timestamp
    url = [self addTimeStamp:url];
    
    // create page
    CMLWeexRenderPage *weexDemo = [[CMLWeexRenderPage alloc] initWithLoadUrl:url];
    weexDemo.service = [CMLEnvironmentManage chameleon].weexService;
    CGRect cgrect = [UIScreen mainScreen].bounds;
    weexDemo.CMLFrame = CGRectMake(0, 85, cgrect.size.width, cgrect.size.height - 85);
    
    // show apge
    [self pushPage:weexDemo];
}


-(NSString *) getSchemaUrlTemp: (NSString *)url {
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@".*(?:cml_addr|wx_addr)=(.*)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:url options:0 range:NSMakeRange(0, url.length)];
    
    NSTextCheckingResult *res = (NSTextCheckingResult *)results[0];
    url = [url substringWithRange:[res rangeAtIndex:1]];
    
    NSString *decoded = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return decoded;
}


- (void)pushPage:(UIViewController*)controller
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *nvc = (UINavigationController *)window.rootViewController;
    [nvc pushViewController:controller animated:YES];
}

- (NSString *) addTimeStamp:(NSString *)url
{
    
    NSString *stamp = [NSString stringWithFormat: @"%@t=%f",
            [url containsString:@"?"] ? @"&" : @"?",
            [[NSDate date] timeIntervalSince1970] * 1000
    ];
    
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"(.*)(#.*)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:url options:0 range:NSMakeRange(0, url.length)];
    
    if([results count] == 0){
        return [url stringByAppendingString:stamp];
    } else {
        NSTextCheckingResult *res = (NSTextCheckingResult *)results[0];
        return [NSString stringWithFormat:@"%@%@%@", [url substringWithRange:[res rangeAtIndex:1]], stamp, [url substringWithRange:[res rangeAtIndex:2]]];
    }
    
    
}

@end
