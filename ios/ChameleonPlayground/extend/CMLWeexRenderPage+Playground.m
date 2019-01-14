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

#import "CMLWeexRenderPage+Playground.h"
#import <objc/runtime.h>

static const void *navigationBarKey = &navigationBarKey;

@implementation CMLWeexRenderPage (Playground)

@dynamic hideNavigationBar;

- (BOOL) hideNavigationBar {
    NSString *str = (NSString *)objc_getAssociatedObject(self, navigationBarKey);
    return [str isEqualToString:@"YES"] ? YES : NO;
}
- (void) setHideNavigationBar:(BOOL)hideNavigationBar {
    NSString *str = hideNavigationBar ? @"YES" : @"NO";
    objc_setAssociatedObject(self, navigationBarKey, str, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setShowNavigationBar:(BOOL)show
{
    self.hideNavigationBar = !show;
    [self refreshTitleStatus];
}


- (void) refreshTitleStatus
{
    [self.navigationController setNavigationBarHidden:self.hideNavigationBar];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hideNavigationBar = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTitleStatus];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

@end
