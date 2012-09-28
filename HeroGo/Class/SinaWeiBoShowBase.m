	//
	//  WBViewController.m
	//  SinaWeiBoSDKDemo
	//
	//  Created by Wang Buping on 11-12-7.
	//  Copyright (c) 2011 Sina. All rights reserved.
	//

#import "SinaWeiBoShowBase.h"
#import "UIImageView+WebCache.h"
#import "ModelPlan.h"

	// TODO:
	// Define your AppKey & AppSecret here to eliminate the errors

#define kWBSDKDemoAppKey @"1493532311"
#define kWBSDKDemoAppSecret @"8b67af3aecad66b085545c64ae572f39"

#ifndef kWBSDKDemoAppKey
#error
#endif

#ifndef kWBSDKDemoAppSecret
#error
#endif

#define kWBAlertViewLogOutTag 100
#define kWBAlertViewLogInTag  101

@interface SinaWeiBoShowBase (Private)

- (void)dismissTimelineViewController;

- (void)presentTimelineViewControllerWithoutAnimation;
- (void) reflashIndex;
- (void) reflashTimeLine;
- (void)refreshTimeline:(NSString *)commendName;
- (void) writeCommand:(NSString *)commendName;
- (BOOL) checkIn;
-(void) initTimeLine;
@end

@implementation SinaWeiBoShowBase

@synthesize weiBoEngine;
@synthesize timeLineViewController;
@synthesize timeLineTableView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
		// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [weiBoEngine setDelegate:nil];
    [weiBoEngine release], weiBoEngine = nil;
    [writeParams release],writeParams = nil;
	[timeLintParams release],writeParams = nil;
    [timeLineViewController release], timeLineViewController = nil;
    [timeLine release], timeLine = nil;
    [indicatorView release], indicatorView = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	
    [super viewDidLoad];
		// Do any additional setup after loading the view, typically from a nib.
	
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.weiBoEngine = engine;
    [engine release];
	appkey = kWBSDKDemoAppKey;
	appSecret = kWBSDKDemoAppSecret;
	timeLintParams = [[NSMutableDictionary alloc]init];
	writeParams = [[NSMutableDictionary alloc]init];
	timeLine = [[NSMutableArray alloc] init];
	
	self.hidesBottomBarWhenPushed = FALSE;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    logInBtnOAuth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[logInBtnOAuth setFrame:CGRectMake(85, 160, 150, 40)];
	[logInBtnOAuth setTitle:NSLocalizedString(@"登录", @"") forState:UIControlStateNormal];
	[logInBtnOAuth addTarget:self action:@selector(onLogInOAuthButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:logInBtnOAuth];

	[self reflashIndex];

	
	
    [timeLineTableView setDelegate:self];
    [timeLineTableView setDataSource:self];
    [timeLineTableView setBackgroundColor:[UIColor whiteColor]];

	
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:indicatorView];
	
//    BOOL hasStatusBar = ![UIApplication sharedApplication].statusBarHidden;
//    int height = ((hasStatusBar) ? 20 : 0);
//    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
//    {
//        [timeLineTableView setFrame:CGRectMake(0, 0, 480, 320 - height - 32)];
//        [indicatorView setCenter:CGPointMake(240, 160)];
//    }
//    else
//    {
//        [timeLineTableView setFrame:CGRectMake(0, 0, 480, 480 - height - 44)];
//        [indicatorView setCenter:CGPointMake(160, 240)];
//    }
    
//    [self refreshTimeline];

	
		//刷新条
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setCenter:CGPointMake(160, 240)];
	
    [self.view addSubview:indicatorView];
    
    if ([self checkIn])
    {
		logInBtnOAuth.hidden = YES;
        [self performSelector:@selector(presentTimelineViewControllerWithoutAnimation) withObject:nil afterDelay:0.0];
    }
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
    [indicatorView release], indicatorView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
		// Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        [logInBtnOAuth setFrame:CGRectMake(165, 80, 150, 40)];
        [indicatorView setCenter:CGPointMake(240, 160)];
    }
    else
    {
        [logInBtnOAuth setFrame:CGRectMake(85, 160, 150, 40)];
        [indicatorView setCenter:CGPointMake(160, 240)];
    }
}

#pragma mark - User Actions

- (void)onLogInOAuthButtonPressed
{
    [weiBoEngine logIn];
}

- (void)onLogInXAuthButtonPressed
{
    WBLogInAlertView *logInView = [[WBLogInAlertView alloc] init];
    [logInView setDelegate:self];
    [logInView show];
    [logInView release];
}

- (void)onLogOutButtonPressed
{
    [weiBoEngine logOut];
}

