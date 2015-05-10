//
//  PortfolioCell.h
//  StocksWidget
//
//  Created by Prem on 5/8/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaddedLabel.h"

@interface PortfolioCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet PaddedLabel *changeLabel;

@end
