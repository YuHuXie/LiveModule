//
//  AVC_VP_VideoConfig.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//  

#import "AVCVideoConfig.h"

@implementation AVCVideoConfig
- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.playMethod = AliyunPlayMedthodURL;
        
//        self.videoUrl = [NSURL URLWithString:@"http://player.alicdn.com/video/aliyunmedia.mp4"];
        self.videoUrl = [NSURL URLWithString:@"rtmp://live.gtafe.com/app/zhibo1?auth_key=1569229317-0-0-dff1859c0a800a38020f16093dd944a5"];
        
        self.videoId = @"";
        
        
        self.playAuth = @"";
        
        self.stsAccessKeyId = @"";
        self.stsAccessSecret = @"";
        self.stsSecurityToken = @"";
        
        self.mtsAccessKey = @"";
        self.mtsAccessSecret = @"";
        self.mtsStstoken = @"";
        self.mtsAuthon = @"";
        self.mtsRegion = @"cn-hangzhou";
        
       
        self.stsAccessKeyId = @"";
        self.stsAccessSecret = @"";
        self.stsSecurityToken = @"";
        
    }
    return self;
}
@end
