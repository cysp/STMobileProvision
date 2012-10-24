//
//  STCertificate.h
//  STMobileProvision
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012 Scott Talbot.
//

#import <Foundation/Foundation.h>


@interface STCertificate : NSObject

- (instancetype)initWithData:(NSData *)data;

@property (nonatomic,strong,readonly) NSString *subjectName;

@end
