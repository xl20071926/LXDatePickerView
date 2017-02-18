//
//  LXDatePickerViewController.m
//  LXDatePickerView
//
//  Created by Leexin on 17/2/18.
//  Copyright © 2017年 Garden.Lee. All rights reserved.
//

#import "LXDatePickerViewController.h"
#import "NSDate+Calendar.h"
#import "UIColor+Extensions.h"
#import "UIView+Extensions.h"
#import "NSArray+Category.h"

@interface LXDatePickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *myPickerView;
@property (nonatomic, strong) UIView *titleContentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, copy) NSString *yearString;
@property (nonatomic, copy) NSString *monthString;
@property (nonatomic, copy) NSString *dayString;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSDate *originSelectedDate; //设置初始选择日期

@end

@implementation LXDatePickerViewController

- (instancetype)initWithSelectedDate:(NSDate *)selectedDate {
    
    self = [super init];
    if (self) {
        self.originSelectedDate = selectedDate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
}

- (void)commonInit {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyyMM";
    
    self.view.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3];
    [self.view addSubview:self.titleContentView];
    [self.view addSubview:self.myPickerView];
    
    [self.titleContentView addSubview:self.cancelButton];
    [self.titleContentView addSubview:self.titleLabel];
    [self.titleContentView addSubview:self.confirmButton];
    
    self.titleContentView.frame = CGRectMake(0, self.view.height - 200.f, self.view.width, 50.f);
    self.myPickerView.frame = CGRectMake(0, self.titleContentView.bottom, self.view.width, 150.f);
    
    self.cancelButton.frame = CGRectMake(0, 0, 60.f, self.titleContentView.height);
    self.titleLabel.frame = CGRectMake((self.view.width - 100.f) / 2, 0, 100.f, self.titleContentView.height);
    self.confirmButton.frame = self.cancelButton.frame;
    self.confirmButton.left = self.view.width - self.confirmButton.width;
    
    [self commonData];
}

- (void)commonData {
    
    // 获取当前月份有多少日
    NSDate *currentSelectedDate;
    if (self.originSelectedDate) {
        currentSelectedDate = self.originSelectedDate;
    } else {
        currentSelectedDate = [NSDate date];
    }
    
    NSInteger allDays = [self totaldaysInMonth:currentSelectedDate];
    for (int i = 1; i <= allDays; i++) {
        NSString *strDay = [NSString stringWithFormat:@"%02i", i];
        [self.dayArray addObject:strDay];
    }
    //  更新年
    NSInteger currentYear = [currentSelectedDate getYear];
    NSString *strYear = [NSString stringWithFormat:@"%04li", currentYear];
    NSInteger indexYear = [self.yearArray indexOfObject:strYear];
    if (indexYear == NSNotFound) {
        indexYear = 0;
    }
    [self.myPickerView selectRow:indexYear inComponent:0 animated:YES];
    self.yearString = self.yearArray[indexYear];;
    
    //  更新月份
    NSInteger currentMonth = [currentSelectedDate getMonth];
    NSString *strMonth = [NSString stringWithFormat:@"%02li", currentMonth];
    NSInteger indexMonth = [self.monthArray indexOfObject:strMonth];
    if (indexMonth == NSNotFound) {
        indexMonth = 0;
    }
    [self.myPickerView selectRow:indexMonth inComponent:1 animated:YES];
    self.monthString = self.monthArray[indexMonth];
    
    //  更新日
    NSInteger currentDay = [currentSelectedDate getDay];
    NSString *strDay = [NSString stringWithFormat:@"%02li", currentDay];
    NSInteger indexDay = [self.dayArray indexOfObject:strDay];
    if (indexDay == NSNotFound) {
        indexDay = 0;
    }
    [self.myPickerView selectRow:indexDay inComponent:2 animated:YES];
    self.dayString = self.dayArray[indexDay];
}