- (void)dismissTimelineViewController
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)presentTimelineViewControllerWithoutAnimation
{
	[self initTimeLine];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kWBAlertViewLogInTag)
    {
//		[self presentTimelineViewController:YES];
    }
    else if (alertView.tag == kWBAlertViewLogOutTag)
    {
        [self dismissTimelineViewController];
    }
}

#pragma mark - WBLogInAlertViewDelegate Methods

- (void)logInAlertView:(WBLogInAlertView *)alertView logInWithUserID:(NSString *)userID password:(NSString *)password
{
    [weiBoEngine logInUsingUserID:userID password:password];
    
    [indicatorView startAnimating];
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    [indicatorView stopAnimating];
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    [indicatorView stopAnimating];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
    [alertView setTag:kWBAlertViewLogInTag];
	[alertView show];
	[alertView release];
	logInBtnOAuth.hidden = YES;
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    NSLog(@"didFailToLogInWithError: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登出成功！" 
													  delegate:self
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[self reflashIndex];
    [alertView setTag:kWBAlertViewLogOutTag];
	[alertView show];
	[alertView release];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"请重新登录！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

-(void) initTimeLine
{
//	[timeLintParams setObject:@"1" forKey:@"base_app"];
	[self refreshTimeline:@"statuses/friends_timeline.json"];
}




- (IBAction)onSendButtonPressed:(id)sender
{
    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret text:@"请输入要发表的内容" image:[UIImage imageNamed:@"bg.png"] ];
    [sendView setDelegate:self];
    
    [sendView show:YES];
    [sendView release];
}


- (IBAction)logOutButtonPressed:(id)sender
{
    [weiBoEngine logOut];
}

-(BOOL) checkIn
{
	return  ([weiBoEngine isLoggedIn] && ![weiBoEngine isAuthorizeExpired]);
}

-(void) reflashIndex
{
	if (![self checkIn])
	{
		logInBtnOAuth.hidden = NO;
	}
}

- (void)refreshTimeline:(NSString *)commendName
{
	
	[weiBoEngine loadRequestWithMethodName:commendName
								httpMethod:@"GET"
									params:timeLintParams
							  postDataType:kWBRequestPostDataTypeNone
						  httpHeaderFields:nil];

}

-(void) writeCommand:(NSString *)commendName
{
	[weiBoEngine loadRequestWithMethodName:commendName
								httpMethod:@"POST"
									params:writeParams
							  postDataType:kWBRequestPostDataTypeNormal
						  httpHeaderFields:nil];
		//避免重发操作信息
	[writeParams removeAllObjects];
}


#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
		//数据成功回调这个函数
    [indicatorView stopAnimating];
    NSLog(@"requestDidSucceedWithResult: %@", result);
    
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    [indicatorView stopAnimating];
    NSLog(@"requestDidFailWithError: %@", error);
//	NSDictionary *dict = (NSDictionary *)error;
//	
//	UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
//													   message:[dict objectForKey:@"error"] 
//													  delegate:nil
//											 cancelButtonTitle:@"确定" 
//											 otherButtonTitles:nil];
//	[alertView show];
//	[alertView release];

}


#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送成功！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeLine count];
}

-(ModelPlan *)fromatPlan:(NSString *)planWord
{
	ModelPlan * temPlan =[[ModelPlan alloc] init];
	NSArray *array = [planWord componentsSeparatedByString:@" "];
	if(array.count>5)
	{
		temPlan.name = [array objectAtIndex:1];
		temPlan.braveword = [array objectAtIndex:4];
		temPlan.text = planWord;
	}
	
	return temPlan;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineCell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimelineCell"] autorelease];
    }
    
    NSDictionary *detail = [timeLine objectAtIndex:indexPath.row];
    
	UIImageView * imageView = (UIImageView *)[cell viewWithTag:11];
	UILabel * titleLable = (UILabel *)[cell viewWithTag:12];
	UILabel * timeLable = (UILabel *)[cell viewWithTag:13];
	UILabel * content = (UILabel *)[cell viewWithTag:14];
	UILabel * braveworld = (UILabel *)[cell viewWithTag:15];
	[imageView setImageWithURL:[[detail objectForKey:@"user"] objectForKey:@"profile_image_url"]];
	[cell sizeToFit ];
	titleLable.text = [[detail objectForKey:@"user"] objectForKey:@"screen_name"];
	timeLable.text = [[detail objectForKey:@"user"] objectForKey:@"created_at"];
	ModelPlan *planModel = [self fromatPlan:[detail objectForKey:@"text"]];
	content.text = planModel.name;
	braveworld.text = planModel.text;
	return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return 100;
//}
- (IBAction)reflaseButtonPressed:(id)sender
{
	[self initTimeLine];
}
@end
