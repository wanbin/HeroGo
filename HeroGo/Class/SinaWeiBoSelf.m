//
//  SinaWeiBoSelf.m
//  HeroGo
//
//  Created by 万斌 on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SinaWeiBoSelf.h"
#import "ModelPlan.h"
@implementation SinaWeiBoSelf
@synthesize maxid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		maxid = 0;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	maxid = 0;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
-(void) initTimeLine
{
	[timeLintParams setObject:@"1" forKey:@"base_app"];
	[self refreshTimeline:@"statuses/user_timeline.json"];
}
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
	[indicatorView stopAnimating];
	[super engine:engine requestDidSucceedWithResult:result];
	if ([result isKindOfClass:[NSDictionary class]])
    {
		NSDictionary *dict = (NSDictionary *)result;
		[timeLine removeAllObjects];
		[timeLine addObjectsFromArray:[dict objectForKey:@"statuses"]];
	}
	NSString * str =@"";
	NSMutableArray * hasId = [[NSMutableArray alloc] init];
	for (int i =0; i<timeLine.count; i++) {
		NSDictionary *detail = [timeLine objectAtIndex:i];	
		str = [detail objectForKey:@"text"];
		ModelPlan * templan = [[ModelPlan alloc] initWithWorld:str];
		for (NSString *temstr in hasId) {
			if ([temstr isEqualToString:[NSString  stringWithFormat:@"%d",templan.planid]]) {
				[timeLine removeObjectAtIndex:i];
				continue;
			}
		}
		[hasId addObject:[NSString  stringWithFormat:@"%d",templan.planid]];
		maxid = MAX(maxid, templan.planid);
		[templan release];
	}
	[self.timeLineTableView reloadData];

}
-(ModelPlan *) stringToPlan:(NSString *)StringPtr
{
	ModelPlan * model = [[ModelPlan alloc] init];
	NSArray *array = [StringPtr componentsSeparatedByString:@" "];
	NSString * idstr = [array objectAtIndex:1];
	NSArray *array2 = [idstr componentsSeparatedByString:@":"];
	if([[array2 objectAtIndex:0] isEqualToString: @"ID"])
	{
		model.planid = (int)[array2 objectAtIndex:1];

	}
	return model;
}
-(void)finishPlan:(UIButton *) sender
{
	int planid = sender.tag - 100;
	for (int i = 0 ; i<timeLine.count; i++) {
		NSDictionary *detail = [timeLine objectAtIndex:i];
		NSString * str = [detail objectForKey:@"text"];
		ModelPlan * model = [self stringToPlan:str];
		if(model.planid == planid)
		{
			model.nowdaycount = model.nowdaycount+1;
			break;
		}
	}
	NSString *str= mo
//	NSString * sendMessage = [NSString stringWithFormat:@"#HeroGo# ID:%d 计划名称:%@; 持续时间:%d天; 见证人:@未穿秋裤; 豪言壮志:%@ ",playid,planTitleTextView.text,planDay,braveWorldTextView.text];
}

- (IBAction)onSendPlanButtonPressed:(id)sender
{
	if (maxid>0) {
		[indicatorView startAnimating];
		
		WBSendViewPlay *sendView = [[WBSendViewPlay alloc] initWithAppKey:appkey appSecret:appSecret text:@"开始" image:[UIImage imageNamed:@"bg.png"] planid:maxid+1];
		[sendView setDelegate:self];
		
		[sendView show:YES];
		[sendView release];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
