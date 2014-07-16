//
//  APPLoginViewController.m
//  FTT GUI
//
//  Created by Philip Xu on 6/27/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import "APPLoginViewController.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"
#import "APPKegViewController.h"
#import "APPMyselfViewController.h"
#import "APPCompanyViewController.h"
#import "APPAppDelegate.h"
#import "LocalyticsSession.h"
#import <AudioToolbox/AudioToolbox.h>
@interface APPLoginViewController ()
@property (strong, nonatomic) NSDate *targetDate;

@end

@implementation APPLoginViewController



-(void)rings {
    CGPoint centre;
    centre = [self.TwitterLoginButton center];
    [self addGrowingCircleAtPoint:centre];
}

- (void)updateCounter:(NSTimer *)theTimer {
    double now = [[NSDate date]timeIntervalSince1970];
    int targetTime = 1405022400+60*60/2;
    //int targetTime = 1404403290;
    if(now > targetTime){
        [theTimer invalidate];
        [self.lockedView setHidden:YES];
        self.offlineAccessButton.enabled =YES;
        self.buttonEnabled = YES;
        NSLog(@"unlock");
    }else{
        int diff = targetTime - (int)now;
        int second = diff%60;
        int minute = ((diff - second)/60)%60;
        int hour = (((diff - second)/60) - minute)/60;
        NSString *string = [NSString stringWithFormat:@"%d Hours, %d Minutes, %d Seconds", hour, minute, second];
        [self.timeLabel setText:string];
    }
    //    NSDate *now = [NSDate date];
    //    NSUInteger flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:now toDate:self.targetDate options:0];
    //    if (([components hour] <= -4) && ([components minute] <= 0) && ([components second] <= 0)) {
    //        [theTimer invalidate];
    //        [self.lockedView setHidden:YES];
    //        [self changeToTwitterIcon];
    //        NSString *string = [NSString stringWithFormat:@"%d Hours, %d minutes, %d seconds", [components hour] + 4, [components minute], [components second]];
    //        NSLog(string);
    //    }else {
    //
    //
    //        NSString *string = [NSString stringWithFormat:@"%d Hours, %d minutes, %d seconds", [components hour] + 4, [components minute], [components second]];
    //        [self.timeLabel setText:string];
    //    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocalyticsSession shared] tagScreen:@"Settings"];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.offLine=NO;
    [self drawHorizontalLine:64.4];
    //    //NSString *datestr = @"2014-07-10T16:00:00+00:00";
    //    NSString *datestr = @"2014-07-03T12:00:00+00:00";
    //    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    //
    //    [dformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    //    [dformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    //
    //    self.targetDate = [dformat dateFromString:datestr];
    //    NSLog([self.targetDate description]);
    
    [self setUpiBeacon];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(230/255.0) green:(230/255.0) blue:(230/255.0) alpha:1.0]];
    [self.TwitterLoginButton bringSubviewToFront:self.TwitterLoginButton.imageView];
    self.buttonEnabled = NO;
    [self.TwitterLoginImage setHidden:YES];
    [self start];
    [self startTimer2];
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)setOfflineAccessButton:(FUIButton *)offlineAccessButton{
    offlineAccessButton.buttonColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    offlineAccessButton.shadowColor = [UIColor darkGrayColor];
    offlineAccessButton.shadowHeight = 0.0f;
    offlineAccessButton.cornerRadius = 5.0f;
    offlineAccessButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [offlineAccessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [offlineAccessButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startTimer2 {
    [timer1 invalidate];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
}

-(IBAction)start{
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.2
                                             target:self
                                           selector:@selector(rings)
                                           userInfo:nil
                                            repeats:YES];
}

-(IBAction)stop{
    [timer invalidate];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && [[anim valueForKey:@"name"] isEqual:@"fade"]) {
        // when the fade animation is complete, we remove the layer
        CALayer* lyr = [anim valueForKey:@"layer"];
        [lyr removeFromSuperlayer];
    }
}
- (void)addGrowingCircleAtPoint:(CGPoint)point {
    // create a circle path
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddArc(circlePath, NULL, 0.f, 0.f, 39.f, 0.f, (float)2.f*M_PI, true);
    
    // create a shape layer
    CAShapeLayer* lyr = [[CAShapeLayer alloc] init];
    lyr.path = circlePath;
    
    // don't leak, please
    CGPathRelease(circlePath);
    lyr.delegate = self;
    
    // set up the attributes of the shape layer and add it to our view's layer
    lyr.strokeColor = [[UIColor colorWithRed:0.0 green:(100/255.0) blue:1.0 alpha:1] CGColor];
    lyr.fillColor = [[UIColor clearColor] CGColor];
    lyr.position = point;
    lyr.anchorPoint = CGPointMake(.5f, .5f);
    [self.view.layer addSublayer:lyr];
    
    // set up the growing animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [lyr valueForKey:@"transform"];
    // this will actually grow the circle into an oval
    CATransform3D t = CATransform3DMakeScale(16.f, 16.f, 1.f);
    animation.toValue = [NSValue valueWithCATransform3D:t];
    animation.duration = 8.f;
    animation.delegate = self;
    lyr.transform = t;
    [animation setValue:@"grow" forKey:@"name"];
    [animation setValue:lyr forKey:@"layer"];
    [lyr addAnimation:animation forKey:@"transform"];
    
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = [lyr valueForKey:@"opacity"];
    animation2.toValue = [NSNumber numberWithFloat:0.f];
    animation2.duration = 1.5;
    animation2.delegate = self;
    lyr.opacity = 0.f;
    [animation2 setValue:@"fade" forKey:@"name"];
    [animation2 setValue:lyr forKey:@"layer"];
    [lyr addAnimation:animation2 forKey:@"opacity"];
}

-(IBAction)changeToBluetoothIcon{
    self.buttonEnabled = NO;
    [self.kegStatusLabel setText:@"   Searching for nearby keg..."];
    [self.TwitterLoginButton setImage:[UIImage imageNamed:@"bluetooth.ico"] forState:UIControlStateNormal];
    [self.TwitterLoginImage setHidden:YES];
}

-(IBAction)changeToTwitterIcon{
    self.buttonEnabled = YES;
    [self.kegStatusLabel setText:@"Keg found!"];
    [self.TwitterLoginButton setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [self.TwitterLoginImage setHidden:NO];
    
}
//Online Access. Pour button enabled
- (IBAction)logIn:(id)sender {
    if (self.buttonEnabled) {
        @try {
            [self logInWithTwitter];
            
            self.buttonEnabled = NO;
        }
        @catch (NSException *exception) {
            NSLog(@"NOOOOO CRASSHED");
            
        }
        @finally {
        }
        
        self.buttonEnabled = NO;
    }
}

//offline Access. Pour button disabled
- (IBAction)offLineLogIn:(id)sender {
    
    [self logInWithTwitter];
    self.offLine=YES;
    self.buttonEnabled = NO;
    
}

#pragma mark iBeacon Methods

//set up iBeacon with a Unique UUID.
-(void) setUpiBeacon
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    NSUUID *uuid= [[NSUUID alloc]initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:@"1"];
    
    [self.locationManager startRangingBeaconsInRegion:  self.beaconRegion];
    [self.locationManager startMonitoringForRegion:     self.beaconRegion];
}

// Called when started Monitoring
- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self.locationManager requestStateForRegion:self.beaconRegion];
    
}

