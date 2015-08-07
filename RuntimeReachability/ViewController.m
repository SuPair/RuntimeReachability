//
//  ViewController.m
//  RuntimeReachability
//
//  Created by SuAnn on 15/8/6.
//  Copyright (c) 2015年 SuAnn. All rights reserved.
//

#import "ViewController.h"
#import "RutimeReachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ViewController ()<RutimeReachabilityDelegate>
@property (weak, nonatomic) IBOutlet UILabel *state;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view, typically from a nib.
    [RutimeReachability sharedManger].delegate = self;
}

- (void)netWorkStateChangeByType:(NSString *)type{

       self.state.text = [NSString stringWithFormat:@"状态吗:%@",type];
    
    CFArrayRef arrayRef = CNCopySupportedInterfaces();
    NSArray *interfaces = (__bridge NSArray *)arrayRef;
    NSLog(@"interfaces -> %@", interfaces);
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName);
        if (dictRef != NULL) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            CFRelease(dictRef);
        }
    }
    CFRelease(arrayRef);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
