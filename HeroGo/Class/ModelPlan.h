//
//  ModelPlan.h
//  HeroGo
//
//  Created by 万斌 on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelPlan : NSObject
@property (nonatomic, copy) NSString *name;  
@property (nonatomic, copy) NSString *begintime;  
@property (nonatomic, copy) NSString *braveword;
@property (nonatomic, copy) NSString *text;  
@property (nonatomic, copy) NSMutableArray *friendArr;  
@property (nonatomic, assign) int planid;
@property (nonatomic, assign) int daycount;
@property (nonatomic, assign) int nowdaycount;
@property (nonatomic, assign) bool isfull;
-(id) initWithWorld:(NSString *)StringPtr;
-(NSString *) contiueWord;
-(NSString *) planWord;
@end
