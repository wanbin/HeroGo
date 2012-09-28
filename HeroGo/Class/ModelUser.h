//
//  ModelUser.h
//  HeroGo
//
//  Created by 万斌 on 12-8-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModelUser : NSObject
@property (nonatomic, copy) NSString *scree_name;  
@property (nonatomic, copy) NSString *game;  
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) int user_id;  
@property (nonatomic, assign) bool follow_me;

@end



