//
//  TickerSearchRequest.m
//  StocksWidget
//
//  Created by Prem on 5/9/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "TickerSearchRequest.h"
#import "Ticker.h"
#import "StockBuilder.h"

@implementation TickerSearchRequest

+(void) searchForTicker:(NSString*) query :(id<TickerSearchDelegate>) delegate {
    
    NSString *urlAsString = [NSString stringWithFormat:@"http://d.yimg.com/autoc.finance.yahoo.com/autoc?callback=YAHOO.Finance.SymbolSuggest.ssCallback&query=%@", query];
    NSString* urlTextEscaped = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:urlTextEscaped];
    NSLog(@"%@", urlAsString);
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSArray* tickers;
        if (error) {
            tickers = [[NSArray alloc]init];
            if(delegate) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate retrievedTickersFromSearch:tickers :error];
                });
            }
        } else {
            tickers = [StockBuilder tickersFromJSON:data error:&error];
            if(delegate) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate retrievedTickersFromSearch:tickers :error];
                });
            }
        }
    }];
}

@end
