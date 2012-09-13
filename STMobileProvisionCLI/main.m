//
//  main.m
//  STMobileProvision
//
//  Created by Scott Talbot on 12/09/12.
//  Copyright (c) 2012 Scott Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <stdio.h>

#import "STMobileProvision.h"
#import "STCertificate.h"


static void usage() __attribute__((noreturn));

static NSString *NSStringByEscapingForShell(NSString *);


int main(int argc, const char *argv[]) {
	@autoreleasepool {
		if (argc != 2) {
			usage(argc, argv);
		}

		NSString *filename = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];

		NSError *error = nil;
		NSData * const data = [[NSData alloc] initWithContentsOfFile:filename options:NSDataReadingMappedIfSafe error:&error];
		if (!data) {
			fprintf(stderr, "error reading file: %s\n", [filename cStringUsingEncoding:NSUTF8StringEncoding]);
			return 1;
		}

		STMobileProvision * const mobileProvision = [[STMobileProvision alloc] initWithData:data];
		if (!mobileProvision) {
			fprintf(stderr, "error parsing file: %s\n", [filename cStringUsingEncoding:NSUTF8StringEncoding]);
			return 1;
		}

		printf("MOBILEPROVISION_NAME=%s\n", [NSStringByEscapingForShell(mobileProvision.name) cStringUsingEncoding:NSUTF8StringEncoding]);
		printf("MOBILEPROVISION_UUID=%s\n", [NSStringByEscapingForShell(mobileProvision.uuid) cStringUsingEncoding:NSUTF8StringEncoding]);

		NSArray * const signingIdentities = mobileProvision.signingIdentities;
		STCertificate * const signingIdentity = [signingIdentities count] ? [signingIdentities objectAtIndex:0] : nil;
		if (signingIdentity) {
			printf("MOBILEPROVISION_SIGNINGIDENTITY=%s\n", [NSStringByEscapingForShell(signingIdentity.subjectName) cStringUsingEncoding:NSUTF8StringEncoding]);
		}
	}
    return 0;
}

static void usage(int argc, const char *argv[]) {
	fprintf(stderr, "Usage: %s <.mobileprovision>\n", argv[0]);
	exit(1);
}

static NSString *NSStringByEscapingForShell(NSString *string) {
	return [NSString stringWithFormat:@"'%@'", [string stringByReplacingOccurrencesOfString:@"'" withString:@"'\\''" options:0 range:NSMakeRange(0, [string length])]];
}
