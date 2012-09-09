//
//  STMobileProvision.m
//  STMobileProvision
//
//  Created by Scott Talbot on 12/09/12.
//  Copyright (c) 2012 Scott Talbot. All rights reserved.
//

#import "STMobileProvision.h"
#import "STCertificate.h"


@interface STMobileProvision ()
@property (nonatomic,strong,readonly) NSDictionary *entitlements;
@end


@implementation STMobileProvision {
	NSDictionary *_dict;
}

- (instancetype)initWithData:(NSData *)data {
	NSDictionary *profileDict = nil;

	do {
		CMSDecoderRef decoder = NULL;
		{
			OSStatus err = CMSDecoderCreate(&decoder);
			if (err != errSecSuccess) {
				break;
			}
		}
		if (!decoder) {
			break;
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
			Boolean contentIsEncrypted = NO;
			if (CMSDecoderIsContentEncrypted(decoder, &contentIsEncrypted) != errSecSuccess) {
				break;
			}
			if (CMSDecoderCopyContent(decoder, &contentData) != errSecSuccess) {
				break;
			}
			mobileprovisionContentData = CFBridgingRelease(contentData);
		} while (0);

		CFRelease(decoder), decoder = NULL;

		if (!mobileprovisionContentData) {
			break;
		}
		profileDict = [NSPropertyListSerialization propertyListWithData:mobileprovisionContentData options:NSPropertyListImmutable format:NULL error:NULL];
		if (![profileDict isKindOfClass:[NSDictionary class]]) {
			break;
		}
	} while (0);

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
