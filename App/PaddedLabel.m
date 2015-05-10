//
//  PaddedLabel.m
//  StocksWidget
//
//  Created by Prem on 5/8/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "PaddedLabel.h"

@implementation PaddedLabel

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void)setCornerRadius:(int)radius {
    [self.layer setCornerRadius:3];
    self.clipsToBounds=YES;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
