//
//  ModelPlan.m
//  HeroGo
//
//  Created by 万斌 on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModelPlan.h"

@implementation ModelPlan

@synthesize name;
@synthesize daycount;
@synthesize braveword;
@synthesize begintime;
@synthesize text;
@synthesize planid;
@synthesize isfull;
@synthesize nowdaycount;
@synthesize friendArr;

-(id) initWithWorld:(NSString *)StringPtr
{
	self = [super init];
	if(self)
	{
		StringPtr = [StringPtr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		isfull = true;
		name = @"";
		daycount = 0;
		nowdaycount = 0;
		planid = 0;
		braveword = @"";
		begintime = @"";
		text = @"";
		friendArr = [[NSMutableArray alloc] init];
		
		NSArray *array = [StringPtr componentsSeparatedByString:@" "];
		NSString * idstr = [array objectAtIndex:1];
		NSArray *array2 = [idstr componentsSeparatedByString:@":"];
		planid =[[array2 objectAtIndex:1]intValue];
		
		idstr = [array objectAtIndex:2];
		array2 = [idstr componentsSeparatedByString:@":"];
		name = [array2 objectAtIndex:1];
		
		idstr = [array objectAtIndex:3];
		array2 = [idstr componentsSeparatedByString:@":"];
		daycount = [[array2 objectAtIndex:1] intValue];
		
		idstr = [array objectAtIndex:4];
		array2 = [idstr componentsSeparatedByString:@":"];
		braveword = [array2 objectAtIndex:1];
		
//		[friendArr removeAllObjects];
		for (int i=0; i<array.count; i++) {
			NSString *temstr =[[array objectAtIndex:i] substringToIndex:1];
			if ([temstr isEqualToString:@"@"]) {
				[friendArr addObject:[array objectAtIndex:i]];
			}
		}
		
	}
	return self;
}
-(void) dealloc
{
	[super dealloc];
	[friendArr release], friendArr = nil;
}

-(NSString *) contiueWord
{
	return  [NSString stringWithFormat:@"#HeroGo# ID:%d 计划名称:%@; 持续时间:%d天; 豪言壮志:%@ @未穿秋裤;",planid,name,daycount,braveword];
}
-(NSString *) planWord
{
	return  [NSString stringWithFormat:@"#HeroGo# ID:%d 计划名称:%@; 持续时间:%d天; 豪言壮志:%@ @未穿秋裤;",planid,name,daycount,braveword];
}
@end
