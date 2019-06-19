//
//  MCZoomAndQualityViewController.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 2/7/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSectionTitleCell.h"
#import "MCFieldWithTitleCell.h"
#import "MCSegmentedControlCell.h"
#import "MCButtonCell.h"
#import "MCZoomCell.h"
#import "NGADrawerViewController.h"


@protocol MCZoomAndQualityDelegate
- (void) zoomAndQualityCompletionHandlerWith:(NSNumber *) minZoom andMaxZoom:(NSNumber *) maxZoom;
- (void) cancelZoomAndQuality;
@end

@interface MCZoomAndQualityViewController : NGADrawerViewController <GPKGSButtonCellDelegate>
@property (weak, nonatomic) id<MCZoomAndQualityDelegate> zoomAndQualityDelegate;
@end