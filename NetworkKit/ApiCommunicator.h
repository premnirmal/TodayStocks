//
//  ApiCommunicator.h
//  App
//
//  Created by Prem Nirmal on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApiCommunicatorDelegate;

@interface ApiCommunicator : NSObject
@property (weak, nonatomic) id<ApiCommunicatorDelegate> delegate;
- (void)fetchStocks:(NSArray *) tickers;
@end
