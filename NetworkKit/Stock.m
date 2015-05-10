//
//  Stock.m
//  App
//
//  Created by Prem on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "Stock.h"
#import <Foundation/Foundation.h>

@interface Stock() <NSCoding> {
    
}


@end

@implementation Stock

+(NSNumberFormatter*) getSharedFormatter {
    static NSNumberFormatter *f = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        f = [[NSNumberFormatter alloc] init];
    });
    return f;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToStock:other];
}

- (BOOL)isEqualToStock:(Stock *)stock {
    if (self == stock) {
        return YES;
    }
    if (![(id)[self symbol] isEqual:[stock symbol]]) {
        return NO;
    } else if (![[self Name] isEqual:[stock Name]]) {
        return NO;
    }
    return YES;
}


- (NSComparisonResult)compare:(Stock *)otherObject {
    NSNumberFormatter *formatter = [Stock getSharedFormatter];
    NSNumber *myChange = [formatter numberFromString:[[self.ChangeinPercent stringByReplacingOccurrencesOfString:@"%" withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""]];
    NSNumber *theirChange = [formatter numberFromString:[[otherObject.ChangeinPercent stringByReplacingOccurrencesOfString:@"%" withString:@""] stringByReplacingOccurrencesOfString:@"+" withString:@""]];
    return [theirChange compare:myChange];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.Name forKey:@"Name"];
    [coder encodeObject:self.symbol forKey:@"symbol"];
    [coder encodeFloat:self.Change forKey:@"Change"];
    [coder encodeObject:self.ChangeinPercent forKey:@"ChangeinPercent"];
    [coder encodeFloat:self.LastTradePriceOnly forKey:@"LastTradePriceOnly"];
    [coder encodeObject:self.StockExchange forKey:@"StockExchange"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil) {
        self.Name = [coder decodeObjectForKey:@"Name"];
        self.symbol = [coder decodeObjectForKey:@"symbol"];
        self.ChangeinPercent = [coder decodeObjectForKey:@"ChangeinPercent"];
        self.StockExchange = [coder decodeObjectForKey:@"StockExchange"];
        self.Change = [coder decodeFloatForKey:@"Change"];
        self.LastTradePriceOnly = [coder decodeFloatForKey:@"LastTradePriceOnly"];
    }
    return self;
}

@end
