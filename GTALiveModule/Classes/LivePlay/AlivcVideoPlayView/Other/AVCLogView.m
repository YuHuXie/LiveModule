//
//  AVCLogView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/13.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AVCLogView.h"
#import "NSString+AlivcHelper.h"
#import "UIColor+AlivcHelper.h"

#pragma mark - AVCLogModel
@implementation AVCLogModel

+ (NSString *)descriptionWithEvent:(AliyunVodPlayerEvent)event{
    NSString *eventString = @"";
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
            eventString = @"准备成功";
            break;
        case AliyunVodPlayerEventPlay:
            eventString = @"开始播放";
            break;
        case AliyunVodPlayerEventFirstFrame:
            eventString = @"第一帧加载完成";
            break;
        case AliyunVodPlayerEventPause:
            eventString = @"暂停播放";
            break;
        case AliyunVodPlayerEventStop:
            eventString = @"停止播放";
            break;
        case AliyunVodPlayerEventFinish:
            eventString = @"播放已结束";
            break;
        case AliyunVodPlayerEventBeginLoading:
            eventString = @"开始加载视频数据";
            break;
        case AliyunVodPlayerEventEndLoading:
            eventString = @"视频资源加载完成";
            break;
        case AliyunVodPlayerEventSeekDone:
            eventString = @"跳转成功";
            break;
        default:
            break;
    }
    
    return [eventString localString];
}

- (instancetype)initWithEvent:(AliyunVodPlayerEvent)event{
    self = [super init];
    if (self) {
        _happenDate = [NSDate date];
        _event = event;
    }
    return self;
}

- (NSString *)timeString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss.SSS"];
    NSString *timeString = [formatter stringFromDate:self.happenDate];
    return timeString;
}

- (NSString *)eventDescription{
    return [AVCLogModel descriptionWithEvent:self.event];
}

@end

#pragma mark - AVCLogViewTableViewCell
static NSString *Identifier_AVCLogViewTableViewCell = @"AVCLogViewTableViewCell";
/**
 简单的自定义cell
 */
@interface AVCLogViewTableViewCell:UITableViewCell

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *descriptionLabel;

@property (strong, nonatomic, readonly) AVCLogModel *model;

- (void)configCellWithModel:(AVCLogModel *)model;

@end


@implementation AVCLogViewTableViewCell

- (instancetype)init{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.frame = CGRectMake(8, 8, 88, 22);
    self.timeLabel.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.layer.cornerRadius = 2;
    self.timeLabel.clipsToBounds = true;
    self.descriptionLabel = [[UILabel alloc]init];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.frame = CGRectMake(8 + 68 + 8, 8, 100, 22);
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.descriptionLabel];
    
}
- (void)configCellWithModel:(AVCLogModel *)model{
    self.timeLabel.text = model.timeString;
    self.descriptionLabel.text = model.eventDescription;
    [self.descriptionLabel sizeToFit];
    CGFloat cx = CGRectGetMaxX(self.timeLabel.frame) + 8 + self.descriptionLabel.frame.size.width / 2;
    CGFloat cy = CGRectGetMidY(self.timeLabel.frame);
    self.descriptionLabel.center = CGPointMake(cx, cy);
}

@end

#pragma mark - AVCLogView

@interface AVCLogView()<UITableViewDataSource>

/**
 显示的数据源
 */
@property (strong, nonatomic) NSMutableArray <AVCLogModel *>*logModelArray;

/**
 列表视图
 */
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *bottomView;

@end



@implementation AVCLogView

- (instancetype)init{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self = [self initWithFrame:CGRectMake(0, 0, width, 200)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configBaseUI];
    }
    return self;
}

- (void)configBaseUI{
    //data
    self.logModelArray = [[NSMutableArray alloc]init];
    //tableView
    CGRect tFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 50);
    self.tableView = [[UITableView alloc]initWithFrame:tFrame];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    //底部清除日志
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.frame.size.width, 50)];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"373d41"];
    [self addSubview:self.bottomView];
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, 0, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    [clearButton addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:clearButton];
    
    UIImage *deleteImage = [UIImage imageNamed:@"avcDelete"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:deleteImage];
    [self.bottomView addSubview:imageView];
    
    UILabel *deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    deleteLabel.text = [@"清除日志" localString];
    deleteLabel.textColor = [UIColor whiteColor];
    [deleteLabel sizeToFit];
    [self.bottomView addSubview:deleteLabel];
    
    //保持image和label合起来的视图居中
    CGFloat iAWidth = imageView.frame.size.width + 8 + deleteLabel.frame.size.width;
    CGFloat w1 = iAWidth / 2 - 8 - imageView.frame.size.width;
    CGFloat w2 = deleteLabel.frame.size.width / 2 - w1;
    
    CGPoint center_imageView = CGPointMake(self.bottomView.frame.size.width / 2 - imageView.frame.size.width / 2 - 8 - w1, self.bottomView.frame.size.height / 2);
    imageView.center = center_imageView;
    
    CGFloat cx_label = self.bottomView.frame.size.width / 2 + w2;
    deleteLabel.center = CGPointMake(cx_label, self.bottomView.frame.size.height / 2);
}

- (void)haveReceivedNewEvent:(AVCLogModel *)model{
    [self.logModelArray addObject:model];
    [self.tableView reloadData];
    [self hideOrShowBottomView];
}

- (void)clearLog{
    [self.logModelArray removeAllObjects];
    [self.tableView reloadData];
    
    //点击隐藏
//    [self hideOrShowBottomView];
}

- (BOOL)haveLog{
    return self.logModelArray.count > 0?true:false;
}

- (void)hideOrShowBottomView{
    if ([self haveLog]) {
        self.bottomView.hidden = false;
    }else{
        self.bottomView.hidden = true;
    }
}

//UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.logModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AVCLogViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier_AVCLogViewTableViewCell];
    if (!cell) {
        cell = [[AVCLogViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier_AVCLogViewTableViewCell];
    }
    if (indexPath.row < self.logModelArray.count) {
        AVCLogModel *model = self.logModelArray[indexPath.row];
        [cell configCellWithModel:model];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end





