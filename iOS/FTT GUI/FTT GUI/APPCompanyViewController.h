//
//  APPFirstViewController.h
//  FTT GUI
//
//  Created by Philip Xu on 6/27/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPCompanyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIScrollView *scroller;
}
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *top5label;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profPic1;
@property (weak, nonatomic) IBOutlet UIImageView *profPic2;
@property (weak, nonatomic) IBOutlet UIImageView *profPic3;
@property (weak, nonatomic) IBOutlet UIImageView *profPic4;
@property (weak, nonatomic) IBOutlet UIImageView *profPic5;
@property (weak, nonatomic) IBOutlet UIImageView *profPic6;
@property (weak, nonatomic) IBOutlet UIImageView *profPic7;
@property (weak, nonatomic) IBOutlet UIImageView *profPic8;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *ounce1;
@property (weak, nonatomic) IBOutlet UILabel *ounce2;
@property (weak, nonatomic) IBOutlet UILabel *ounce3;
@property (weak, nonatomic) IBOutlet UILabel *ounce4;
@property (weak, nonatomic) IBOutlet UILabel *ounce5;
@property (weak, nonatomic) IBOutlet UILabel *ounce6;
@property (weak, nonatomic) IBOutlet UILabel *ounce7;
@property (weak, nonatomic) IBOutlet UILabel *ounce8;



//Data
@property (nonatomic,strong) NSMutableArray* leaderBoard;
@end
