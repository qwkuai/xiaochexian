//
//  TodayViewController.m
//  Today
//
//  Created by 杜辰 on 16/3/18.
//  Copyright © 2016年 蒯全伟. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController
{
    UILabel *_layout;
    NSTimer *_timer;
    NSInteger _count;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            _layout = (UILabel *)v;
        }
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(loop)
                                            userInfo:nil
                                             repeats:YES];
}

#pragma mark - Test

- (void)loop
{
    id data = [self fetchSSIDInfoOld];
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)data;
        NSString *mac = [dic objectForKey:@"BSSID"];
        NSString *name = [dic objectForKey:@"SSID"];
        
        _layout.text = [NSString stringWithFormat:@"Counting : %zi\nBSSID : %@\nSSID : %@", _count++, mac, name];
    }
}

- (id)fetchSSIDInfo
{
    NSArray *networkInterfaces = [NEHotspotHelper supportedNetworkInterfaces];
    NSLog(@"Networks %@",networkInterfaces);
    
    for (NEHotspotNetwork *hotspotNetwork in networkInterfaces) {
        NSString *ssid = hotspotNetwork.SSID;
        NSString *bssid = hotspotNetwork.BSSID;
        BOOL secure = hotspotNetwork.secure;
        BOOL autoJoined = hotspotNetwork.autoJoined;
        double signalStrength = hotspotNetwork.signalStrength;
        NSLog(@"ssid = %");
    }
    return nil;
}

- (id)fetchSSIDInfoOld
{
    NSString *currentSSID = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            currentSSID = [myDict valueForKey:@"SSID"];
        }
        else {
            currentSSID = @"<<NONE>>";
        }
    }
    else {
        currentSSID = @"<<NONE>>";
    }
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

@end
