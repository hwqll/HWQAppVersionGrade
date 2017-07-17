//
//  HWQViewController.h
//  HWQAppVersionGradeDemo
//
//  Created by 黄伟强 on 2017/7/17.
//  Copyright © 2017年 hwq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWQViewController : UIViewController

- (void)appVersion:(NSString *)appId;    //版本检测
- (void)appGrade:(NSString *)appId delayTime: (double) Sec;     //评分:延迟一定时间后检测是否打过分。因为一般你打开app用一会才会弹出评分提示更人性化。

@end
