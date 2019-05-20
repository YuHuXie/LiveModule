//
//  AlivcDownloadVideoManager.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/12/10.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayerDefine.h>
#import <AliyunVodPlayerSDK/AliyunVodDownLoadManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlivcDownloadVideoManager : NSObject

/**
 根据视频唯一标志符获取下载接口的参数实例：AliyunDataSource

 @param vid 视频唯一标识符
 @param formatString 视频格式
 @param quality 视频质量
 @param sucess 成功回调
 @param failure 失败回调
 */
+ (void)getDataSourceWithVid:(NSString *)vid format:(NSString *__nullable)formatString qualitity:(AliyunVodPlayerVideoQuality )quality sucess:(void(^)(AliyunDataSource *dataSource))sucess failure:(void(^)(NSString *errDes))failure;

@end

NS_ASSUME_NONNULL_END
