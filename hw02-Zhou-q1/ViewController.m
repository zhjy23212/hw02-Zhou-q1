//
//  ViewController.m
//  hw02-Zhou-q1
//
//  Created by Jiyang on 15/2/2.
//  Copyright (c) 2015年 Jiyang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



//@property (weak, nonatomic) IBOutlet UILabel *sliderValue;
@property (weak, nonatomic) IBOutlet UILabel *recoedLabel;
@property (weak, nonatomic) IBOutlet UISlider *recordTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *theRECbutton;

@property (weak, nonatomic) IBOutlet UILabel *recLabel;
//@property(readonly, nonatomic) CMAcceleration *acceleration;
@end



@implementation ViewController

NSString *filePath;
NSMutableString *body;
CMMotionManager *motionManager;
NSFileManager *fileMgr;
NSString *documentPath;
NSArray *pickerarray;
bool hasTimeInterval;
int theTimeSet;
NSTimer *myTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    motionManager = [[CMMotionManager alloc] init];
    fileMgr =[[NSFileManager alloc] init] ;
    NSArray *docu = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentPath = [docu objectAtIndex:0];
    NSLog(@"%@",documentPath);
    hasTimeInterval=false;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (IBAction)changeValue:(UISlider *)sender {
    _recoedLabel.text = [NSString stringWithFormat:@"Set record time:%d s",(int)sender.value];
    if ((int)sender.value!=0) {
        hasTimeInterval=true;
        theTimeSet=(int)sender.value;
    
    }else{
        hasTimeInterval=false;
        theTimeSet=0;
    }
}

- (IBAction)touchRec:(UIButton *)sender {
    
    
//    bool initFlag = YES;
    
    if (self.recLabel.hidden) {
//        initFlag = NO;
       
            
        body= nil;
        [sender setImage:[UIImage imageNamed:@"stop"]
                forState: UIControlStateNormal];
        NSLog(@"record accelerator");
        self.recLabel.hidden= false;
        filePath=nil;
        NSString *homeDirectory = NSHomeDirectory();
        NSLog(@"path:%@", homeDirectory);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSLog(@"path:%@", path);
        
        NSDate *timeNow = [NSDate date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyyMMdd_HH_mm_ss"];
        NSString *datestring = [dateFormat stringFromDate:timeNow];
        NSLog(@"now time is: %@",datestring);
        body = [NSMutableString stringWithFormat:@"%% Generated on %@ \n%% By Jiyang Zhou \n",timeNow ];
        NSLog(@"%@",body);

        
        filePath = [[path stringByAppendingPathComponent:datestring ] stringByAppendingPathExtension:@"txt"];
        
        NSLog(@"%@",filePath);
//        [header writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil ];
        
    
        if (motionManager.accelerometerAvailable) {
            motionManager.accelerometerUpdateInterval =
            1.0/20;
            
            
            [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                CMAccelerometerData *newestAccel = motionManager.accelerometerData;
                NSString *accData = [NSString stringWithFormat:@"%f\t%f\t%f\n",newestAccel.acceleration.x,newestAccel.acceleration.y,newestAccel.acceleration.z];
                [body appendString:accData];
                [body writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
                NSLog(@"%f, %f, %f",newestAccel.acceleration.x,newestAccel.acceleration.y,newestAccel.acceleration.z );
            }];
            if (hasTimeInterval) {
                self.recordTimeLabel.hidden=true;
                myTimer =[NSTimer scheduledTimerWithTimeInterval:theTimeSet target:self selector:@selector( resetTheRecord )userInfo:nil repeats:NO];
            }
        
        }
        
    }else{
        [sender setImage:[UIImage imageNamed:@"record"]
                forState:UIControlStateNormal];
        self.recLabel.hidden=true;
//        initFlag =YES;
        if (motionManager.isAccelerometerActive) {
            NSLog(@"FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU");
        }
        [motionManager stopAccelerometerUpdates];
//        [body writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
//        NSLog(@"%@",body);
        if (hasTimeInterval) {
            [myTimer invalidate];
            self.recordTimeLabel.hidden=false;
        }
        NSLog(@"end recording");
        
        
    
    }
    
    
}



-(void)resetTheRecord{
    [_theRECbutton setImage:[UIImage imageNamed:@"record"]
            forState:UIControlStateNormal];
    self.recordTimeLabel.hidden=false;
    self.recLabel.hidden=true;
    //        initFlag =YES;
    if (motionManager.isAccelerometerActive) {
       // NSLog(@"FUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU");
    }
    [motionManager stopAccelerometerUpdates];
    [myTimer invalidate];
    NSLog(@"end recording with time interval!!!!!");
}


- (IBAction)deleteall:(UIButton *)sender {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    while (files.count > 0) {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
        if (error == nil) {
            for (NSString *path in directoryContents) {
                NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
                BOOL removeSuccess = [fileMgr removeItemAtPath:fullPath error:&error];
                files = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
                if (!removeSuccess) {
                    // Error
                }
            }
        } else {
            // Error
        }
    }
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


- (IBAction)sendfile:(UIButton *)sender {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Want Matlab?"
//                                                    message:@"Do you want to wrap the file into a .m file？"
//                                                   delegate:self
//                                          cancelButtonTitle:@"No"
//                                          otherButtonTitles:@"Yes", nil];
//    
//    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { // means share button pressed
        // write your code here to do whatever you want to do once the share button is pressed
        NSLog(@"NONONONONONONONO");
        
    }
    if(buttonIndex == 1) { // means apple button pressed
        // write your code here to do whatever you want to do once the apple button is pressed
         NSLog(@"YESYESYESYES");
    }
    // and so on for the last button
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
