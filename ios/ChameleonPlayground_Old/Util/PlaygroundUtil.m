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

#import "PlaygroundUtil.h"
#import "CMLWeexRenderPage.h"
#import "CMLEnvironmentManage.h"

@implementation PlaygroundUtil

+ (CMLWeexRenderPage *)openWeexView:(NSString*)url
{
    url = [PlaygroundUtil addTimeStamp:url];
    CMLWeexRenderPage *weexDemo = [[CMLWeexRenderPage alloc] initWithLoadUrl:url];
    weexDemo.service = [CMLEnvironmentManage chameleon].weexService;
    CGRect cgrect = [UIScreen mainScreen].bounds;
    weexDemo.CMLFrame = CGRectMake(0, 85, cgrect.size.width, cgrect.size.height - 85);
    
    [PlaygroundUtil pushPage:weexDemo];
    
    return weexDemo;
}

+ (void)pushPage:(UIViewController*)controller
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UINavigationController *nvc = (UINavigationController *)window.rootViewController;
    [nvc pushViewController:controller animated:YES];
}

+ (NSString *) addTimeStamp:(NSString *)url
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
