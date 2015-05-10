//
//  Portfolio.m
//  StocksWidget
//
//  Created by Prem on 5/8/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "Portfolio.h"
#import "Stock.h"

@implementation Portfolio

+(NSArray*) getTickers {
    NSUserDefaults * groupedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stocktickers"];
    NSArray *tickers = [groupedDefaults objectForKey:@"savedTickers"];
    
    if(!tickers) {
        tickers = @[@"AAPL", @"GOOG", @"TSLA", @"SPY",
                    @"SBUX", @"MSFT",
                    @"FB", @"TWTR", @"YHOO", @"BABA",
                    @"AMZN", @"NFLX", @"YELP", @"EBAY"
                    ];
        [self saveTickers:tickers];
    }
    
    return tickers;
}

+(NSArray*) getStocks {
    NSUserDefaults* groupedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stocktickers"];
    
    NSData *dataRepresentingStocks = [groupedDefaults objectForKey:@"savedStocks"];
    NSArray *stocks;
    if(dataRepresentingStocks) {
        stocks = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingStocks];
    } else {
        stocks = [[NSArray alloc] init];
    }
    return stocks;
}

+(NSString*) lastUpdated {
    NSUserDefaults* groupedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stocktickers"];
    NSString *lastUpdated = [groupedDefaults objectForKey:@"lastUpdated"];
    
    return lastUpdated;
}

+(void) saveTickers:(NSArray *)tickers {
    NSUserDefaults* groupedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stocktickers"];
    [groupedDefaults setObject:tickers forKey:@"savedTickers"];
    [groupedDefaults synchronize];
}

+(void) addTicker:(NSString *)ticker {
    NSMutableArray *tickerList = [[NSMutableArray alloc] initWithArray:[self getTickers]];
    if(![tickerList containsObject:ticker]) {
        [self saveTickers:[tickerList arrayByAddingObject:ticker]];
    }
}

+(void) removeTicker:(NSString *)ticker {
    NSMutableArray *tickerList = [[NSMutableArray alloc] initWithArray:[self getTickers]];
    [tickerList removeObject:ticker];
    [self saveTickers:tickerList];
}

+(BOOL) containsTicker:(NSString*) ticker {
    NSArray *tickers = [self getTickers];
    if(!tickers) {
        return NO;
    }
    return [tickers containsObject:ticker];
}

+(void) removeStock:(Stock *)stock {
    NSMutableArray *stockList = [[NSMutableArray alloc] initWithArray:[self getStocks]];
    [stockList removeObject:stock];
    [self saveStocks:stockList];
}

+(void) saveStocks:(NSArray *)stocks {
    NSUserDefaults* groupedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stocktickers"];
    [groupedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:stocks] forKey:@"savedStocks"];
    [groupedDefaults synchronize];
}

+(void) saveLastUpdated:(NSString *)lastUpdated {
    NSUserDefaults* groupedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.stocktickers"];
    [groupedDefaults setObject:lastUpdated forKey:@"lastUpdated"];
    [groupedDefaults synchronize];
}

@end
