//
//  STCertificate.h
//  STMobileProvision
//
//  Created by Scott Talbot on 12/09/12.
//  Copyright (c) 2012 Scott Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STCertificate : NSObject

- (instancetype)initWithData:(NSData *)data;

@property (nonatomic,strong,readonly) NSString *subjectName;

@end
