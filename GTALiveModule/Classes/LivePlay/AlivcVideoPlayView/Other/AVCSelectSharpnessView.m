//
//  AVCSeletSharpnessView.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/18.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AVCSelectSharpnessView.h"
#import "AlivcUIConfig.h"
#import "NSString+AlivcHelper.h"
#import <AliyunVodPlayerSDK/AliyunVodDownLoadManager.h>

static CGFloat kContaniHeight = 280; //竖屏状态下内容的高度

@interface AVCSelectSharpnessView()

@property (nonatomic, strong) UILabel *selectInfoLabel;
@property (nonatomic, strong) UIScrollView *buttonsContainView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *allContainView;
@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, strong) UIButton *okButton;
//横屏
@property (nonatomic, strong) UILabel *downloadLabel;
@property (nonatomic, strong) UIButton *lookVideoButton;
@property (nonatomic, strong) UILabel *deviceLabel; //分隔线
//竖屏
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSArray *mediaInfos;

@property (nonatomic, strong) AliyunDownloadMediaInfo *selectedMediaInfo;
@end

static CGFloat buttonWidth = 60;
static CGFloat buttonHeight = 36;

@implementation AVCSelectSharpnessView

- (UILabel *)downloadLabel{
    if (!_downloadLabel) {
        _downloadLabel = [[UILabel alloc]init];
        _downloadLabel.text = @"—————— 视频下载 ——————";
        _downloadLabel.textColor = [UIColor whiteColor];
    }
    return _downloadLabel;
}

- (UIButton *)lookVideoButton{
    if (!_lookVideoButton) {
        _lookVideoButton = [[UIButton alloc]init];
        [_lookVideoButton setTitle:@"查看离线视频" forState:UIControlStateNormal];
        [_lookVideoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lookVideoButton addTarget:self action:@selector(lookVideoButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lookVideoButton;
}

- (UILabel *)deviceLabel{
    if (!_deviceLabel) {
        _deviceLabel = [[UILabel alloc]init];
        _deviceLabel.backgroundColor = [UIColor grayColor];
    }
    return _deviceLabel;
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]init];
        _coverImageView.frame = CGRectMake(0, 0, 120, 68);
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.layer.cornerRadius = 5;
    }
    return _coverImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        _titleLabel.text = @"视频标题";
    }
    return _titleLabel;
}

- (UILabel *)totalDataLabel{
    if (!_totalDataLabel) {
        _totalDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_totalDataLabel setTextColor:[UIColor whiteColor]];
        _totalDataLabel.text = @"550.1M";
    }
    return _totalDataLabel;
}

- (UILabel *)selectInfoLabel{
    if (!_selectInfoLabel) {
        _selectInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_selectInfoLabel setTextColor:[UIColor whiteColor]];
        _selectInfoLabel.text = @"选择清晰度";
    }
    return _selectInfoLabel;
}

- (UIScrollView *)buttonsContainView{
    if (!_buttonsContainView) {
        _buttonsContainView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _buttonsContainView.backgroundColor = [UIColor clearColor];
        _buttonsContainView.showsHorizontalScrollIndicator = NO;
    }
    return _buttonsContainView;
}

- (UIButton *)okButton{
    if (!_okButton) {
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okButton addTarget:self action:@selector(okButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
       
        [_okButton setTitle:[@"开始下载" localString] forState:UIControlStateNormal];
        [_okButton setTitle:[@"开始下载" localString] forState:UIControlStateSelected];
        
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _okButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(cancelButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"avcClose"];
        _cancelButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [_cancelButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIView *)allContainView{
    if (!_allContainView) {
        _allContainView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - kContaniHeight, self.frame.size.width, kContaniHeight)];
        _allContainView.backgroundColor = [AlivcUIConfig shared].kAVCBackgroundColor;
        _allContainView.userInteractionEnabled = YES;
    }
    return _allContainView;
}

- (UIView *)gestureView{
    if (!_gestureView) {
        _gestureView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kContaniHeight)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_gestureView addGestureRecognizer:tap];
        _gestureView.backgroundColor = [UIColor clearColor];
        return _gestureView;
    }
    return _gestureView;
}

