//
//  TodayViewController.h
//  Widget
//
//  Created by Prem Nirmal on 4/22/15.
//  Copyright (c) 2015 Prem Nirmal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StocksProvider.h"

@interface TodayViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, NCWidgetProviding, StocksProviderDelegate>

@property (retain, nonatomic) NSArray *stocks;
@property(retain, nonatomic) StocksProvider *manager;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property(retain,nonatomic) UIColor *positiveColor;
@property(retain,nonatomic) UIColor *negativeColor;

-(void) updateView;

@end
