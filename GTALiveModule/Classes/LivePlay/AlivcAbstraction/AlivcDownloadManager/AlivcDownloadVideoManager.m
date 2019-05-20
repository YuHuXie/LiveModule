//
//  AlivcDownloadVideoManager.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/12/10.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcDownloadVideoManager.h"
#import "AlivcAppServer.h"


@implementation AlivcDownloadVideoManager
+ (void)getDataSourceWithVid:(NSString *)vid format:(NSString *__nullable)formatString qualitity:(AliyunVodPlayerVideoQuality )quality sucess:(void(^)(AliyunDataSource *dataSource))sucess failure:(void(^)(NSString *errDes))failure{
    [AlivcAppServer getStsDataWithVid:vid sucess:^(NSString * _Nonnull accessKeyId, NSString * _Nonnull accessKeySecret, NSString * _Nonnull securityToken) {
        //AliyunDataSource
        AliyunDataSource *dataSource = [[AliyunDataSource alloc]init];
        dataSource.requestMethod = AliyunVodRequestMethodStsToken;
        dataSource.vid = vid;
        if (formatString) {
            dataSource.format = formatString;
        }
        dataSource.quality = quality;
        AliyunStsData *stsData = [[AliyunStsData alloc]init];
        stsData.accessKeyId = accessKeyId;
        stsData.accessKeySecret = accessKeySecret;
        stsData.securityToken = securityToken;
        dataSource.stsData = stsData;
        sucess(dataSource);
    } failure:^(NSString * _Nonnull errorString) {
        failure(errorString);
    }];
}
@end
