//
//  APPPastPoursViewController.h
//  FTT GUI
//
//  Created by Philip Xu on 7/1/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIAlertView.h"

@interface APPPastPoursViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *whitespace;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSDictionary* userInfo;
@property (nonatomic) NSDictionary* passingInfo;

@property (strong, nonatomic) NSMutableArray* listOfPours;
@property (strong, nonatomic) NSMutableArray* localPours;

@property (nonatomic) BOOL offLine;

@property (nonatomic) NSNumber* CO2Level;
@property (nonatomic) NSNumber* KegLevel;
@property (nonatomic) NSString* KegName;

@end
