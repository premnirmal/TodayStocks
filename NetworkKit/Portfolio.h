//
//  Portfolio.h
//  StocksWidget
//
//  Created by Prem on 5/8/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stock.h"

@interface Portfolio : NSObject

+(NSArray*) getTickers;

+(NSArray*) getStocks;

+(void) saveTickers:(NSArray*) tickers;
+(void) addTicker:(NSString*) ticker;
+(void) removeTicker:(NSString*) ticker;
+(void) saveStocks:(NSArray*) stocks;
+(void) removeStock:(Stock*) ticker;
+(NSString*) lastUpdated;
+(void) saveLastUpdated:(NSString*) lastUpdated;
+(BOOL) containsTicker:(NSString*) ticker;

@end
