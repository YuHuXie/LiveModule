//
//  AVCLogView.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/13.
//  Copyright © 2018年 Alibaba. All rights reserved.
//  日志显示视图

#import <UIKit/UIKit.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayerDefine.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - AVCLogModel
/**
 日志模型
 */
@interface AVCLogModel:NSObject

/**
 根据播放事件返回对应的事件描述
 
 @param event 播放事件
 @return 事件描述
 */
+ (NSString *)descriptionWithEvent:(AliyunVodPlayerEvent )event;


/**
 Designated Initializer

 @param event 播放事件
 @return 用于显示的模型类
 */
- (instancetype)initWithEvent:(AliyunVodPlayerEvent )event;

@property (strong, nonatomic, readonly) NSDate *happenDate;

@property (assign, nonatomic, readonly) AliyunVodPlayerEvent event;


/**
 事件发生的时间的字符串 HH:mm:ss
 */
- (NSString *)timeString;

/**
 事件描述字符串

 @return 事件描述字符串
 */
- (NSString *)eventDescription;

@end

#pragma mark - AVCLogView
/**
 日志视图
 */
@interface AVCLogView : UIView


/**
 接收到新的事件，并在界面上刷新

 @param model 新的事件模型
 */
- (void)haveReceivedNewEvent:(AVCLogModel *)model;

//
///**
// 清除日志
// */
//- (void)clearLog;

///**
// 当前logView上是否有日志显示
//
// @return true:有 false:没有
// */
//- (BOOL)haveLog;

@end

NS_ASSUME_NONNULL_END



