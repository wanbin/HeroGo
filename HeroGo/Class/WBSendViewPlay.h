//
//  WBSendViewPlay.h
//  HeroGo
//
//  Created by 万斌 on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WBSendView.h"


@interface WBSendViewPlay : WBSendView
{
	UILabel     *planTitleLabel;
	UILabel     *planDayLabel;
	UILabel     *planDayCountLabel;
	UITextView  *planTitleTextView;
	UILabel     *braveWorldLabel;//豪言
	UITextView  *braveWorldTextView;
	UIStepper   *planDayStepper;
	int playid;
}
- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret text:(NSString *)text image:(UIImage *)image planid:(int)id;
@end
