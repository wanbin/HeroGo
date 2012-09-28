	//
	//  WBViewController.h
	//  SinaWeiBoSDKDemo
	//
	//  Created by Wang Buping on 11-12-7.
	//  Copyright (c) 2011 Sina. All rights reserved.
	//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "WBSendView.h"
#import "WBLogInAlertView.h"
#import "WBSDKTimelineViewController.h"
#import "WBSendViewPlay.h"
#import "WBSendView.h"
@interface SinaWeiBoShowBase : UIViewController <WBEngineDelegate, UIAlertViewDelegate,UITableViewDelegate, UITableViewDataSource,WBLogInAlertViewDelegate,WBSendViewDelegate> {
    WBEngine *weiBoEngine;
    
    WBSDKTimelineViewController *timeLineViewController;
    UIActivityIndicatorView *indicatorView;
	
	NSString * appkey;
	NSString * appSecret;
  
	UIButton *logInBtnOAuth;
	NSMutableArray *timeLine;
	NSMutableDictionary * timeLintParams ;
	NSMutableDictionary * writeParams ;
}

@property (nonatomic, retain) WBEngine *weiBoEngine;
@property (nonatomic, retain) WBSDKTimelineViewController *timeLineViewController;
@property (nonatomic, retain) IBOutlet UITableView* timeLineTableView;

- (IBAction)onSendButtonPressed:(id)sender;
- (IBAction)logOutButtonPressed:(id)sender;
- (IBAction)reflaseButtonPressed:(id)sender;
- (void)refreshTimeline:(NSString *)commendName;
- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result;
@end
