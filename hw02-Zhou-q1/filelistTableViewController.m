//
//  filelistTableViewController.m
//  hw02-Zhou-q1
//
//  Created by Jiyang on 15/2/5.
//  Copyright (c) 2015年 Jiyang. All rights reserved.
//

#import "filelistTableViewController.h"

@implementation filelistTableViewController

NSFileManager *filemana;


- (IBAction)sendmail:(UIBarButtonItem *)sender {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    filemana=[NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [filemana contentsOfDirectoryAtPath:documentDir error:&error];
//    for (NSString *string in fileList) {
//        NSLog(@"%@", string);
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.listData = nil;
}

@end
