//
//  APPLoginViewController.h
//  FTT GUI
//
//  Created by Philip Xu on 6/27/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "FUIButton.h"

@interface APPLoginViewController : UIViewController <CLLocationManagerDelegate,NSStreamDelegate>{
    NSTimer *timer;
    NSTimer *timer1;
}

@property (weak, nonatomic) IBOutlet UIButton *TwitterLoginButton;
@property (weak, nonatomic) IBOutlet UIImageView *TwitterLoginImage;
@property (strong, nonatomic) IBOutlet UIView *LoginView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *lockedView;
@property (weak, nonatomic) IBOutlet UILabel *kegStatusLabel;
@property (weak, nonatomic) IBOutlet FUIButton *offlineAccessButton;
@property (nonatomic) BOOL buttonEnabled;

//iBeacon Properties
@property (strong, retain) CLLocationManager* locationManager;
@property (strong, retain) CLBeaconRegion* beaconRegion;

//Twitter Properties
@property (strong, retain) ACAccount* account;
@property (strong, retain) ACAccountStore  *accountStore;


//data
//holds the information from Twitter
@property (strong, nonatomic) NSDictionary* userInfo;

//Local storage and online storage of pour objects
@property (nonatomic, strong) NSMutableArray* localPours;
@property (nonatomic, strong) NSMutableArray* listOfPours;


@property (nonatomic) BOOL offLine;
// data to pass to APPMyselfViewController
@property (nonatomic) NSNumber* CO2Level;
@property (nonatomic) NSNumber* KegLevel;
@property (nonatomic) NSString* KegName;
@property (nonatomic) NSNumber* rank;

@property (nonatomic, retain) UIAlertView* alertViewA;
@end
