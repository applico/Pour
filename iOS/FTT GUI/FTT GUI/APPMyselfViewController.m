//
//  APPMyselfViewController.m
//  FTT GUI
//
//  Created by Philip Xu on 6/30/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import "APPMyselfViewController.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIBarButtonItem+FlatUI.h"
#import "FUIAlertView.h"
#import "APPPastPoursViewController.h"
#import "APPAppDelegate.h"
#import "LocalyticsSession.h"


@interface APPMyselfViewController ()
@property (weak, nonatomic) IBOutlet FUIButton *alertViewButton;

@end

@implementation APPMyselfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocalyticsSession shared] tagScreen:@"Settings"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"myStats_Active.png"]];
    if(self.offLine){
        self.alertViewButton.enabled = NO;
        //AlertView
    }
    //NSLog(self.userInfo.description);
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    // Do any additional setup after loading the view.

    [self setAlertViewButton];
    [self bannerSetup];

    // Displaying profile and banner picture
    NSLog(self.info.description);
    NSURL* imageURL = [NSURL URLWithString:self.userInfo[@"profilePic"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.profileImage.image = [UIImage imageWithData:imageData];
        });
    });
    
    if(![self.userInfo[@"banner"] isEqualToString:@""]){
        NSURL* imageURL2 = [NSURL URLWithString:self.userInfo[@"banner"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData2 = [NSData dataWithContentsOfURL:imageURL2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                self.bannerImage.image = [UIImage imageWithData:imageData2];
            });
        });
    }
    [self setUpCoreData];
}

-(void)viewWillAppear:(BOOL)animated{
    // setting labels everytime the view appear
    if([self.info[@"total"] intValue]==0){
        self.totalPour.text = @"---";
        self.minuteLabel.text =@"---";
        self.pourIn24Label.text = @"---";
        self.rankLabel.text = @"---";
    }else{
        self.totalPour.text =[ NSString stringWithFormat:@"%lu",(unsigned long)self.localPours.count];
        
        if([self.info[@"minutesAgo"]intValue]>9999){
            self.minuteLabel.text = @"Many";
        }else{
            self.minuteLabel.text = [self.info[@"minutesAgo"] stringValue];
        }
        self.wordLabel.text = self.info[@"Word"];
        int tonight = 0;
        for(int i = self.localPours.count-1; i >=0; i--){
            int dif = (int)(([[NSDate date]timeIntervalSince1970] - [self.localPours[i][@"endTime"] doubleValue])/60);
            if(dif<1440){
                tonight++;
            }
        }
        self.pourIn24Label.text = [self.info[@"Tonight"] stringValue];

    }
    
    self.wordLabel.text = self.info[@"Word"];
    self.rankLabel.text =[self.info[@"Rank"] stringValue];

}

- (void)setAlertViewButton{
    self.alertViewButton.buttonColor = [UIColor carrotColor];
    self.alertViewButton.shadowColor = [UIColor pumpkinColor];
    self.alertViewButton.shadowHeight = 2.0f;
    self.alertViewButton.cornerRadius = 5.0f;
    self.alertViewButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.alertViewButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.alertViewButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}


- (IBAction)profileClicked:(id)sender {
    [self showActionSheet:self];
}

