//
//  RutimeReachability.m
//  RuntimeReachability
//
//  Created by SuAnn on 15/8/6.
//  Copyright (c) 2015年 SuAnn. All rights reserved.
//

#import "RutimeReachability.h"

@implementation RutimeReachability

+ (instancetype)sharedManger{
    static RutimeReachability *rut = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        rut = [[RutimeReachability alloc] init];
    });
    return rut;
}

- (void)startNetWorkStateMonitoring{
    
    
    if (self.isStart != NO) {
        return;
    }else{
        self.isStart = YES;
    }
    //创建线程
    __weak typeof(self) weakSelf = self;
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        
        float reSecond = 1.0;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, reSecond * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            
            if (weakSelf.isStart == NO) {
                dispatch_source_cancel(timer);
            }else{
                UIApplication *app = [UIApplication sharedApplication];
                NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
                for (int i = 0; i < children.count; i ++) {
                    
                    id child = children[i];
                    if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                        id type = [child valueForKeyPath:@"dataNetworkType"];
                        NSString *myType = [NSString stringWithFormat:@"%@",type];
                        if (weakSelf.type == nil) {
                            /* 如果嫌麻烦可以改为通知 */
                            weakSelf.type = myType;
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [weakSelf.delegate netWorkStateChangeByType:myType];
                            });
                            break;
                        }else if (![weakSelf.type isEqualToString:myType]){
                            weakSelf.type = myType;
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [weakSelf.delegate netWorkStateChangeByType:myType];
                            });                            break;
                        }else{
                            break;
                        }
                    }else if (i == children.count - 1 && ![child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]){
                        weakSelf.type = [NSString stringWithFormat:@"%d",6];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [weakSelf.delegate netWorkStateChangeByType:@"6"];
                        });
                        break;
                    }
                }
            }
        });
        dispatch_resume(timer);
    });
    
}

- (void)stopNetWorkStateMonitoring{

    self.isStart = NO;
}
@end
