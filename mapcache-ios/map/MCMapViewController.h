//
//  MCMapViewController.h
//  mapcache-ios
//
//  Created by Tyler Burgett on 8/27/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NGADrawerCoordinator.h"
#import "GPKGSDatabases.h"
#import "GPKGSDatabase.h"
#import "GPKGGeoPackageManager.h"
#import "GPKGGeoPackageFactory.h"
#import "GPKGSUtils.h"
#import "GPKGUtils.h"
#import "GPKGMapUtils.h"
#import "GPKGTileBoundingBoxUtils.h"
#import "GPKGTileTableScaling.h"
#import "GPKGMultipleFeatureIndexResults.h"
#import "GPKGFeatureShapes.h"
#import "SFPProjectionFactory.h"
#import "SFGeometryEnvelopeBuilder.h"
#import "MCTileHelper.h"
#import "MCFeatureHelper.h"
#import "GPKGBoundingBox.h"
#import "GPKGMapShapeTypes.h"


@protocol MCMapActionDelegate <NSObject>
- (void)showMapInfoDrawer;
@end


@interface MCMapViewController : UIViewController <MKMapViewDelegate, MCTileHelperDelegate, MCFeatureHelperDelegate, MCSettingsViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIButton *infoButton;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomIndicatorButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zoomIndicatorButtonWidth;
@property (nonatomic, strong) id<MCMapActionDelegate> mapActionDelegate;

- (int)updateInBackgroundWithZoom: (BOOL) zoom;
- (void)zoomToPointWithOffset:(CLLocationCoordinate2D) point;
- (CLLocationCoordinate2D) convertPointToCoordinate:(CGPoint) point;
- (void) toggleMapControls;
@end
