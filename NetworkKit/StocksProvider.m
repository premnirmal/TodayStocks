//
//  StocksProvider.m
//  App
//
//  Created by Prem Nirmal on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "StocksProvider.h"
#import "StockBuilder.h"
#import "ApiCommunicator.h"
#import "Market.h"
#import "Portfolio.h"

@implementation StocksProvider

@synthesize delegates;

+(id) sharedManager {
    static StocksProvider *sharedDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDelegate = [[self alloc] init];
    });
    return sharedDelegate;
}

-(id) init {
    self = [super init];
    self.delegates = [[NSMutableArray alloc] init];
    self.communicator = [[ApiCommunicator alloc] init];
    self.communicator.delegate = self;
    return self;
}

-(void) fetchStocks:(BOOL)force {
    if([Market isOpen] || force) {
        [self.communicator fetchStocks:[Portfolio getTickers]];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"com.github.premnirmal.stockticker.StocksWidget." code:42 userInfo:@{NSLocalizedDescriptionKey: @"Market closed"}];
        for(id<StocksProviderDelegate> delegate in self.delegates) {
            [delegate fetchingStocksFailedWithError:error];
        }
    }
}

-(void) registerStocksProviderDelegate:(id<StocksProviderDelegate>)delegate {
    BOOL contains = [self.delegates containsObject:delegate];
    if(!contains) {
        [self.delegates addObject:delegate];
    }
}

-(void) unregisterStocksProviderDelegate:(id<StocksProviderDelegate>)delegate {
    [self.delegates removeObject:delegate];
}

#pragma mark - ApiCommunicatorDelegate

-(void) retrievedStocksJSON:(NSData *)objectNotation {
    NSError *error = nil;
    NSArray *groups = [StockBuilder stocksFromJSON:objectNotation error: &error];
    NSArray *sortedStocks = [groups sortedArrayUsingSelector:@selector(compare:)];
    if (error != nil) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            for(id<StocksProviderDelegate> delegate in self.delegates) {
                [delegate fetchingStocksFailedWithError:error];
            }
        });
        
    } else {
        [Portfolio saveStocks:sortedStocks];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm"];
        NSDate *now = [[NSDate alloc] init];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated: %@",[timeFormat stringFromDate:now]];
        [Portfolio saveLastUpdated:lastUpdated];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            for(id<StocksProviderDelegate> delegate in self.delegates) {
                [delegate didReceiveStocks:sortedStocks];
            }
        });
    }
}

-(void) fetchingStocksFailedWithError:(NSError *)error {
    dispatch_sync(dispatch_get_main_queue(), ^{
        for(id<StocksProviderDelegate> delegate in self.delegates) {
            [delegate fetchingStocksFailedWithError:error];
        }
    });
}

@end
