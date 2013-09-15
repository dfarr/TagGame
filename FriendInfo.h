//
//  FriendInfo.h
//  TagGame
//
//  Created by Farr, David on 9/14/13.
//  Copyright (c) 2013 Farr, David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendInfo : NSObject

@property (nonatomic, strong) id fbID;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) UIImage *displayPic;
@property (nonatomic, strong) NSString *displayPicURL;

@end