// called when found a beacon -- only when crossing a boarder
- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion*)region
{
    // Beacon found, start locating the beacon
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self changeToTwitterIcon];
    [self stop];
    
}

// when exit a region defined by a beacon
-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion*)region
{
    // Beacon lost
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self changeToBluetoothIcon];
    [self start ];
}

// When the beacon is ranged (found) and a distance is estimated
-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    CLBeacon *foundBeacon = [beacons firstObject];
    if(foundBeacon){
        // beacon found, show Twitter icon, vibrates, and connect with Twitter API
        [self changeToTwitterIcon];
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        [self stop];
    }
    
}

#pragma mark Twitter Method
//Twitter Methods

-(void)dismissAlertView
{
    
    [self.alertViewA dismissWithClickedButtonIndex:0 animated:YES];
}


-(void) logInWithTwitter
{
    // getting rankings in company
    [self getRanked];
    // check Twitter is configured in Settings or not
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        self.accountStore = [[ACAccountStore alloc] init]; //retain ACAccountStore
        ACAccountType *twitterAcc = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [self.accountStore requestAccessToAccountsWithType:twitterAcc options:nil completion:^(BOOL granted, NSError *error){
            //permission is granted
            if (granted){
                
                // show an alertview
                [[NSOperationQueue mainQueue] addOperationWithBlock:^
                 {
                     self.alertViewA = [[UIAlertView alloc]initWithTitle:@"Logging In" message:@"Peace, im trying to get you in" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [self.alertViewA show];
                      NSTimer* timerAlert = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissAlertView) userInfo:nil repeats:NO];
                 }];
                self.account = [[self.accountStore accountsWithAccountType:twitterAcc] lastObject];
                NSDictionary* parameters = @{@"screen_name" : self.account.username};
                
                //perform HTTP request to retrieve information from Twitter API
                NSURL* getUrl = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                SLRequest *getRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:getUrl parameters:parameters];
                getRequest.account=self.account;
                [getRequest performRequestWithHandler:^(NSData *responseData,
                                                        NSHTTPURLResponse *urlResponse, NSError *error){
                    //NSLog([NSString stringWithFormat:@"%li",(long)urlResponse.statusCode]);
                    
                    if(error==nil){
                        
                        NSError *jsonError;
                        // Convert to array of Dictionary
                        NSDictionary *acquiredData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                     options:NSJSONReadingAllowFragments
                                                                                       error:&jsonError];
                        if(acquiredData){
                            
                            // got data, do something
                            [self getKegHealth];
                            
                            NSString* bannerURL = @"";
                            NSString* profImageURL = acquiredData[@"profile_image_url"];
                            
                            for(int i = (int)profImageURL.length-1; i >=0; i --){
                                if([profImageURL characterAtIndex:i] == '.'){
                                    NSString * str1 = [profImageURL substringFromIndex:i];
                                    NSString *str2 = [profImageURL substringToIndex:i-7];
                                    profImageURL = [NSString stringWithFormat:@"%@%@",str2,str1];
                                    
                                    break;
                                }
                            }
                            
                            
                            if(acquiredData[@"profile_banner_url"]){
                                bannerURL = acquiredData[@"profile_banner_url"];
                            }
                            // packing information from Twitter to pass
                            self.userInfo = @{
                                              @"username":acquiredData[@"screen_name"],
                                              @"profilePic":profImageURL,
                                              @"name":acquiredData[@"name"],
                                              @"id":acquiredData[@"id_str"],
                                              @"location":acquiredData[@"location"],
                                              @"banner":bannerURL
                                              };
                            
                            
                            [self updateFromMongo];
                            
                        }else{
                            NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Errors Occurred" message:@"Something is wrong, please try later." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                            [alert show];
                        }
                    }else{
                        NSLog(@"internet Error");
                        self.offlineAccessButton.enabled = YES;
                    }
                }];
            }
            //permission is not granted
            else{
                if (error == nil) {
                    NSLog(@"User Has disabled your app from settings...");
                }
                else{
                    NSLog(@"Error in Login: %@", error);
                }
            }
        }];
    }
    else{
        NSLog(@"Not Configured in Settings......"); // show user an alert view that Twitter is not configured in settings.
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"No Set Up" message:@"Your device is not yet set up with Twitter, please go to System Prefence > Twitter to connect your device with Twitter" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alert show];
    }
}


