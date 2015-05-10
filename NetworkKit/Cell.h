//
//  Cell.h
//  StocksWidget
//
//  Created by Prem on 5/3/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePercentLabel;

@end
