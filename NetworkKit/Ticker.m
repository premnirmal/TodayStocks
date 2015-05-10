//
//  Ticker.m
//  StocksWidget
//
//  Created by Prem on 5/9/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "Ticker.h"

@interface Ticker() <NSCoding> {
    
}

@end
@implementation Ticker

@synthesize name,symbol;

+(NSNumberFormatter*) getSharedFormatter {
    static NSNumberFormatter *f = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        f = [[NSNumberFormatter alloc] init];
    });
    return f;
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.symbol forKey:@"symbol"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.symbol = [coder decodeObjectForKey:@"symbol"];
    }
    return self;
}

@end
