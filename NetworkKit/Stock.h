//
//  Stock.h
//  App
//
//  Created by Prem on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stock : NSObject

+(NSNumberFormatter*) getSharedFormatter;

@property(strong, nonatomic) NSString *symbol;
@property(strong, nonatomic) NSString *Name;
@property(strong, nonatomic) NSString *ChangeinPercent;
@property(nonatomic) float Change;
@property(strong, nonatomic) NSString *StockExchange;
@property(nonatomic) float LastTradePriceOnly;
@end
