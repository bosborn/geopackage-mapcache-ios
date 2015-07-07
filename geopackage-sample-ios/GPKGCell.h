//
//  GPKGCell.h
//  geopackage-sample-ios
//
//  Created by Brian Osborn on 7/6/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPKGCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *database;
@property (weak, nonatomic) IBOutlet UIImageView *expandImage;

@end
