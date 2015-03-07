//
//  TableViewController.h
//  hw02-Zhou-q1
//
//  Created by Jiyang on 15/2/6.
//  Copyright (c) 2015年 Jiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface TableViewController : UITableViewController
@property (strong, nonatomic) NSArray *filenameArray;
@property (weak , nonatomic) NSString *fileToSend;
@property(nonatomic,assign) id<MFMailComposeViewControllerDelegate> mailComposeDelegate;
@end