// core data stack

// updating self.listOfPours with MongoDB
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
// set up coredata
-(void)setUpCoreData
{
    self.localPours = nil;
    self.localPours = [[NSMutableArray alloc]init];
    // getting stack
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

// update the local with the online storage
-(void) syncLocalWithMongo
{
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
            
            // if there is an error
            NSError* error;
            [context save:&error];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self performSegueWithIdentifier: @"LogIn" sender: self];
    });
}

// generate passing info
-(NSDictionary* )generatePassingInfo
{
    NSNumber *minutesAgo = [NSNumber numberWithInt:0];
    NSNumber *total = [NSNumber numberWithInt:0];
    NSNumber* TN = [NSNumber numberWithInt:0];
    NSString* word =@"";
    
    // getting the time since last pour
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
        
        // number of pours in 24hr
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
    if(self.rank ==nil){
        self.rank    = [NSNumber numberWithInt:0];
    }
    NSDictionary* newD = @{
                           @"total":total,
                           @"minutesAgo":minutesAgo,
                           @"Tonight":TN,
                           @"Word":word,
                           @"Rank":self.rank
                           };
    NSLog(newD.description);
    return newD;
}



#pragma mark
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // passing information
    if([segue.identifier isEqualToString:@"LogIn"]){
        UITabBarController* TVC = [segue destinationViewController];
        APPMyselfViewController* MVC = [TVC.viewControllers objectAtIndex:0];
        MVC.offLine = self.offLine;
        MVC.userInfo=self.userInfo;
        NSDictionary* passingInfo = [self generatePassingInfo];
        MVC.info=passingInfo;
        APPKegViewController* KGVC = [TVC.viewControllers objectAtIndex:2];
        KGVC.CO2Level = self.CO2Level;
        KGVC.KegLevel = self.KegLevel;
        KGVC.KegName = self.KegName;
    }
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

// HTTP request from the server to get Keg Health information
-(void)getKegHealth
{
    NSString* urlstring = [NSString stringWithFormat:@"http://[your app url].herokuapp.com/health"];
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
            
            self.CO2Level = responseArray[1][@"CO2Level"];
            self.KegLevel = responseArray[0][@"Keg"];
            self.kegName = responseArray[2][@"name"];
            //setting each image file and transfering the dictionary in global variable
            
        }
    }];
    [dataTask resume];
}

// get the ranking from the server via HTTP requests
-(void) getRanked
{
    //setting the url for HTTP request
    NSString* urlstring = [NSString stringWithFormat:@"http://[your app url].herokuapp.com/u/leaderboard"];
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
            self.rank = [NSNumber numberWithInt:0];
            for(int i = 0; i<responseArray.count; i++){
                
                if([responseArray[i][@"user"][@"displayName"] isEqualToString:self.account.username]){
                    self.rank =responseArray[i][@"rank"];
                }
            }
        }else{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 UIAlertView* alertA = [[UIAlertView alloc]initWithTitle:@"Internet Error" message:@"There is an error in your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alertA show];
             }];
        }
    }];
    [dataTask resume];
    
}




@end
