//
//  Cell.m
//  StocksWidget
//
//  Created by Prem on 5/3/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize nameLabel;
@synthesize priceLabel;
@synthesize changeLabel;
@synthesize changePercentLabel;

- (void)awakeFromNib {
    UILabel *one = nameLabel;
    UILabel *two = priceLabel;
    UILabel *three = changeLabel;
    UILabel *four = changePercentLabel;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(one,two,three,four);
    CGFloat cellWidth = [self contentView].frame.size.width;
    CGFloat itemWidth = (cellWidth / 4.0) - 4.0;
    NSNumber *width = [NSNumber numberWithFloat:itemWidth];
    NSDictionary *metrics = @{@"w":width};
    // Horizontal layout - note the options for aligning the top and bottom of all views
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-2.0-[one(w)]-2.0-[two(w)]-2.0-[three(w)]-2.0-[four(w)]-2.0-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

@end
