//
//  LXDateViewPickerView.m
//  LXDatePickerView
//
//  Created by Leexin on 17/2/18.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import "LXDateViewPickerView.h"
#import "LXDatePickerViewController.h"
#import "UIView+Extensions.h"
#import "NSDate+Calendar.h"
#import "UIColor+Extensions.h"

static const CGFloat kViewSpace = 10.f;
static NSString * const kDateFormate_1 = @"yyyy年MM月dd日";

@interface LXDateViewPickerView ()

@property (nonatomic, strong) UILabel *stareDateLabel;
@property (nonatomic, strong) UIButton *stareCalendarIcon;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UIButton *endCalendarIcon;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIView *breakLine;

@property (nonatomic, strong) NSDate *orginStareDate;
@property (nonatomic, strong) NSDate *originEndDate;

@end

@implementation LXDateViewPickerView

#pragma mark - Life Cycle

- (void)dealloc {
    
    [_stareDateLabel removeObserver:self forKeyPath:@"text"];
}

- (instancetype)init {
    
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initWithFrame:frame
                     stareDate:[NSDate date]
                       endDate:[[NSDate date] dateAfterDay:1]];
}

- (instancetype)initWithFrame:(CGRect)frame
                    stareDate:(NSDate *)stareDate
                      endDate:(NSDate *)endDate {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.orginStareDate = stareDate;
        self.originEndDate = endDate;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    [self addSubview:self.stareDateLabel];
    [self addSubview:self.stareCalendarIcon];
    [self addSubview:self.endDateLabel];
    [self addSubview:self.endCalendarIcon];
    [self addSubview:self.centerLabel];
    [self addSubview:self.breakLine];
    
    self.stareDateLabel.text = [self getDateString:self.orginStareDate];
    self.endDateLabel.text = [self getDateString:self.originEndDate];
    
    [self addStareLabelKVO];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.stareDateLabel.frame = CGRectMake(kViewSpace, 0, 100.f, self.height);
    
    self.stareCalendarIcon.frame = CGRectMake(self.stareDateLabel.right, (self.height - 18.f) / 2, 18.f, 18.f);
    
    self.centerLabel.frame = CGRectMake((self.width - 30.f) / 2, 0, 30.f, self.height);
    
    self.endCalendarIcon.frame = self.stareCalendarIcon.frame;
    self.endCalendarIcon.left = self.width - kViewSpace - self.stareCalendarIcon.width;
    
    self.endDateLabel.frame = CGRectMake(self.endCalendarIcon.left - self.stareDateLabel.width, 0, self.stareDateLabel.width, self.stareDateLabel.height);
    
    self.breakLine.frame = CGRectMake(0, self.height - 1, self.width, 1/[UIScreen mainScreen].scale);
}

- (void)addStareLabelKVO { // 监听开始时间的变化
    
    [self.stareDateLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)resetEndDateWithNewStareDate:(NSString *)newStareString { // 根据开始时间调整结束时间
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormate_1];
    NSDate *newStareDate = [dateFormatter dateFromString:newStareString];
    NSDate *endDate = [dateFormatter dateFromString:self.endString];
    
    if ([NSDate compareDate:newStareDate withAnotherDay:endDate] > -1) { // 结束时间小于开始时间
        NSDate *nextDay = [newStareDate dateAfterDay:1];
        self.endDateLabel.text = [dateFormatter stringFromDate:nextDay];
    }
}