- (instancetype)initWithMedias:(NSArray<AliyunDownloadMediaInfo *> *)mediaInfos{
    self = [super init];
    if (self) {
        self.mediaInfos = mediaInfos;
        CGFloat allWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat allHeight = [UIScreen mainScreen].bounds.size.height;
        self.frame = CGRectMake(0, 0, allWidth, allHeight);
        [self configBaseUI];
        //默认第一个
        self.selectedMediaInfo = mediaInfos.firstObject;
        [self configWithMedia:self.selectedMediaInfo];
    }
    return self;
}


- (void)configBaseUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //添加
    
    [self addSubview:self.allContainView];
    [self.allContainView addSubview:self.cancelButton];
    [self.allContainView addSubview:self.coverImageView];
    [self.allContainView addSubview:self.titleLabel];
    [self.allContainView addSubview:self.totalDataLabel];
    [self.allContainView addSubview:self.selectInfoLabel];
    [self.allContainView addSubview:self.okButton];
    //buttons
    [self.allContainView addSubview:self.buttonsContainView];
    self.buttonArray = [[NSMutableArray alloc]init];
    for (AliyunDownloadMediaInfo *info in self.mediaInfos) {
        UIButton *button = [self creatButtonWithMediaInfo:info];
        [self.buttonArray addObject:button];
        [self.buttonsContainView addSubview:button];
    }
    
    [self.allContainView addSubview:self.cancelButton];
    [self.allContainView addSubview:self.downloadLabel];
    [self.allContainView addSubview:self.lookVideoButton];
    
