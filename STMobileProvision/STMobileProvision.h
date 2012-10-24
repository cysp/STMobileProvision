//
//  STMobileProvision.h
//  STMobileProvision
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012 Scott Talbot.
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
