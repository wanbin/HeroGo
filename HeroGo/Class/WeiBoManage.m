//
//  WeiBoManage.m
//  HeroGo
//
//  Created by 万斌 on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeiBoManage.h"

@implementation WeiBoManage
@synthesize sendLine;
-(id) init
{
	self = [super init];
	if(self)
	{
		sendLine = [[NSMutableArray alloc] init];
	}
	return self;
}


-(void) dealloc
{
	[sendLine release],sendLine=nil;
	[super dealloc];
}
@end
