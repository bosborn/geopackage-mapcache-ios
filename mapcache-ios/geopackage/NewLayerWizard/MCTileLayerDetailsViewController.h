//
//  GPKGSTileLayerDetailsViewController.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 1/9/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSectionTitleCell.h"
#import "MCFieldWithTitleCell.h"
#import "MCDesctiptionCell.h"
#import "MCSectionTitleCell.h"
#import "MCButtonCell.h"
#import "MCSegmentedControlCell.h"
#import "MCButtonCell.h"
#import "MCColorUtil.h"

@protocol MCTileLayerDetailsDelegate
- (void) tileLayerDetailsCompletionHandlerWithName:(NSString *)name URL:(NSString *) url andReferenceSystemCode:(int)referenceCode;
@end

@interface MCTileLayerDetailsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GPKGSSegmentedControlCellDelegate, GPKGSButtonCellDelegate>
@property (weak, nonatomic) id<MCTileLayerDetailsDelegate> delegate;
@end
