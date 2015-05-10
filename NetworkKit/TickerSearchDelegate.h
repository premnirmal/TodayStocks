//
//  TickerSearchDelegate.h
//  StocksWidget
//
//  Created by Prem on 5/9/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TickerSearchDelegate
- (void)retrievedTickersFromSearch:(NSArray *)tickers :(NSError*)error;
@end
