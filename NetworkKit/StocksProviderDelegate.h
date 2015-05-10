//
//  StocksProviderDelegate.h
//  App
//
//  Created by Prem Nirmal on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef App_StocksProviderDelegate_h
#define App_StocksProviderDelegate_h

@protocol StocksProviderDelegate
- (void)didReceiveStocks:(NSArray *)groups;
- (void)fetchingStocksFailedWithError:(NSError *)error;
@end

#endif
