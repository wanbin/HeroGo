//
//  WBSendViewPlay.m
//  HeroGo
//
//  Created by 万斌 on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WBSendViewPlay.h"



@interface WBSendViewPlay (Private)

- (void)dayValueChanged:(UIStepper *)stepper;

@end





@implementation WBSendViewPlay

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret text:(NSString *)text image:(UIImage *)image planid:(int)planid
{
	if (self = [super initWithAppKey:appKey appSecret:appSecret text:text image:image ])
    {
		
		playid = planid;
        planTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13,50, 140, 30)];
        [planTitleLabel setText:NSLocalizedString(@"计划名称", nil)];
        [planTitleLabel setTextColor:[UIColor blackColor]];
        [planTitleLabel setBackgroundColor:[UIColor clearColor]];
        [planTitleLabel setTextAlignment:UITextAlignmentLeft];
//        [planTitleLabel setCenter:CGPointMake(144, 27)];
        [planTitleLabel setShadowOffset:CGSizeMake(0, 1)];
		[planTitleLabel setShadowColor:[UIColor whiteColor]];
        [planTitleLabel setFont:[UIFont systemFontOfSize:19]];
		[panelView addSubview:planTitleLabel];
		
		planTitleTextView = [[UITextView alloc] initWithFrame:CGRectMake(13, 70, 288 - 26, 150)];
		[planTitleTextView setEditable:YES];
		[planTitleTextView setDelegate:self];
        [planTitleTextView setText:@""];
		[planTitleTextView setBackgroundColor:[UIColor clearColor]];
		[planTitleTextView setFont:[UIFont systemFontOfSize:16]];
 		[panelView addSubview:planTitleTextView];
		
		braveWorldLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 100, 140, 30)];
        [braveWorldLabel setText:NSLocalizedString(@"豪言壮志", nil)];
        [braveWorldLabel setTextColor:[UIColor blackColor]];
        [braveWorldLabel setBackgroundColor:[UIColor clearColor]];
        [braveWorldLabel setTextAlignment:UITextAlignmentLeft];
        [braveWorldLabel setShadowOffset:CGSizeMake(0, 1)];
		[braveWorldLabel setShadowColor:[UIColor whiteColor]];
        [braveWorldLabel setFont:[UIFont systemFontOfSize:19]];
		[panelView addSubview:braveWorldLabel];
		
		
		braveWorldTextView = [[UITextView alloc] initWithFrame:CGRectMake(13, 120, 288 - 26, 150)];
		[braveWorldTextView setEditable:YES];
		[braveWorldTextView setDelegate:self];
        [braveWorldTextView setText:@""];
		[braveWorldTextView setBackgroundColor:[UIColor clearColor]];
		[braveWorldTextView setFont:[UIFont systemFontOfSize:16]];
 		[panelView addSubview:braveWorldTextView];
		
		
		planDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 150, 140, 30)];
        [planDayLabel setText:NSLocalizedString(@"计划天数", nil)];
        [planDayLabel setTextColor:[UIColor blackColor]];
        [planDayLabel setBackgroundColor:[UIColor clearColor]];
        [planDayLabel setTextAlignment:UITextAlignmentLeft];
        [planDayLabel setShadowOffset:CGSizeMake(0, 1)];
		[planDayLabel setShadowColor:[UIColor whiteColor]];
        [planDayLabel setFont:[UIFont systemFontOfSize:19]];
		[panelView addSubview:planDayLabel];
		
		planDayCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 180, 270, 30)];
        [planDayCountLabel setText:NSLocalizedString(@"10", nil)];
        [planDayCountLabel setTextColor:[UIColor grayColor]];
        [planDayCountLabel setBackgroundColor:[UIColor clearColor]];
        [planDayCountLabel setTextAlignment:UITextAlignmentLeft];
//		[planDayCountLabel setAutoresizesSubviews:YES];
		planDayCountLabel.adjustsFontSizeToFitWidth = YES;
        [planDayCountLabel setShadowOffset:CGSizeMake(0, 1)];
		[planDayCountLabel setShadowColor:[UIColor whiteColor]];
        [planDayCountLabel setFont:[UIFont systemFontOfSize:17]];
		[panelView addSubview:planDayCountLabel];
		
		
		planDayStepper = [[UIStepper alloc] init];
		planDayStepper.minimumValue = 5;
		planDayStepper.maximumValue = 22;
		planDayStepper.stepValue = 1;
		planDayStepper.value = 10;
		planDayStepper.center = CGPointMake(160, 165);
		[planDayStepper addTarget:self action:@selector(dayValueChanged:) forControlEvents:UIControlEventValueChanged];
		[panelView addSubview:planDayStepper];

		[contentTextView setHidden:YES];
		[contentImageView setHidden:YES];
		[clearImageButton setHidden:YES];
		
		[titleLabel setText:NSLocalizedString(@"制定新计划", nil)];
		[self dayValueChanged:planDayStepper];
		
	}
	return  self;
}

- (void)dayValueChanged:(UIStepper *)stepper
{
	int planDay = planDayStepper.value;
	NSString * temStr = @"";
	if(planDay<7)
	{
		temStr = NSLocalizedString(@"(计划有点短呀)", nil);
	}
	else if(planDay<14)
	{
		temStr = NSLocalizedString(@"(坚持就会有奇迹)", nil);
	}
	else if(planDay<=21)
	{
		temStr = NSLocalizedString(@"(习惯非常重要)", nil);
	}
	else
	{
		planDayStepper.value = 21;
		planDay = 21;
		temStr = NSLocalizedString(@"(慢慢来计划不要太长)", nil);
	}
	planDayCountLabel.text = [NSString stringWithFormat:@"天数：%d天%@",planDay,temStr];
	[self show:false];

}

- (NSString *) getSendMessage
{

	int planDay = planDayStepper.value;
	
	NSString * sendMessage = [NSString stringWithFormat:@"#HeroGo# ID:%d 计划名称:%@; 持续时间:%d天; 见证人:@未穿秋裤; 豪言壮志:%@ ",playid,planTitleTextView.text,planDay,braveWorldTextView.text];
	
	
	return sendMessage;
}

-(void) dealloc
{
	[planDayCountLabel release], planDayCountLabel = nil;
    [planTitleLabel release], planTitleLabel = nil;
	[planTitleTextView release], planTitleLabel = nil;
    [braveWorldTextView release], braveWorldTextView = nil;
    [planDayStepper release], planDayStepper = nil;	
    [planDayLabel release], planDayLabel = nil;
    [planDayCountLabel release], planDayCountLabel = nil;	
	[super dealloc];
}
@end