//    self.cancelButton.backgroundColor = [UIColor redColor];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat allWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat allHeight = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, allWidth, allHeight);

    
    for(UIButton *button in [self buttonArray]){
        [self configQualityButton:button];
    }
    
    
    if (allWidth < allHeight) {
        //竖屏
        if (self.downloadLabel.superview) {
            [self.downloadLabel removeFromSuperview];
        }
        if (self.lookVideoButton.superview) {
            [self.lookVideoButton removeFromSuperview];
        }
        if (!self.cancelButton.superview) {
            [self.allContainView addSubview:self.cancelButton];
        }
        if (self.deviceLabel.superview) {
            [self.deviceLabel removeFromSuperview];
        }
        //重新调整位置
        self.allContainView.frame = CGRectMake(0, self.frame.size.height - kContaniHeight, self.frame.size.width, kContaniHeight);
        self.gestureView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kContaniHeight);
        CGFloat width = self.allContainView.frame.size.width;
        CGFloat height = self.allContainView.frame.size.height;
        self.coverImageView.frame = CGRectMake(8, 16, 120, 68);
        [self resetLabelFrame];
        self.cancelButton.center = CGPointMake(width - 30, 16);
        
        //buttons
        CGFloat devideBB = 12;
        self.buttonsContainView.frame = CGRectMake(0, CGRectGetMaxY(self.selectInfoLabel.frame) + 8, width, 40);
        self.buttonsContainView.contentSize = CGSizeMake((buttonWidth + devideBB) * self.buttonArray.count + devideBB, 40);
        
        
        CGFloat bcy = self.buttonsContainView.frame.size.height / 2;
        for (UIButton *button in self.buttonArray) {
            NSInteger index = [self.buttonArray indexOfObject:button];
            CGFloat cx = devideBB * (index + 1) + buttonWidth * (0.5 + index);
            button.center = CGPointMake(cx, bcy);
        }
        self.okButton.frame = CGRectMake(0, height - 50, width, 50);
        [self.okButton setBackgroundColor:[AlivcUIConfig shared].kAVCThemeColor];

    }else{
        
        //横屏
        if(!self.downloadLabel.superview){
            [self.allContainView addSubview:self.downloadLabel];
        }
        if (!self.lookVideoButton.superview) {
            [self.allContainView addSubview:self.lookVideoButton];
        }
        if (self.cancelButton.superview) {
            [self.cancelButton removeFromSuperview];
        }
        if (!self.deviceLabel.superview) {
            [self.allContainView addSubview:self.deviceLabel];
        }
        
        //重新调整位置
        self.allContainView.frame = CGRectMake(allWidth - allHeight, 0, allHeight, allHeight);
        self.gestureView.frame = CGRectMake(0, 0, allWidth - allHeight, allHeight);
        CGFloat width = self.allContainView.frame.size.width;
        CGFloat height = self.allContainView.frame.size.height;
        self.coverImageView.frame = CGRectMake(8, 56, 120, 68);
        [self resetLabelFrame];
        
        [self.downloadLabel sizeToFit];
        self.downloadLabel.center = CGPointMake(self.allContainView.frame.size.width / 2, 20);
        
        //buttons
        CGFloat devideBB = 12;
        self.buttonsContainView.frame = CGRectMake(0, CGRectGetMaxY(self.selectInfoLabel.frame) + 8, width, 40);
        self.buttonsContainView.contentSize = CGSizeMake((buttonWidth + devideBB) * self.buttonArray.count + devideBB, 40);
        
        CGFloat bcy = self.buttonsContainView.frame.size.height / 2;
        for (UIButton *button in self.buttonArray) {
            NSInteger index = [self.buttonArray indexOfObject:button];
            button.center = CGPointMake(devideBB * (index + 1) + buttonWidth * (0.5 + index), bcy);
        }
        
        self.okButton.frame = CGRectMake(0, height - 50, width / 2, 50);
        [self.okButton setBackgroundColor:[UIColor clearColor]];
        self.lookVideoButton.frame = CGRectMake(width / 2, height - 50, width / 2, 50);
        [self.lookVideoButton setBackgroundColor:[UIColor clearColor]];
        
        self.deviceLabel.frame = CGRectMake(0, self.allContainView.frame.size.height - 51, self.allContainView.frame.size.width, 1);
    }
   
}

- (void)resetLabelFrame{
    [self.titleLabel sizeToFit];
    [self.totalDataLabel sizeToFit];
    [self.selectInfoLabel sizeToFit];
    CGFloat tcx = CGRectGetMaxX(self.coverImageView.frame) + 8 + self.titleLabel.frame.size.width / 2;
    CGFloat tcy = CGRectGetMinY(self.coverImageView.frame) + 16;
    self.titleLabel.center = CGPointMake(tcx, tcy);
    CGFloat ttcx = CGRectGetMaxX(self.coverImageView.frame) + 8 + self.totalDataLabel.frame.size.width / 2;
    CGFloat ttcy = CGRectGetMidY(self.titleLabel.frame) + 26;
    self.totalDataLabel.center = CGPointMake(ttcx, ttcy);
    
    CGFloat scx = 8 + self.selectInfoLabel.frame.size.width / 2;
    CGFloat scy = CGRectGetMaxY(self.coverImageView.frame) + 20;
    self.selectInfoLabel.center = CGPointMake(scx, scy);
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}
- (void)setSelectedMedia:(AliyunDownloadMediaInfo *)media{
    self.selectedMediaInfo = media;
    [self configWithMedia:media];
}

- (void)configWithMedia:(AliyunDownloadMediaInfo *)media{
    
    if (media.coverURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:media.coverURL];
            if (url) {
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                if (imageData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.coverImageView.image = [UIImage imageWithData:imageData];
                    });
                }
            }
        });
    }
    self.titleLabel.text = media.title;
    CGFloat mSize = (CGFloat)media.size / 1024 / 1024;
    NSString *mString = [NSString stringWithFormat:@"%.1fM",mSize];
    
    self.totalDataLabel.text = mString;
    [self refreshButtonStatus];
    [self resetLabelFrame];
}

