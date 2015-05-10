//
//  ApiCommunicator.m
//  App
//
//  Created by Prem Nirmal on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "ApiCommunicator.h"
#import "ApiCommunicatorDelegate.h"

@implementation ApiCommunicator

-(void) fetchStocks:(NSArray *)tickers {
    NSUInteger count = [tickers count];
    NSMutableString *builder = [[NSMutableString alloc]init];
    for (NSUInteger i = 0; i < count; i++) {
        NSString *ticker = [tickers objectAtIndex:i];
        [builder appendString:[ticker stringByReplacingOccurrencesOfString:@"^" withString:@""]];
        [builder appendString:@","];
    }
    NSString *commaSeparatedTickers = [builder substringToIndex: (builder.length - 1)];
    NSString *urlAsString = [NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?env=store://datatables.org/alltableswithkeys&format=json&q=select * from yahoo.finance.quotes where symbol in (\"%@\")", commaSeparatedTickers];
    NSString* urlTextEscaped = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:urlTextEscaped];
    NSLog(@"%@", urlAsString);
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [self.delegate fetchingStocksFailedWithError:error];
        } else {
            [self.delegate retrievedStocksJSON:data];
        }
    }];
}

@end
