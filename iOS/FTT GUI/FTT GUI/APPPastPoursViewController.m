//
//  APPPastPoursViewController.m
//  FTT GUI
//
//  Created by Philip Xu on 7/1/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import "APPPastPoursViewController.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "APPAppDelegate.h"
#import "APPMyselfViewController.h"
#import "APPKegViewController.h"
#import "LocalyticsSession.h"
@interface APPPastPoursViewController ()

@end

@implementation APPPastPoursViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    [self drawHorizontalLine:64.4];
    self.localPours = nil;
    self.localPours=[[NSMutableArray alloc]init];
    [self updateFromMongo];


    [self.navigationItem setTitle:@"Past Pours"];
    [self bannerSetup];
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

}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSLog(self.localPours.description);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textLabel.text = self.listOfPours[indexPath.row][//somecriteria]
    // Configure the cell...
    int time =  [self.localPours[self.localPours.count -1 - indexPath.row][@"startTime"] doubleValue];
    int now = [[NSDate date]timeIntervalSince1970];
    NSString* timeInterval = @"";
    if(now - time <60*60*24){
        time = time%86400;
        int Second = time%60;
        int minute = ((time -time%60)/60)%60;
        int hour = (((time - Second)/60) - minute)/60-4;
        if(hour<0){
            hour = 24-hour;
        }
        timeInterval = [NSString stringWithFormat:@"%d:%d:%d        ",hour,minute,Second];
    }else{
        NSDate* Adate = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        timeInterval = [formatter stringFromDate:Adate];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@       %@ Oz",timeInterval,[self.localPours[self.localPours.count -1 - indexPath.row][@"fluidOunces"] stringValue]];
    
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.;
    return self.localPours.count;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bannerSetup
{
    self.whitespace.layer.cornerRadius =  42.5;
    self.whitespace.layer.masksToBounds = YES;
    self.profileImage.layer.cornerRadius = 40;
    self.profileImage.layer.masksToBounds = YES;
}

- (IBAction)profileClicked:(id)sender {
    [self showActionSheet:self];
}

- (void)showActionSheet:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select options:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
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

- (IBAction)back:(id)sender {
    [self performSegueWithIdentifier:@"back" sender:self];
}

- (void)showAlertView {
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Settings" message:@"" delegate:nil cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Log Out" ,nil];
    alertView.alertViewStyle = FUIAlertViewStyleDefault;
    
    alertView.delegate = self;
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor pumpkinColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor blackColor];
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Log Out"])
    {
        [self performSegueWithIdentifier:@"logout" sender:self];
        NSLog(@"loging out");
    }
}

-(void)updateFromMongo{
    
    self.listOfPours=[[NSMutableArray alloc]init];
    
    //setting the url for HTTP request
    NSString* urlstring = [NSString stringWithFormat:@"http://[your app url].herokuapp.com/p/cid/%@",self.userInfo[@"id"] ];
    NSURL *url = [NSURL URLWithString:urlstring];
    
    //setting request type and body
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //execute the request
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            for(int i= 0; i<[responseArray count]; i++)
            {
                for(int j = 0; j< [responseArray[i][@"pour"] count]; j++)
                {
                    NSMutableDictionary* indiv = responseArray[i][@"pour"][j];
                    
                    [self.listOfPours addObject:indiv];
                }
            }
            
            [self setUpCoreData];
            [self syncLocalWithMongo];
        }
    }];
    [dataTask resume];
}

