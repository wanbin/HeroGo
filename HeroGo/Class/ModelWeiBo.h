//
//  ModelWeiBo.h
//  HeroGo
//
//  Created by 万斌 on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelWeiBo : NSObject
@property (nonatomic, copy) NSString *text;  
@property (nonatomic, copy) NSString *source;  
@property (nonatomic, copy) NSString *idstr;
@property (nonatomic, copy) NSString *mid;  
@property (nonatomic, assign) bool favorited;
@end
