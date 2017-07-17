
//
//  HWQViewController.m
//  HWQAppVersionGradeDemo
//
//  Created by 黄伟强 on 2017/7/17.
//  Copyright © 2017年 hwq. All rights reserved.
//

#import "HWQViewController.h"

@interface HWQViewController ()
{
    NSString *_appURL;//appstore应用地址
}
@end

@implementation HWQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //appid可以在itunes connectin中找到
    [self appVersion:@"107151300567"];
    [self appGrade:@"1071513005675" delayTime:2.0];
}

//appid:appstore中你的app id
- (void)appVersion:(NSString *)appId {
    NSString *url = @"http://itunes.apple.com/lookup?id=";
    //本地应用版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString* currentVersion = [infoDic valueForKey:@"CFBundleShortVersionString"] ;
    
    //根据appId从苹果服务器上得到json数据,解析出版本信息。
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url, appId]]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    //
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString* version =[[[jsonData objectForKey:@"results"] objectAtIndex:0] valueForKey:@"version"];
        
        _appURL = [[[jsonData objectForKey:@"results"] objectAtIndex:0] valueForKey:@"trackViewUrl"];
        if(![version isEqualToString: currentVersion]){
            NSString *alertTitle=[@"appName" stringByAppendingString:[NSString stringWithFormat:@"%@可以更新了",version]];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新提示" message: alertTitle preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
                //系统版本兼容
                if(iOSVersion >= 10.0) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_appURL] options:@{} completionHandler:nil];
                }else {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_appURL]];
                }
            }];
            
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:true completion:nil];
        }else{
            NSLog(@"无需版本更新");
        }
        
    }];
    
    [sessionTask resume];
    
    
    //    NSLog(@"%@",jsonData);
}
//评分:延迟一定时间后检测是否打过分。
- (void)appGrade:(NSString *)appId delayTime: (double) Sec {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, Sec * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL grade = [[[NSUserDefaults standardUserDefaults] objectForKey:@"GRADE"] boolValue];
        if(!grade) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"评分提示" message: @"给我们应用打个分吧!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不再提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"GRADE"];
            }];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"前去打分" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", appId];
                
                CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
                //系统版本兼容
                if(iOSVersion >= 10.0) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                }else {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
                }
                //已经打过分
                [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"GRADE"];
                
            }];
            
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:true completion:nil];
        }
    });
}
@end
