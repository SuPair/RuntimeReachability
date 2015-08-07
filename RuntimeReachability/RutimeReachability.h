//
//  RutimeReachability.h
//  RuntimeReachability
//
//  Created by SuAnn on 15/8/6.
//  Copyright (c) 2015年 SuAnn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kNetWorkStateMonitoring @"NetWorkStateMonitoring"
#define kNetWorkStateMonitoringTime @"NetWorkStateMonitoringTime"

@protocol RutimeReachabilityDelegate <NSObject>

@optional

- (void)netWorkStateChangeByType:(NSString *)type;

@end
@interface RutimeReachability : NSObject

@property (nonatomic, assign) BOOL isStart;      //是否是处于运行状态
#pragma 通知会发送几种模式 0.GPRS 1.2G 2.3G 3.4G 5.WiFi 6.飞行模式 7.无网络状态
@property (nonatomic, strong) NSString *type;    //网络状态类型
@property (nonatomic, assign) BOOL netEnable;    //是否有网
@property (nonatomic, assign) id<RutimeReachabilityDelegate>delegate;


/**
 *  单利方法
 *
 *  @return 返回对象实例
 */
+ (instancetype)sharedManger;

/**
 *  开始网络监测
 */
- (void)startNetWorkStateMonitoring;
/**
 *  停止网络监测
 */
- (void)stopNetWorkStateMonitoring;
@end