- (NSString *)getDateString:(NSDate *)date {
    
    if (![date isKindOfClass:[NSDate class]]) return @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormate_1];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - KVO Delegate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"text"]) {
        NSString *newDateString = [change valueForKey:NSKeyValueChangeNewKey];
        [self resetEndDateWithNewStareDate:newDateString];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Event Response

- (void)onCalendarIconClick:(UIButton *)sender {
    
    if (sender == self.stareCalendarIcon) {
        [self showDatePickerViewControllerWithSelectedDate:[NSDate dateFromString:self.stareString withFormat:kDateFormate_1]
                                               uploadLabel:self.stareDateLabel];
    } else {
        [self showDatePickerViewControllerWithSelectedDate:[NSDate dateFromString:self.endString withFormat:kDateFormate_1]
                                               uploadLabel:self.endDateLabel];
    }
}

- (void)showDatePickerViewControllerWithSelectedDate:(NSDate *)date uploadLabel:(UILabel *)label {
    
    LXDatePickerViewController *pickerVC = [[LXDatePickerViewController alloc] initWithSelectedDate:date];
    if (self.delegate && [self.delegate isKindOfClass:[UIViewController class]]) {
        
        UIViewController *fatherVC = (UIViewController *)self.delegate;
        __weak typeof(pickerVC)weakVC = pickerVC;
        __weak typeof(self)weakSelf = self;
        pickerVC.cancleBlock = ^{
            [weakVC dismissViewControllerAnimated:YES completion:nil];
            if ([weakSelf.delegate respondsToSelector:@selector(dateViewPickerViewDidCancelSelected:)]) {
                [weakSelf.delegate dateViewPickerViewDidCancelSelected:weakSelf];
            }
        };
        pickerVC.selectBlock = ^(NSString *dateString) {
            [weakVC dismissViewControllerAnimated:YES completion:nil];
            label.text = dateString;
            if ([weakSelf.delegate respondsToSelector:@selector(dateViewPickerView:didSelectedDate:)]) {
                [weakSelf.delegate dateViewPickerView:weakSelf didSelectedDate:[NSDate dateFromString:dateString withFormat:kDateFormate_1]];
            }
        };
        pickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [fatherVC presentViewController:pickerVC animated:YES completion:^{
            weakVC.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3];
        }];
    }
}

#pragma mark - Getters

- (UILabel *)stareDateLabel {
    
    if (!_stareDateLabel) {
        _stareDateLabel = [[UILabel alloc] init];
        _stareDateLabel.textColor = [UIColor colorWithHex:0x828282];
        _stareDateLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _stareDateLabel;
}

- (UIButton *)stareCalendarIcon {
    
    if (!_stareCalendarIcon) {
        _stareCalendarIcon = [UIButton buttonWithType:UIButtonTypeSystem];
        [_stareCalendarIcon addTarget:self action:@selector(onCalendarIconClick:) forControlEvents:UIControlEventTouchUpInside];
        [_stareCalendarIcon setBackgroundImage:[UIImage imageNamed:@"micro_calendar_icon"] forState:UIControlStateNormal];
    }
    return _stareCalendarIcon;
}

- (UILabel *)endDateLabel {
    
    if (!_endDateLabel) {
        _endDateLabel = [[UILabel alloc] init];
        _endDateLabel.textColor = [UIColor colorWithHex:0x828282];
        _endDateLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _endDateLabel;
}

- (UIButton *)endCalendarIcon {
    
    if (!_endCalendarIcon) {
        _endCalendarIcon = [UIButton buttonWithType:UIButtonTypeSystem];
        [_endCalendarIcon addTarget:self action:@selector(onCalendarIconClick:) forControlEvents:UIControlEventTouchUpInside];
        [_endCalendarIcon setBackgroundImage:[UIImage imageNamed:@"micro_calendar_icon"] forState:UIControlStateNormal];
    }
    return _endCalendarIcon;
}

- (UILabel *)centerLabel {
    
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.text = @"~";
        _centerLabel.textColor = [UIColor colorWithHex:0x828282];
        _centerLabel.font = [UIFont systemFontOfSize:16.f];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLabel;
}

- (UIView *)breakLine {
    
    if (!_breakLine) {
        _breakLine = [[UIView alloc] init];
        _breakLine.backgroundColor = [UIColor colorWithHex:0xf1f5f7];
    }
    return _breakLine;
}

- (NSString *)stareString {
    
    return self.stareDateLabel.text;
}

- (NSString *)endString {
    
    return self.endDateLabel.text;
}

@end