- (NSInteger)totaldaysInMonth:(NSDate *)date { // 计算出当月有多少天
    
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

- (void)updateCurrentAllDaysWithDate:(NSDate *)currentDate { // 更新选中的年、月份时的日期
    
    [self.dayArray removeAllObjects];
    
    NSInteger allDays = [self totaldaysInMonth:currentDate];
    for (int i = 1; i <= allDays; i++) {
        NSString *strDay = [NSString stringWithFormat:@"%02i", i];
        [self.dayArray addObject:strDay];
    }
    
    [self.myPickerView reloadComponent:2];
    
    NSInteger indexDay = [self.dayArray indexOfObject:self.dayString];
    if (indexDay == NSNotFound) {
        indexDay = (self.dayArray.count - 1) > 0 ? (self.dayArray.count - 1) : 0;
    }
    [self.myPickerView selectRow:indexDay inComponent:2 animated:YES];
    self.dayString = self.dayArray[indexDay];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        return self.yearArray.count;
    } else if (component == 1) {
        return self.monthArray.count;
    } else {
        return self.dayArray.count;
    }
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if (component == 0) {
        return [self getPickViewCellWithString:[self.yearArray safeObjectAtIndex:row]];
    } else if (component == 1) {
        return [self getPickViewCellWithString:[self.monthArray safeObjectAtIndex:row]];
    } else {
        return [self getPickViewCellWithString:[self.dayArray safeObjectAtIndex:row]];
    }
}

- (UILabel *)getPickViewCellWithString:(NSString *)string {
    
    UILabel *cell = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 3, 50.f)];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textColor = [UIColor colorWithHex:0x404040];
    cell.textAlignment = NSTextAlignmentCenter;
    cell.font = [UIFont systemFontOfSize:15.f];
    cell.text = string;
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.yearString = [self.yearArray safeObjectAtIndex:row];
    } else if (component == 1) {
        self.monthString = [self.monthArray safeObjectAtIndex:row];
    } else {
        self.dayString =  [self.dayArray safeObjectAtIndex:row];
    }
    
    if (component != 2) {
        NSString *strDate = [NSString stringWithFormat:@"%@%@", self.yearString, self.monthString];
        [self updateCurrentAllDaysWithDate:[self.dateFormatter dateFromString:strDate]];
    }
}

#pragma mark - Event Response

- (void)onCancelButtonClick {
    
    if ([self.delegate respondsToSelector:@selector(datePickerViewControllerDidClickCancleButton:)]) {
        [self.delegate datePickerViewControllerDidClickCancleButton:self];
    }
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

- (void)onConfirmButtonClick {
    
    NSString *dateString = [NSString stringWithFormat:@"%@年%@月%@日",self.yearString, self.monthString, self.dayString];
    if ([self.delegate respondsToSelector:@selector(datePickerViewController:didSelectDate:)]) {
        [self.delegate datePickerViewController:self didSelectDate:dateString];
    }
    if (self.selectBlock) {
        self.selectBlock(dateString);
    }
}

#pragma mark - Getters

- (UIPickerView *)myPickerView {
    
    if (!_myPickerView) {
        _myPickerView = [[UIPickerView alloc] init];
        _myPickerView.delegate = self;
        _myPickerView.dataSource = self;
        _myPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _myPickerView;
}

- (UIView *)titleContentView {
    
    if (!_titleContentView) {
        _titleContentView = [[UIView alloc] init];
        _titleContentView.backgroundColor = [UIColor whiteColor];
    }
    return _titleContentView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"选择日期";
        _titleLabel.textColor = [UIColor colorWithHex:0x828282];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHex:0x1ecc6e] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithHex:0x1ecc6e] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onConfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _confirmButton;
}

- (NSMutableArray *)yearArray {
    
    if (!_yearArray) {
        _yearArray = [NSMutableArray array];
        for (int i = 1; i < 10000; i++) {
            NSString *year = [NSString stringWithFormat:@"%04i", i];
            [_yearArray addObject:year];
        }
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
        for (int i = 1; i <= 12; i++) {
            NSString *month = [NSString stringWithFormat:@"%02i", i];
            [_monthArray addObject:month];
        }
    }
    return _monthArray;
}

- (NSMutableArray *)dayArray {
    
    if (!_dayArray) {
        _dayArray = [NSMutableArray array];
    }
    return _dayArray;
}


@end
