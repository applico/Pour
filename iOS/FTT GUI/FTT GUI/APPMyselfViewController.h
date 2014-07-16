//
//  APPMyselfViewController.h
//  FTT GUI
//
//  Created by Philip Xu on 6/30/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIAlertView.h"

@interface APPMyselfViewController : UIViewController <NSStreamDelegate, UIActionSheetDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *whitespace;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *beerImage;
// labels
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *pourIn24Label;
@property (weak, nonatomic) IBOutlet UILabel *totalPour;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

// data
@property (nonatomic) BOOL offLine;
@property (nonatomic) NSDictionary* info;
@property (nonatomic, strong) NSDictionary* userInfo;

// socket objects
@property (nonatomic,strong)NSInputStream* inputStream;
@property (nonatomic,strong)NSOutputStream* outputStream;

@property (nonatomic, strong) NSMutableArray* localPours;

@property (nonatomic, strong) NSTimer *socketTimer;
@property (nonatomic, strong) NSTimer *pourTimer;

@end
