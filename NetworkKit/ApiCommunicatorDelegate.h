//
//  ApiCommunicatorDelegate.h
//  App
//
//  Created by Prem Nirmal on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApiCommunicatorDelegate
- (void)retrievedStocksJSON:(NSData *)objectNotation;
- (void)fetchingStocksFailedWithError:(NSError *)error;
@end
