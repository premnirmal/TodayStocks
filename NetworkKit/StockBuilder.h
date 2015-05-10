//
//  StockBuilder.h
//  App
//
//  Created by Prem on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockBuilder : NSObject

+ (NSArray *)stocksFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (NSArray *)tickersFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end
