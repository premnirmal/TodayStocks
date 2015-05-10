//
//  StockBuilder.m
//  App
//
//  Created by Prem on 4/23/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "StockBuilder.h"
#import "Stock.h"
#import "Ticker.h"

@implementation StockBuilder

+(NSArray*) stocksFromJSON:(NSData *)objectNotation error:(NSError *__autoreleasing *)error {
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    NSArray *results = [[[parsedObject valueForKey:@"query"]valueForKey:@"results"]valueForKey:@"quote"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    if(results != nil && results.count > 0) {
        for (NSDictionary *groupDic in results) {
            Stock *group = [[Stock alloc] init];
            @try {
                for (NSString *key in groupDic) {
                    if ([group respondsToSelector:NSSelectorFromString(key)]) {
                        NSObject * valueForKey = [groupDic valueForKey:key];
                        if(valueForKey) {
                            [group setValue: valueForKey forKey:key];
                        }
                    }
                }
            } @catch (NSException *exception) {
                NSLog(@"%@", groupDic);                
                continue;
            }
            
            [groups addObject:group];
        }
    }
    
    return groups;
}

+(NSArray*) tickersFromJSON:(NSData *)objectNotation error:(NSError *__autoreleasing *)error {
    NSString *inputString = [[NSString alloc] initWithData:objectNotation encoding:NSUTF8StringEncoding];
    NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"()"];
    NSArray *splitString = [inputString componentsSeparatedByCharactersInSet:delimiters];
    
    NSString *result = [splitString objectAtIndex:1];
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    NSArray *results = [[parsedObject valueForKey:@"ResultSet"]valueForKey:@"Result"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    if(results != nil && results.count > 0) {
        for (NSDictionary *groupDic in results) {
            Ticker *group = [[Ticker alloc] init];
            for (NSString *key in groupDic) {
                if ([group respondsToSelector:NSSelectorFromString(key)]) {
                    NSObject * valueForKey = [groupDic valueForKey:key];
                    if(valueForKey) {
                        [group setValue: valueForKey forKey:key];
                    }
                }
            }
            
            [groups addObject:group];
        }
    }
    
    return groups;
}

@end
