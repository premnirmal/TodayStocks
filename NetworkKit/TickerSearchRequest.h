//
//  TickerSearchRequest.h
//  StocksWidget
//
//  Created by Prem on 5/9/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticker.h"
#import "TickerSearchDelegate.h"

@interface TickerSearchRequest : NSObject

+(void) searchForTicker:(NSString*) query :(id<TickerSearchDelegate>) delegate;

@end
