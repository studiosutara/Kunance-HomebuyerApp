//
//  kCATIntroLifestyleViewController.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 10/7/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "kCATIntroLifestyleViewController.h"
#import <ShinobiCharts/ShinobiChart.h>

@interface kCATIntroLifestyleViewController () <SChartDatasource, SChartDelegate>
@property (nonatomic, strong) ShinobiChart* mHomeLifeStyleChart;

@end

@implementation kCATIntroLifestyleViewController
{
    NSDictionary* homePayments;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setupChart
{
    
    float lifestyleIncome = 4261;
    float totalFixedCosts = 770;
    float homeEstTaxesPaid = 1657;
    float totalMonthlyPayment = 2478;
        
    // create the data
    homePayments = @{@"Cash Flow" : [NSNumber numberWithFloat:lifestyleIncome],
                     @"Fixed Costs" : [NSNumber numberWithInt:totalFixedCosts],
                     @"Est. Income Tax" : [NSNumber numberWithFloat:homeEstTaxesPaid],
                     @"Monthly Payment" : [NSNumber numberWithFloat:totalMonthlyPayment]};
        
    if (IS_WIDESCREEN)
    {
        self.mHomeLifeStyleChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(20, 125, 280, 190)];
    }
    else
    {
        self.mHomeLifeStyleChart = [[ShinobiChart alloc] initWithFrame:CGRectMake(25, 80, 265, 180)];
    }
    
    self.mHomeLifeStyleChart.autoresizingMask =  ~UIViewAutoresizingNone;
    self.mHomeLifeStyleChart.licenseKey = SHINOBI_LICENSE_KEY;
        
    // this view controller acts as the datasource
    self.mHomeLifeStyleChart.datasource = self;
    self.mHomeLifeStyleChart.delegate = self;
    self.mHomeLifeStyleChart.legend.hidden = NO;
    self.mHomeLifeStyleChart.backgroundColor = [UIColor clearColor];
    self.mHomeLifeStyleChart.legend.backgroundColor = [UIColor clearColor];
    self.mHomeLifeStyleChart.legend.style.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.mHomeLifeStyleChart.legend.style.symbolCornerRadius = @0;
    self.mHomeLifeStyleChart.legend.style.borderColor = [UIColor darkGrayColor];
    self.mHomeLifeStyleChart.legend.style.cornerRadius = @0;
    self.mHomeLifeStyleChart.legend.position = SChartLegendPositionMiddleLeft;
    self.mHomeLifeStyleChart.legend.placement = SChartLegendPlacementOutsidePlotArea;
    self.mHomeLifeStyleChart.plotAreaBackgroundColor = [UIColor clearColor];
        
    [self.view addSubview:self.mHomeLifeStyleChart];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.bounds = CGRectMake(0, 0, [Utilities getDeviceWidth], [Utilities getDeviceHeight]);
    
    UIImage* backImage = nil;
    UILabel* label = nil;
    
    if (IS_WIDESCREEN)
    {
        backImage = [UIImage imageNamed:@"home-interior_02.jpg"];
        label = [[UILabel alloc] initWithFrame:CGRectMake(160, 65, 237, 40)];
    }
    else
    {
        backImage = [UIImage imageNamed:@"home-interior-iphone4_02.jpg"];
        label = [[UILabel alloc] initWithFrame:CGRectMake(160, 50, 237, 40)];
    }
    
    UIImageView* backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImageView.image = backImage;
    [self.view addSubview:backImageView];
    
    label.center = CGPointMake(self.view.center.x, label.center.y);
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Find out which home fits in your wallet.";
    label.font = [UIFont fontWithName:@"cocon" size:16];
    label.textColor = [Utilities getKunanceBlueColor];
    [self.view addSubview:label];
    
    [self setupChart];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Looked at FTUE Screen 1 - Lifestyle" properties:Nil];
}

#pragma mark - SChartDelegate methods

- (void)sChart:(ShinobiChart *)chart
toggledSelectionForRadialPoint:(SChartRadialDataPoint *)dataPoint
      inSeries:(SChartRadialSeries *)series
atPixelCoordinate:(CGPoint)pixelPoint
{
}

#pragma mark - SChartDatasource methods

- (NSInteger)numberOfSeriesInSChart:(ShinobiChart *)chart {
    return 1;
}

-(SChartSeries *)sChart:(ShinobiChart *)chart seriesAtIndex:(NSInteger)index {
    SChartPieSeries* pieSeries = [[SChartPieSeries alloc] init];
    pieSeries.style.chartEffect = SChartRadialChartEffectBevelledLight;
    pieSeries.selectedStyle.protrusion = 10.0f;
    pieSeries.style.labelFont = [UIFont fontWithName:@"Helvetica Neue" size:12];
    pieSeries.style.labelFontColor = [UIColor whiteColor];
    pieSeries.labelFormatString = @"%.0f";
    pieSeries.style.showCrust = NO;
    pieSeries.animationEnabled = YES;
    NSMutableArray* colors = [[NSMutableArray alloc] init];
    [colors addObject:[UIColor colorWithRed:155.0/255.0 green:89.0/255.0 blue:182.0/255.0 alpha:1.0]];
    [colors addObject:[UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [colors addObject:[UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0]];
    [colors addObject:[UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0]];
    pieSeries.style.flavourColors = colors;
    pieSeries.selectedStyle.flavourColors = colors;
    return pieSeries;
}


- (NSInteger)sChart:(ShinobiChart *)chart numberOfDataPointsForSeriesAtIndex:(NSInteger)seriesIndex {
    return homePayments.allKeys.count;
}

- (id<SChartData>)sChart:(ShinobiChart *)chart dataPointAtIndex:(NSInteger)dataIndex forSeriesAtIndex:(NSInteger)seriesIndex {
    SChartRadialDataPoint *datapoint = [[SChartRadialDataPoint alloc] init];
    NSString* key = homePayments.allKeys[dataIndex];
    datapoint.name = key;
    
    NSNumber* value =  homePayments[key];
    if([value compare:@0] == NSOrderedAscending)
    {
        datapoint.value = @0;
        return datapoint;
    }
    else
    {
        datapoint.value = homePayments[key];
        return datapoint;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
