//
//  Ticker.h
//  StocksWidget
//
//  Created by Prem on 5/9/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticker : NSObject

+(NSNumberFormatter*) getSharedFormatter;

@property (retain, nonatomic) NSString *symbol;
@property (retain, nonatomic) NSString *name;

@end
