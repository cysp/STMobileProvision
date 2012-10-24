//
//  STCertificate.m
//  STMobileProvision
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012 Scott Talbot.
//

#import "STCertificate.h"

#import <Security/Security.h>


@implementation STCertificate {
	SecCertificateRef _certificate;
}

- (instancetype)initWithData:(NSData *)data {
	SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(data));

	if (!certificate) {
		return nil;
	}

	if ((self = [super init])) {
		_certificate = certificate;
	}
	return self;
}

- (void)dealloc {
	if (_certificate) {
		CFRelease(_certificate), _certificate = NULL;
	}
}


- (NSString *)subjectName {
	return CFBridgingRelease(SecCertificateCopySubjectSummary(_certificate));
}

@end
