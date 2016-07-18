//
//  ViewController.m
//  QQUI
//
//  Created by JiangWang on 16/4/29.
//  Copyright © 2016年 JiangWang. All rights reserved.
//

#import "ViewController.h"
#import "QQCellFrameModel.h"
#import "QQTableViewCell.h"
#import "QQFootBanner.h"

#define kTextFieldHeight (30)
#define marginForAll (10)
#define kScreenSize ([UIScreen mainScreen].bounds.size)

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *frameAndMessageData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) QQFootBanner *bannerView;

@end

@implementation ViewController

- (NSMutableArray *)frameAndMessageData {
    if (_frameAndMessageData == nil) {
        //messageData instantiate;
        _frameAndMessageData = [NSMutableArray array];
        
        //find the place where the messages are strored;
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource:@"messages" ofType:@"plist"];
        
        NSArray *messages = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *tempDict in messages) {
            QQMessageModel *tempModel = [[QQMessageModel alloc] initWithDict:tempDict];
            QQCellFrameModel *cellFrame = [[QQCellFrameModel alloc] init];
            [cellFrame setMessageData:tempModel];
            
            //compare to last frameAndMessageModel - decide whether to hide the timeLabel or not;
            QQCellFrameModel *lastModel = [_frameAndMessageData lastObject];
            if ([lastModel.messageData.time isEqualToString:tempModel.time]) {
                cellFrame.hiddenTimeLabel = YES;
            }else {
                cellFrame.hiddenTimeLabel = NO;
            }
            
            [_frameAndMessageData addObject:cellFrame];
        }
    }
    
    return _frameAndMessageData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up table View's UI
    [self setupTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //set up the foot banner;
    [self setupFootBanner];
    self.textField.delegate = self;
    
    //observe notifications
    [self registerNotificationObserver];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"number of sections in table view;");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"number of rows in section");
    return self.frameAndMessageData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell for row at indexPath");
    //design the cell identifier
    static NSString *cellIdentifier = @"QQCell";
    
    //dequeue the reusable cell
    QQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //can't find a resuable cell?
    if (cell == nil) {
        cell = [[QQTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //configure the cell
    //get the corresponding date piece;
    cell.frameModel = self.frameAndMessageData[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //get the frameModel;
    QQCellFrameModel *frames = self.frameAndMessageData[indexPath.row];
    return frames.cellHeight;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - reposition Table and set up foot banner;
/**
 *  a textField's height is fixed - can't be changed 
 *  the height value is 30
 */
- (void)setupTableView {
    //instantiate a tableView
    CGRect tableFrame = [UIScreen mainScreen].bounds;
    tableFrame.size.height -= kTextFieldHeight + 2 * marginForAll;
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setupFootBanner {
    QQFootBanner *bannerView = [[QQFootBanner alloc] initWithFrame:CGRectMake(0, kScreenSize.height - kTextFieldHeight - 2 * marginForAll, kScreenSize.width, kTextFieldHeight + 2 * marginForAll)];
    self.textField = [bannerView subviews][2];
    self.bannerView = bannerView;
    [self.view addSubview:bannerView];
}

#pragma mark - notification
- (void)registerNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repositionUI:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)repositionUI: (NSNotification *)noti {
    CGRect keyboardEndFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [noti.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat frameYChange = keyboardEndFrame.origin.y - keyboardBeginFrame.origin.y;
    
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        //get the bannerView and the tableView's frames;
        CGRect bannerFrame = self.bannerView.frame;
        bannerFrame.origin.y += frameYChange;
        self.bannerView.frame = bannerFrame;
        
        CGRect tableFrame = self.tableView.frame;
        tableFrame.origin.y += frameYChange;
        self.tableView.frame = tableFrame;
    }];
}

#pragma mark - textField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    //save the data - the message;
    NSString *message = textField.text;
    [self postMessage: message withType:QQUserTypeMe];
    
    //auto reply
    [self postMessage:@"Shit" withType:QQUserTypeOther];
    
    return YES;
}

- (void)postMessage: (NSString *)message withType: (QQUserType)type {
    //create a message model;
    QQCellFrameModel *newFrame = [[QQCellFrameModel alloc] init];
    QQMessageModel *newMessage = [[QQMessageModel alloc] init];
    newMessage.text = message;
    
    //time
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:MM";
    NSString *currentDateString = [formatter stringFromDate:now];
    newMessage.time = currentDateString;
    
    //type
    newMessage.type = type;
    
    //assign the message to the framemodel;
    newFrame.messageData = newMessage;
    
    //hide the timeLabel or not;
    if ([currentDateString isEqualToString:[[[self.frameAndMessageData lastObject] messageData] time]]) {
        newFrame.hiddenTimeLabel = YES;
    }else {
        newFrame.hiddenTimeLabel = NO;
    }
    
    //add this new frameModel to the data array;
    [self.frameAndMessageData addObject:newFrame];
    
    //reload data;
    NSIndexPath *lastNewRow = [NSIndexPath indexPathForRow:self.frameAndMessageData.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[lastNewRow] withRowAnimation:UITableViewRowAnimationBottom];
    
    //scroll to the last row;
    [self.tableView scrollToRowAtIndexPath:lastNewRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
