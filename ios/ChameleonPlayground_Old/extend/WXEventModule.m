
#import "WXEventModule.h"
#import "OpenPage.h"

@implementation WXEventModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(openURL:))

WX_EXPORT_METHOD(@selector(fireNativeGlobalEvent:callback:))

- (void)openURL:(NSString *)url
{
    [[[OpenPage alloc] init] open:url];
}


//-(void)openNewWebView: (NSString *)url{
//
//    // create viewcontroller
//    ViewController *newEmptyViewController = [ViewController new];
//
//    // insert webview to viewcontroller
//    CMLWKWebView *webView = [[CMLWKWebView alloc] initWithFrame:CGRectMake(0, 64, newEmptyViewController.view.frame.size.width, newEmptyViewController.view.frame.size.height)];
//    [newEmptyViewController.view addSubview:webView];
//    [PlaygroundUtil pushPage:newEmptyViewController];
//
//    // load page
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
//    [webView loadRequest:request];
//}
//
//
//-(NSString *) getSchemaUrlTemp: (NSString *)url {
//    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@".*cml_addr=(.*)" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSArray *results = [regular matchesInString:url options:0 range:NSMakeRange(0, url.length)];
//
//    NSTextCheckingResult *res = (NSTextCheckingResult *)results[0];
//    return [url substringWithRange:[res rangeAtIndex:1]];
//}


/**
 a test method for macaca case, you can fire globalEvent when download finish、device shaked and so on.
 @param event event name
 */
- (void)fireNativeGlobalEvent:(NSString *)event callback:(WXKeepAliveCallback)callback
{
    [weexInstance fireGlobalEvent:event params:@{@"eventParam":@"eventValue"}];
    if (callback) {
        NSDictionary * result = @{@"ok": @true};
        callback(result,false);
    }
}

@end
