//
//  APPFirstViewController.m
//  FTT GUI
//
//  Created by Philip Xu on 6/27/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import "APPCompanyViewController.h"
#import "UIColor+FlatUI.h"
#import "LocalyticsSession.h"

@interface APPCompanyViewController ()

@end

@implementation APPCompanyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"companyStats_Active.png"]];
    [self circularProfPics];
    [self setLabels];
    [self setScroller];
    [self drawHorizontalLine:64.4];
    [self retrieveInformationFromServer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocalyticsSession shared] tagScreen:@"Settings"];
}

- (void)circularProfPics {
    self.profPic1.layer.cornerRadius =  24;
    self.profPic1.layer.masksToBounds = YES;
    
    self.profPic2.layer.cornerRadius =  24;
    self.profPic2.layer.masksToBounds = YES;
    
    self.profPic3.layer.cornerRadius =  24;
    self.profPic3.layer.masksToBounds = YES;
    
    self.profPic4.layer.cornerRadius =  24;
    self.profPic4.layer.masksToBounds = YES;
    
    self.profPic5.layer.cornerRadius =  24;
    self.profPic5.layer.masksToBounds = YES;
    
    self.profPic6.layer.cornerRadius =  24;
    self.profPic6.layer.masksToBounds = YES;
    
    self.profPic7.layer.cornerRadius =  24;
    self.profPic7.layer.masksToBounds = YES;
    
    self.profPic8.layer.cornerRadius =  24;
    self.profPic8.layer.masksToBounds = YES;
}

// getting the leaderboard information from the server
-(void) retrieveInformationFromServer
{
    NSArray* imageViews =@[self.profPic1,self.profPic2,self.profPic3,self.profPic4,self.profPic5,self.profPic6,self.profPic7,self.profPic8];
    
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
            
            self.leaderBoard = responseArray;
            int a = 0;
            if(responseArray.count>=8){
                a = 8;
            }else{
                a = responseArray.count;
            }
            
            for(int i = 0; i<a; i++){
                NSURL* imageURL = [NSURL URLWithString:responseArray[i][@"user"][@"imageURL"]];
                //NSURL* imageURL = [NSURL URLWithString:@"http://www.randomwebsite.com/images/head.jpg"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        ((UIImageView* )imageViews[i]).image = [UIImage imageWithData:imageData];
                        @try {
                            [self.ounce1 setText:[NSString stringWithFormat:@"%d Oz", [responseArray[0][@"user"][@"totalOunces"] intValue]]];
                        }@catch (NSException *exception) {[self.ounce1 setText:@" "];}@finally {}
                        @try {
                            [self.ounce2 setText:[NSString stringWithFormat:@"%d Oz", [responseArray[1][@"user"][@"totalOunces"] intValue]]];
                        }@catch (NSException *exception) {[self.ounce2 setText:@" "];}@finally {}
                        @try {
                            [self.ounce3 setText:[NSString stringWithFormat:@"%d Oz", [responseArray[2][@"user"][@"totalOunces"] intValue]]];
                        }@catch (NSException *exception) {[self.ounce3 setText:@" "];}@finally {}
                        @try {
                            [self.ounce4 setText:[NSString stringWithFormat:@"%d Oz", [responseArray[3][@"user"][@"totalOunces"] intValue]]];
                        }@catch (NSException *exception) {[self.ounce4 setText:@" "];}@finally {}
                        @try {
                            [self.ounce5 setText:[NSString stringWithFormat:@"%d Oz", [responseArray[4][@"user"][@"totalOunces"] intValue]]];
                        }@catch (NSException *exception) {[self.ounce5 setText:@" "];}@finally {}
                        @try {
                            [self.ounce6 setText:[NSString stringWithFormat:@"%d Oz", [responseArray[5][@"user"][@"totalOunces"] intValue]]];
                        }@catch (NSException *exception) {[self.ounce6 setText:@" "];}@finally {}
                        @try {
                            [self.ounce7 setText:[NSString stringWithFormat:@"%d Oz", [responseArray[6][@"user"][@"totalOunces"] intValue]]];
                        }@catch (NSException *exception) {[self.ounce7 setText:@" "];}@finally {}
                        @try {
                            [self.ounce8 setText:[NSString stringWithFormat:@"%d Oz", [responseArray[7][@"user"][@"totalOunces"] intValue]]];
                        }@catch (NSException *exception) {[self.ounce8 setText:@" "];}@finally {}
                        
                    });
                    
                    
                });
                
            }
            
            
            [self.tableView reloadData];
            [self.tableView setContentOffset:CGPointMake(0, -1) animated:YES];
            [self.tableView setContentOffset:CGPointMake(0, +1) animated:YES];
            
            //setting each image file and transfering the dictionary in global variable
            
        }
    }];
    [dataTask resume];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setScroller {
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 810)];
}

- (void)setLabels {
    self.companyLabel.backgroundColor = [UIColor cloudsColor];
    self.top5label.backgroundColor = [UIColor cloudsColor];
    self.bottomLabel.backgroundColor = [UIColor cloudsColor];
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
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 64.4)];
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.path = [path1 CGPath];
    shapeLayer1.strokeColor = [[UIColor whiteColor] CGColor];
    shapeLayer1.lineWidth = 0.1;
    shapeLayer1.fillColor = [[UIColor whiteColor] CGColor];
    
    [self.view.layer addSublayer:shapeLayer1];
    
    CATextLayer *label = [[CATextLayer alloc] init];
    [label setFont:@"HelveticaNeue-Light"];
    [label setFontSize:24];
    [label setFrame:CGRectMake(0, 28, 320, 64.4)];
    [label setString:@"Company Stats"];
    [label setAlignmentMode:kCAAlignmentCenter];
    [label setForegroundColor:[[UIColor blackColor] CGColor]];
    label.contentsScale = [[UIScreen mainScreen] scale];
    [self.view.layer addSublayer:label];
}

// TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leaderBoard.count;
}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textLabel.text = self.listOfPours[indexPath.row][//somecriteria]
    // Configure the cell...
    
    cell.textLabel.text = self.leaderBoard[indexPath.row][@"user"][@"username"];
    return cell;
}

@end