-(void)setUpCoreData
{
    
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

-(void) syncLocalWithMongo
{
    
    NSLog([NSString stringWithFormat:@"%d",self.localPours.count]);
    APPAppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext* context = [delegate managedObjectContext];
    
    //if local and is different from online.SYNC!!!!
    // add the difference into core data
    for(NSMutableDictionary* indivPour in self.listOfPours){
        BOOL found = NO;
        NSNumber* pourID = indivPour[@"id"];
        for(NSMutableDictionary* localPour in self.localPours)
        {
            if([localPour[@"id"] intValue]==[pourID intValue]){
                found = YES;
            }
        }
        
        if(!found){
            //add it into core data and local list
            
            [self.localPours addObject:indivPour];
            NSManagedObjectContext* newContext;
            
            NSNumberFormatter* f = [[NSNumberFormatter alloc]init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *cidInt = [f numberFromString:self.userInfo[@"id"]];
            
            newContext = [NSEntityDescription insertNewObjectForEntityForName:@"Pours" inManagedObjectContext:context];
            [newContext setValue:cidInt forKey:@"cid"];
            //and set others
            [newContext setValue:indivPour[@"id"] forKey:@"pourID"];
            [newContext setValue:indivPour[@"currentTime"] forKey:@"currentTime"];
            [newContext setValue:indivPour[@"humidity"] forKey:@"humidity"];
            [newContext setValue:indivPour[@"container"] forKey:@"container"];
            [newContext setValue:indivPour[@"fluidOunces"] forKey:@"fluidOunces"];
            [newContext setValue:indivPour[@"endTime"] forKey:@"endTime"];
            [newContext setValue:indivPour[@"startTime"] forKey:@"startTime"];
            [newContext setValue:indivPour[@"temperature"] forKey:@"temperature"];
            
            //
            NSError* error;
            [context save:&error];
        }
    }
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    [self.tableView setContentOffset:CGPointMake(0, -1) animated:YES];
    [self.tableView setContentOffset:CGPointMake(0, +1) animated:YES];
    NSLog([NSString stringWithFormat:@"%d",self.localPours.count]);

}

- (void)drawHorizontalLine :(CGFloat)height {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, height)];
    [path addLineToPoint:CGPointMake(320.0, height)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
    shapeLayer.lineWidth = 0.5;
    shapeLayer.fillColor = [[UIColor blackColor] CGColor];
    
    [self.view.layer addSublayer:shapeLayer];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"back"]){
        UITabBarController* TBC  = segue.destinationViewController;
        APPMyselfViewController* MVC = [TBC.viewControllers objectAtIndex:0];
        MVC.userInfo = self.userInfo;
        MVC.info = [self generatePassingInfo];
        MVC.offLine = self.offLine;
        
        APPKegViewController* KVC = [TBC.viewControllers objectAtIndex:2];
        KVC.CO2Level =self.CO2Level;
        KVC.KegLevel =self.KegLevel;
        KVC.KegName = self.KegName;
    }
}

-(NSDictionary* )generatePassingInfo
{
    NSNumber *minutesAgo = [NSNumber numberWithInt:0];
    NSNumber *total = [NSNumber numberWithInt:0];
    NSNumber* TN = [NSNumber numberWithInt:0];
    NSString* word =@"";
    if(self.localPours.count>0){
        int diff = (int)(([[NSDate date]timeIntervalSince1970] - [self.localPours[self.localPours.count-1][@"endTime"] doubleValue])/60);
        if(diff<60){
            word = @"Minutes ago";
        }else if(diff>=60 && diff<24*60){
            diff = diff/60;
            word = @"Hours ago";
        }else if(diff>=24*60){
            diff = diff/1440;
            word = @"Days ago";
        }
        
        
        minutesAgo = [NSNumber numberWithInt:diff];
        total = [NSNumber numberWithInt:self.localPours.count];
        int tonight = 0;
        for(int i = self.localPours.count-1; i >=0; i--){
            int dif = (int)(([[NSDate date]timeIntervalSince1970] - [self.localPours[i][@"endTime"] doubleValue])/60);
            if(dif<1440){
                tonight++;
            }
        }
        
        TN = [NSNumber numberWithInt:tonight];
        NSLog(@"√");
    }
    
    NSDictionary* newD = @{
                           @"total":total,
                           @"minutesAgo":minutesAgo,
                           @"Tonight":TN,
                           @"Word":word,
                           @"Rank":self.passingInfo[@"Rank"]
                           };
    return newD;
}

@end
