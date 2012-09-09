//
//  STCertificate.m
//  STMobileProvision
//
//  Created by Scott Talbot on 12/09/12.
//  Copyright (c) 2012 Scott Talbot. All rights reserved.
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
	CFRelease(_certificate), _certificate = NULL;
}


- (NSString *)subjectName {
	return CFBridgingRelease(SecCertificateCopySubjectSummary(_certificate));
	CFStringRef commonName = NULL;
	OSStatus err = SecCertificateCopyCommonName(_certificate, &commonName);
	if (err != errSecSuccess) {
		return nil;
	}

	return CFBridgingRelease(commonName);
}

@end