- (void)showActionSheet:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select options:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Past Pours",
                            @"Log Out",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self performSegueWithIdentifier:@"pastpours" sender:self];
                    NSLog(@"past pours");
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"logout" sender:self];
                    NSLog(@"loging out");
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)bannerSetup{
    self.whitespace.layer.cornerRadius =  42.5;
    self.whitespace.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 38.5;
    self.profileImage.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pourDrink:(id)sender {
    [self initializeNetworkCommunication];
    self.alertViewButton.enabled = NO;
}

- (void)showPouringAnimation {
    [self.beerImage setImage:[UIImage animatedImageNamed:@"pouranimation" duration:5.5f]];
    self.beerImage.hidden = NO;
}

- (void)stopPouringAnimation {
    self.beerImage.hidden = YES;
}

// handles events for socket connections
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    NSLog(@"got an event");
    
    switch (eventCode) {
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"None!");
            break;
        // when stream opend
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            [self.pourTimer invalidate];
            self.pourTimer = nil;
            // set timer so that when Stream does not get response in 5 seconds, it will close
            if(self.socketTimer == nil){
                self.socketTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
            }
            break;
        case NSStreamEventHasBytesAvailable:
            if (aStream == self.inputStream) {
                uint8_t buffer[1024];
                int len;
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (nil != output) {
                            NSLog(@"%@",output);
                            // if receiving string is a confirmation message for completing a pour:
                            if([output isEqualToString:@"DEMACIA!"]){
                            //refresh view
                                NSNumber* Total =[NSNumber numberWithInt:([self.info[@"total"]intValue]+1)];
                                self.totalPour.text = [Total stringValue];
                                
                                self.minuteLabel.text = @"0";
                                NSNumber* Tonight =[NSNumber numberWithInt:([self.info[@"Tonight"]intValue]+1)];
                                self.pourIn24Label.text = [Tonight stringValue];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pour Complete" message:@"Happy Hour Incoming!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alert show];
                                self.alertViewButton.enabled=YES;
                                [self closeConnection];
                                [self stopPouringAnimation];
                            // or a completing message for starting the pour
                            }else if([output isEqualToString:@"STOP"]){
                                NSLog(@"√");
                                [self.socketTimer invalidate];
                                self.socketTimer = nil;
                                
                                NSString* response = [self generateSocketMessage];
                                NSData* data = [[NSData alloc]initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
                                [self.outputStream write:[data bytes] maxLength:[data length]];
                                // show animation
                                [self showPouringAnimation];
                            }
                        }
                    }
                }
            }
    }
}
// generate a string of user information
-(NSString* )generateSocketMessage
{
    NSString* outgoingString = self.userInfo[@"name"];
    
    outgoingString = [NSString stringWithFormat:@"%@+%@",outgoingString, self.userInfo[@"username"]];
    outgoingString = [NSString stringWithFormat:@"%@+%@",outgoingString, self.userInfo[@"location"]];
    outgoingString = [NSString stringWithFormat:@"%@+%@",outgoingString, self.userInfo[@"profilePic"]];
    outgoingString = [NSString stringWithFormat:@"%@+%@+%@",outgoingString, self.userInfo[@"id"],@"|"];
    
    return outgoingString;
}

// close all streams
-(void)closeConnection{

    [self.inputStream close];
    [self.outputStream close];
    [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream setDelegate:nil];
    [self.outputStream setDelegate:nil];
    self.inputStream = nil;
    self.outputStream = nil;
    
    
}

-(void)cannotFind{
    [self closeConnection];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Find Nearby Keg" message:@"Nearby Keg is down! Come and try later!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    self.alertViewButton.enabled=YES;
}

-(void)timeOut{
    self.pourTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(cannotFind) userInfo:nil repeats:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Out" message:@"Patient! Someone else is using it!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    self.alertViewButton.enabled=YES;
    [self closeConnection];
}


//Socket Connection to RPi via local host
-(void)initializeNetworkCommunication
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"[Your Pi's IP]", 9000, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    [self.outputStream open];
    // send message "ll to it"
    NSString* response = @"ll";
    NSData* data = [[NSData alloc]initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
    
    self.pourTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(cannotFind) userInfo:nil repeats:NO];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pastpours"]){
        APPPastPoursViewController* PVC = segue.destinationViewController;
        PVC.userInfo = self.userInfo;
        PVC.passingInfo=self.info;
        PVC.offLine = self.offLine;
        PVC.CO2Level = [[self.tabBarController.viewControllers objectAtIndex:2] CO2Level];
        PVC.KegLevel = [[self.tabBarController.viewControllers objectAtIndex:2] KegLevel];
        PVC.KegName = [[self.tabBarController.viewControllers objectAtIndex:2] KegName];
    }
}


-(void)setUpCoreData
{
    self.localPours = nil;
    self.localPours = [[NSMutableArray alloc]init];
    APPAppDelegate* delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext* context = [delegate managedObjectContext];
    
    NSEntityDescription* entityDescription = [NSEntityDescription entityForName:@"Pours" inManagedObjectContext:context];
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(cid = \"%@\")",self.userInfo[@"id"]]];
    NSManagedObject* matches = nil;
    //load existing data from core data stack
    [request setPredicate:pred];
    NSError* error;
    NSArray* objects = [context executeFetchRequest:request error:&error];
    
    if([objects count]==0)
    {
        NSLog(@"No Match Found");
    }else{
        for(int i = 0; i<[objects count]; i++)
        {
            matches = objects[i];
            NSDictionary* thisPour = @{
                                       @"id":[matches valueForKey:@"pourID"],
                                       @"temperature":[matches valueForKey:@"temperature"],
                                       @"humidity":[matches valueForKey:@"humidity"],
                                       @"container":[matches valueForKey:@"container"],
                                       @"currentTime":[matches valueForKey:@"currentTime"],
                                       @"endTime":[matches valueForKey:@"endTime"],
                                       @"fluidOunces":[matches valueForKey:@"fluidOunces"],
                                       @"startTime":[matches valueForKey:@"startTime"],
                                       @"_id" : @""
                                       };
            
            [self.localPours addObject:thisPour];
        }
    }
    
}


@end
