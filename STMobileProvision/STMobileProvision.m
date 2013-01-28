//
//  STMobileProvision.m
//  STMobileProvision
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2012 Scott Talbot.
//

#import "STMobileProvision.h"
#import "STCertificate.h"


static NSDictionary *STMobileProvisionDictionaryFromData(NSData *data);


@interface STMobileProvision ()
@property (nonatomic,strong,readonly) NSDictionary *entitlements;
@end

@implementation STMobileProvision {
	NSDictionary *_dict;
}

- (instancetype)initWithData:(NSData *)data {
	NSDictionary *profileDict = STMobileProvisionDictionaryFromData(data);
	if (!profileDict) {
		return nil;
	}

	if ((self = [super init])) {
		_dict = profileDict;
	}
	return self;
}

- (NSString *)name {
	return [_dict objectForKey:@"Name"];
}

- (NSDictionary *)entitlements {
	return [_dict objectForKey:@"Entitlements"];
}

- (NSString *)uuid {
	return [_dict objectForKey:@"UUID"];
}

- (NSString *)applicationIdentifier {
	return [self.entitlements objectForKey:@"application-identifier"];
}

- (BOOL)isDebuggingEnabled {
	return [[self.entitlements objectForKey:@"get-task-allow"] boolValue];
}

- (NSArray *)signingIdentities {
	NSArray *certDatas = [_dict objectForKey:@"DeveloperCertificates"];
	NSMutableArray *signingIdentities = [NSMutableArray arrayWithCapacity:[certDatas count]];

	for (NSData *certData in certDatas) {
		STCertificate *cert = [[STCertificate alloc] initWithData:certData];
		if (cert) {
			[signingIdentities addObject:cert];
		}
	}

	return signingIdentities;
}

@end


static NSDictionary *STMobileProvisionDictionaryFromData(NSData *data) {
	CMSDecoderRef decoder = NULL;
	{
		OSStatus err = CMSDecoderCreate(&decoder);
		if (err != errSecSuccess) {
			return nil;
		}
	}
	if (!decoder) {
		return nil;
	}

	NSData *mobileprovisionContentData = nil;
	do {
		if (CMSDecoderUpdateMessage(decoder, [data bytes], [data length]) != errSecSuccess) {
			break;
		}
		if (CMSDecoderFinalizeMessage(decoder) != errSecSuccess) {
			break;
		}

		CFDataRef contentData = NULL;
		if (CMSDecoderCopyContent(decoder, &contentData) != errSecSuccess) {
			break;
		}
		mobileprovisionContentData = (__bridge_transfer NSData *)contentData;
	} while (0);

	CFRelease(decoder), decoder = NULL;

	if (!mobileprovisionContentData) {
		return nil;
	}

	id profileObject = [NSPropertyListSerialization propertyListWithData:mobileprovisionContentData options:NSPropertyListImmutable format:NULL error:NULL];
	if ([profileObject isKindOfClass:[NSDictionary class]]) {
		return profileObject;
	}

	return nil;
}
