//
//  XDMessageController.m
//  ChatDemo
//
//  Created by JiangWang on 7/5/16.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#warning read this before you incorporate it into the company project;
/*
 1. global background color should be used - #f3f3f3
 2. search the warning messages - fix them;
 */

#import "XDMessageController.h"
#import "XDThumbnailMessage.h"
#import "XDThumbnailMessageCell.h"
#import "XDChatViewController.h"

@interface XDMessageController ()<UITableViewDataSource, UITableViewDelegate>

/* the table used to display messages */
@property (weak, nonatomic) IBOutlet UITableView *messageTable;

/* message data array */
@property (nonatomic, readwrite, strong) NSMutableArray *messagesArray;

@end

@implementation XDMessageController

static NSString *const XDMessageCellID = @"XDMessageCellIdentifier";


#pragma mark - initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNaviBar];
    
    [self setupTableView];
}

- (void)setupNaviBar {
    //title
    self.navigationItem.title = @"消息";
    
    //left
#warning do we need a left back button?
    
    //right
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"忽略未读" style:UIBarButtonItemStylePlain target:self action:@selector(ignoreUnreadMessages)];
}

- (void)setupTableView {
    self.messageTable.dataSource = self;
    self.messageTable.delegate = self;
    
    //should the table be hidden;
    self.messageTable.hidden = self.messagesArray.count ? NO : YES;
    
    //register cell
    [self.messageTable registerNib:[UINib nibWithNibName:@"XDThumbnailMessageCell" bundle:nil] forCellReuseIdentifier:XDMessageCellID];
    
    //adjust for the navigation bar and the status bar;
    CGRect naviBarFrame = self.navigationController.navigationBar.frame;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [self.messageTable setContentInset:UIEdgeInsetsMake(naviBarFrame.size.height + statusBarHeight, 0, 0, 0)];
    
    //remove the separator line
    self.messageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //cell's height
    self.messageTable.rowHeight = 70.f;
}

#pragma mark - table view data source;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDThumbnailMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:XDMessageCellID];
    
    //configure the cell
    cell.thumbnailMessage = self.messagesArray[indexPath.row];
    cell.tag = indexPath.row;
#warning cell reuse will disrupt the position of the cell's subviews - call layoutIfNeeded;
    [cell layoutIfNeeded];
    
    //return the cell
    return cell;
}

#pragma mark - table view delegate;


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //deselect the cell first;
    XDChatViewController *chatVC = [[XDChatViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:YES];
    
    
}

#pragma mark - lazy loading 
- (NSMutableArray *)messagesArray {
    if (nil == _messagesArray) {
#warning put data into the messages array - replace this with actual data;
        NSArray *tempArray = [NSArray array];
        NSString *messagesPath = [[NSBundle mainBundle]pathForResource:@"test_fake_messages" ofType:@"plist"];
        tempArray = [NSArray arrayWithContentsOfFile:messagesPath];
        
        //initialize the array
        _messagesArray = [[NSMutableArray alloc] initWithCapacity:tempArray.count];
        
        for (NSDictionary *tempDict in tempArray) {
            XDThumbnailMessage *tempMessage = [XDThumbnailMessage thumbnailMessageWithDict:tempDict];
            [_messagesArray addObject:tempMessage];
        }
        
        
    }
    return _messagesArray;
}

#pragma mark - target actions



#pragma mark - button actions
- (void)ignoreUnreadMessages {
    NSLog(@"ignore unread messages!");
}

@end
