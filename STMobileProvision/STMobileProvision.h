//
//  STMobileProvision.h
//  STMobileProvision
//
//  Created by Scott Talbot on 12/09/12.
//  Copyright (c) 2012 Scott Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STMobileProvision : NSObject

- (instancetype)initWithData:(NSData *)data;

@property (nonatomic,strong,readonly) NSString *name;
@property (nonatomic,strong,readonly) NSString *uuid;
@property (nonatomic,strong,readonly) NSString *applicationIdentifier;
@property (nonatomic,assign,readonly,getter=isDebuggingEnabled) BOOL debuggingEnabled;

@property (nonatomic,strong,readonly) NSArray *signingIdentities;

@end
