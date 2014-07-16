//
//  APPSecondViewController.h
//  FTT GUI
//
//  Created by Philip Xu on 6/27/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPKegViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *beerName;
@property (weak, nonatomic) IBOutlet UIView *shinobiView;
@property (weak, nonatomic) IBOutlet UILabel *kegNameLabel;

@property (nonatomic) NSNumber* CO2Level;
@property (nonatomic) NSNumber* KegLevel;
@property (nonatomic) NSString* KegName;
@end