#pragma mark - Response

- (void)okButtonTouched:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(selectSharpnessView:okButtonTouched:)]) {
        [self.delegate selectSharpnessView:self okButtonTouched:button];
    }
}

- (void)cancelButtonTouched:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(selectSharpnessView:cancelButtonTouched:)]) {
        [self.delegate selectSharpnessView:self cancelButtonTouched:button];
    }
}

- (void)qualityButtonTouched:(UIButton *)button{
    NSInteger index = [self.buttonArray indexOfObject:button];
    if (index < self.mediaInfos.count) {
        self.selectedMediaInfo = self.mediaInfos[index];
        [self configWithMedia:self.selectedMediaInfo];
        if ([self.delegate respondsToSelector:@selector(selectSharpnessView:haveSelectedMediaInfo:)]) {
            [self.delegate selectSharpnessView:self haveSelectedMediaInfo:self.selectedMediaInfo];
        }
    }
}

- (void)lookVideoButtonTouched:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(selectSharpnessView:lookVideoButtonTouched:)]) {
        [self.delegate selectSharpnessView:self lookVideoButtonTouched:button];
    }
}

#pragma mark - Custom
- (void)configQualityButton:(UIButton *)button{
    button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.layer.cornerRadius = 2;
    button.clipsToBounds = true;
}


- (void)refreshButtonStatus{
    for (UIButton *button in self.buttonArray) {
        [self setButton:button selected:false];
    }
    NSInteger index = [self.mediaInfos indexOfObject:self.selectedMediaInfo];
    if (index < self.buttonArray.count) {
        UIButton *selectedButton = self.buttonArray[index];
        [self setButton:selectedButton selected:true];
    }
    
}

/**
 设置button的选中状态

 @param button button
 @param selected 选中状态
 */
- (void)setButton:(UIButton *)button selected:(BOOL )selected{
    if (selected) {
        button.backgroundColor = [AlivcUIConfig shared].kAVCThemeColor;
    }else{
        button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    }
}

- (UIButton *)creatButtonWithMediaInfo:(AliyunDownloadMediaInfo *)info{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(qualityButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    NSString *title = [AVCSelectSharpnessView stringWithQuality:info.quality];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    return button;
}

/**
 AliyunVodPlayerVideoFD = 0,        // 流畅
 AliyunVodPlayerVideoLD,            // 标清
 AliyunVodPlayerVideoSD,            // 高清
 AliyunVodPlayerVideoHD,            // 超清
 AliyunVodPlayerVideo2K,            // 2K
 AliyunVodPlayerVideo4K,            // 4K
 AliyunVodPlayerVideoOD,            // 原画

 @param quality 视频质量的枚举
 @return 视频质量的描述
 */
+ (NSString *)stringWithQuality:(AliyunVodPlayerVideoQuality )quality{
    switch (quality) {
        case AliyunVodPlayerVideoFD:
            return [@"流畅" localString];
            break;
        case AliyunVodPlayerVideoLD:
            return [@"标清" localString];
            break;
        case AliyunVodPlayerVideoSD:
            return [@"高清" localString];
            break;
        case AliyunVodPlayerVideoHD:
            return [@"超清" localString];
            break;
        case AliyunVodPlayerVideo2K:
            return [@"2K" localString];
            break;
        case AliyunVodPlayerVideo4K:
            return [@"4K" localString];
            break;
        case AliyunVodPlayerVideoOD:
            return [@"原画" localString];
            break;
            
        default:
            break;
    }
    return @"";
}

#pragma mark - touchesBegan
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch  = touches.anyObject;
    if ([touch.view isKindOfClass:[AVCSelectSharpnessView class]]) {
        [self removeFromSuperview];
    }
}

@end
