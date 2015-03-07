//
//  TableViewController.m
//  hw02-Zhou-q1
//
//  Created by Jiyang on 15/2/6.
//  Copyright (c) 2015年 Jiyang. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

NSString *documentPlace;
NSString *fileTo;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.filenameArray = [self getfilelist];
    NSFileManager *fileMgr =[[NSFileManager alloc] init] ;
    NSArray *docu = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentPlace = [docu objectAtIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self getfilelist].count;
}


- (NSArray*) getfilelist
{
    NSFileManager *filemana=[NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [filemana contentsOfDirectoryAtPath:documentDir error:&error];
    for (NSString *string in fileList) {
        NSLog(@"%@", string);
    }
    return fileList;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filename" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.filenameArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    fileTo = [[self getfilelist] objectAtIndex:indexPath.row];
    NSLog(@"%@",_fileToSend);
    UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Want Matlab??" message:@"Do you want to wrap the file into a .m file?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [messageAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { // means share button pressed
        // write your code here to do whatever you want to do once the share button is pressed
        NSLog(@"NONONONONONONONO");
        [self displayComposerSheet];
    }
    if(buttonIndex == 1) { // means apple button pressed
        // write your code here to do whatever you want to do once the apple button is pressed
        NSLog(@"YESYESYESYES");
        
        [self displayComposerSheetInMatlab];
    }
    // and so on for the last button
}

- (NSString*) writeNewMatlab:(NSString*) thefile{
    NSString *subfileto=[fileTo stringByDeletingPathExtension];
    NSLog(@"TTTTTTTTTTTTTTTTTT   %@",fileTo);

//    NSLog(@"TTTTTTTTTTTTTTTTTT   %@",subfileto);
    NSString *orifilepath = [documentPlace stringByAppendingPathComponent:fileTo];
    NSString *filePath=[[documentPlace stringByAppendingPathComponent:subfileto ] stringByAppendingPathExtension:@"m"];
    NSLog(@"%@",orifilepath);
    NSString *matlabbody = [NSString stringWithFormat:@"A = [ \n"];
    NSString *content = [NSString stringWithContentsOfFile:orifilepath
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    
   matlabbody =[matlabbody stringByAppendingString:content];
    matlabbody = [matlabbody stringByAppendingString:@"]; \n x=A(:,1);\n y=A(:,2);\n z=A(:,3);\n l=length(x);\n t=0:0.05:0.05*(l-1); \n plot(t,x,'r',t,y,'g',t,z,'b') \n xlabel('Time');\n ylabel('Acceleration Data');\n legend('x','y','z');\n title('The acceleration data for HW02Q1 By Jiyang Zhou');\n"];
    //[matlabbody writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    return matlabbody;
}


-(void)displayComposerSheet
{       MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
//    picker.mailComposeDelegate=self;
    [picker setSubject:@"My acceleration data in txt By Jiyang Zhou"];
    [picker setMessageBody:fileTo isHTML:NO];
    
    // Set up recipients
    // NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    // [picker setToRecipients:toRecipients];
    // [picker setCcRecipients:ccRecipients];
    // [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    NSString *fulldir = [documentPlace stringByAppendingPathComponent:fileTo];
     NSData *fileData = [NSData dataWithContentsOfFile:fulldir];
    [picker addAttachmentData:fileData  mimeType:@"txt" fileName:fileTo];
    
    // Fill out the email body text
    

    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)displayComposerSheetInMatlab
{       MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    //    picker.mailComposeDelegate=self;
    [picker setSubject:@"My acceleration data in m By Jiyang Zhou"];
    [picker setMessageBody:fileTo isHTML:NO];
    
    // Set up recipients
    // NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    // [picker setToRecipients:toRecipients];
    // [picker setCcRecipients:ccRecipients];
    // [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
//    NSString *fulldir = [documentPlace stringByAppendingString:fileTo];
    NSData *fileData = [[self writeNewMatlab:fileTo] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *matfile =[NSString stringWithFormat:@"m"];
    NSString *followfilename =[[fileTo stringByDeletingPathExtension] stringByAppendingPathExtension:@"m"];
    matfile = [matfile stringByAppendingString:followfilename];
    [picker addAttachmentData:fileData  mimeType:@"m" fileName:matfile];
    
    // Fill out the email body text
    
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
