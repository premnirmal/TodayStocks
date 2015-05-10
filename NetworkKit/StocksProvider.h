//
//  StocksProvider.h
//  App
//
//  Created by Prem Nirmal on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StocksProviderDelegate.h"
#import "ApiCommunicatorDelegate.h"

@class ApiCommunicator;

@interface StocksProvider : NSObject<ApiCommunicatorDelegate>

@property (strong, nonatomic) ApiCommunicator *communicator;
@property(retain, nonatomic) NSMutableArray *delegates;

+ (id)sharedManager;

-(void) fetchStocks:(BOOL)force;

-(void)registerStocksProviderDelegate:(id<StocksProviderDelegate>)delegate;
-(void)unregisterStocksProviderDelegate:(id<StocksProviderDelegate>)delegate;


@end
