//
//  APPSecondViewController.m
//  FTT GUI
//
//  Created by Philip Xu on 6/27/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import "APPKegViewController.h"

#import <ShinobiCharts/SChartSeriesStyle.h>
#import <ShinobiCharts/ShinobiChart.h>
#import <ShinobiCharts/SChartColumnSeriesStyle.h>
#import "UIColor+FlatUI.h"
#import "LocalyticsSession.h"
@interface APPKegViewController () <SChartDatasource>{
    ShinobiChart* _chart;
    SChartColumnSeries *_colseries;
}


@end

@implementation APPKegViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[LocalyticsSession shared] tagScreen:@"Settings"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"kegStats_Active.png"]];
    [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    [self drawHorizontalLine:64.4];
    
    
    // setting up shinobi tools
    //CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 30.0 : 150.0;
    _chart = [[ShinobiChart alloc] initWithFrame:CGRectInset(self.shinobiView.bounds, 0, 0)];
    
    
    _chart.title = @" ";
    _chart.licenseKey = @"";
    _chart.autoresizingMask =  ~UIViewAutoresizingNone;
    
    // add a pair of axes
    SChartCategoryAxis *xAxis = [[SChartCategoryAxis alloc] init];
    _chart.xAxis = xAxis;
    
    SChartAxis *yAxis = [[SChartNumberAxis alloc] initWithRange:[[SChartNumberRange alloc] initWithMinimum:@0 andMaximum:@100]];
    yAxis.title = @"";
    _chart.yAxis = yAxis;
    
    _chart.yAxis.minorTickFrequency = [NSNumber numberWithDouble:50];
    // add to the view
    [self.shinobiView addSubview:_chart];
    
    _chart.datasource = self;
    
    // show the legend
    _chart.legend.hidden = YES;
    
    // Column series;
    _colseries = [[SChartColumnSeries alloc]init];
    SChartColumnSeriesStyle* newStyle = [SChartColumnSeriesStyle new];
    newStyle.areaColor = [UIColor carrotColor];
    newStyle.showAreaWithGradient= NO;
    
    _colseries.style=newStyle;
    
    
    self.kegNameLabel.text = self.KegName;
}

- (int)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(int)index {
    return _colseries;
}

- (int)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(int)seriesIndex {
    return 2;
}

// ploting data points
- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(int)dataIndex forSeriesAtIndex:(int)seriesIndex {
    SChartDataPoint *datapoint = [[SChartDataPoint alloc] init];

    if(dataIndex == 0){
        datapoint.xValue= @"CO2 Health";
        datapoint.yValue =self.CO2Level;
    }else{
        
        datapoint.xValue= @"Keg Health";
        datapoint.yValue =self.KegLevel;
    }
    
    return datapoint;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//getting kegHealth from the server
-(void) retrieveInformationFromServer
{
    
    //setting the url for HTTP request
    NSString* urlstring = [NSString stringWithFormat:@"http://[your app url].herokuapp.com/kegHealth"];
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
            
            NSLog(responseArray);
            
            //setting each image file and transfering the dictionary in global variable
            
        }
    }];
    [dataTask resume];
    
}

// EASTER EGGS! when clicked button, will display rick roll image
- (IBAction)EasterEggs:(id)sender {
    if(self.shinobiView.hidden){
        self.shinobiView.hidden = NO;
    }else{
        self.shinobiView.hidden = YES;
    }
}

@end
