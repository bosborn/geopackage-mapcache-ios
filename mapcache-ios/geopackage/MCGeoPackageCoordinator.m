//
//  GPKGSCoordinator.m
//  mapcache-ios
//
//  Created by Tyler Burgett on 10/31/17.
//  Copyright © 2017 NGA. All rights reserved.
//

#import "MCGeoPackageCoordinator.h"


@interface MCGeoPackageCoordinator()
@property (nonatomic, strong) MCGeopackageSingleViewController *geoPackageViewController;
@property (nonatomic, strong) id<MCGeoPackageCoordinatorDelegate> geoPackageCoordinatorDelegate;
@property (nonatomic, strong) id<NGADrawerViewDelegate> drawerDelegate;
@property (nonatomic, strong) id<MCMapDelegate> mapDelegate;
@property (nonatomic, strong) GPKGGeoPackageManager *manager;
@property (nonatomic, strong) id<NGADrawerViewDelegate> drawerViewDelegate;
@property (nonatomic, strong) MCFeatureLayerDetailsViewController *featureDetailsController;
@property (nonatomic, strong) MCTileLayerDetailsViewController *tileDetailsController;
@property (nonatomic, strong) MCBoundingBoxViewController *boundingBoxViewController;
@property (nonatomic, strong) MCBoundingBoxDetailsViewController *boundingBoxDetailsViewController;
@property (nonatomic, strong) MCZoomAndQualityViewController *zoomAndQualityViewController;
@property (nonatomic, strong) MCManualBoundingBoxViewController *manualBoundingBoxViewController;
@property (nonatomic, strong) GPKGSDatabases *active;
@property (nonatomic, strong) GPKGSDatabase *database;
@property (nonatomic, strong) GPKGSCreateTilesData * tileData;
@property (nonatomic, strong) NSMutableArray *childCoordinators;
@end


@implementation MCGeoPackageCoordinator

- (instancetype) initWithDelegate:(id<MCGeoPackageCoordinatorDelegate>)geoPackageCoordinatorDelegate andDrawerDelegate:(id<NGADrawerViewDelegate>) drawerDelegate andMapDelegate:(id<MCMapDelegate>) mapDelegate andDatabase:(GPKGSDatabase *) database {
    self = [super init];
    
    _childCoordinators = [[NSMutableArray alloc] init];
    _manager = [GPKGGeoPackageFactory getManager];
    _geoPackageCoordinatorDelegate = geoPackageCoordinatorDelegate;
    _drawerDelegate = drawerDelegate;
    _mapDelegate = mapDelegate;
    _database = database;
    _active = [GPKGSDatabases getInstance];
    
    return self;
}


- (void) start {
    _geoPackageViewController = [[MCGeopackageSingleViewController alloc] initAsFullView:YES];
    
    _geoPackageViewController.database = _database;
    _geoPackageViewController.delegate = self;
    _geoPackageViewController.drawerViewDelegate = _drawerDelegate;
    [_drawerDelegate pushDrawer:_geoPackageViewController];
    
    //[_navigationController pushViewController:_geoPackageViewController animated:YES]; // TODO replace with drawer
}


#pragma mark - GeoPackage View delegate methods
- (void) newLayer {
    NSLog(@"Coordinator handling new layer");
    
    // Future release will bring feature and tile layers, for now starting with just the tiles.
//    MCCreateLayerViewController *createLayerViewControler = [[MCCreateLayerViewController alloc] initWithNibName:@"MCCreateLayerView" bundle:nil];
//    createLayerViewControler.delegate = self;
//    createLayerViewControler.drawerViewDelegate = _drawerDelegate;
//    [createLayerViewControler.drawerViewDelegate pushDrawer:createLayerViewControler];
    
    NSLog(@"Adding new tile layer");
    _tileData = [[GPKGSCreateTilesData alloc] init];
    _tileDetailsController = [[MCTileLayerDetailsViewController alloc] initAsFullView:YES];
    _tileDetailsController.delegate = self;
    _tileDetailsController.drawerViewDelegate = _drawerDelegate;
    [_tileDetailsController.drawerViewDelegate pushDrawer:_tileDetailsController];
}


- (void) updateDatabase {
    GPKGGeoPackage *geoPackage = nil;
    GPKGSDatabase *updatedDatabase = nil;
    
    @try {
        geoPackage = [_manager open:_database.name];
        
        GPKGContentsDao *contentsDao = [geoPackage getContentsDao];
        NSMutableArray *tables = [[NSMutableArray alloc] init];
        
        updatedDatabase = [[GPKGSDatabase alloc] initWithName:_database.name andExpanded:false];
        
        // Handle the Feature Layers
        for (NSString *tableName in [geoPackage getFeatureTables]) {
            GPKGFeatureDao *featureDao = [geoPackage getFeatureDaoWithTableName:tableName];
            int count = [featureDao count];
            
            GPKGContents *contents = (GPKGContents *)[contentsDao queryForIdObject:tableName];
            GPKGGeometryColumns *geometryColumns = [contentsDao getGeometryColumns:contents];
            enum SFGeometryType geometryType = [SFGeometryTypes fromName:geometryColumns.geometryTypeName];
            
            GPKGSFeatureTable *table = [[GPKGSFeatureTable alloc] initWithDatabase:_database.name andName:tableName andGeometryType:geometryType andCount:count];
            // there was some bit about setting the table as active, but I think that was for the OG manager
            
            [tables addObject:table];
            [updatedDatabase addFeature:table];
            // there was a bit about expanding the cells to add another to the manager for the new feaure layer, but that might get handled in this case by just calling initCells
        }
        
        // Handle the tile layers
        for (NSString *tableName in [geoPackage getTileTables]) {
            GPKGTileDao *tileDao = [geoPackage getTileDaoWithTableName:tableName];
            int count = [tileDao count];
            
            GPKGSTileTable *table = [[GPKGSTileTable alloc] initWithDatabase:_database.name andName:tableName andCount:count];
            // skipping active setting, that will be handled on the new map
            [tables addObject:table];
            [updatedDatabase addTile:table];
        }
        
        // TODO: Figure out what to do about overlays
    }
    @finally {
        if (geoPackage == nil) {
            @try {
                [_manager delete:_database.name];
            }
            @catch (NSException *exception) {
            }
        } else {
            if (updatedDatabase != nil) {
                _database = updatedDatabase;
                _geoPackageViewController.database = _database;
                [_geoPackageViewController update];
            }
            [geoPackage close];
        }
    }
}


- (void) copyGeoPackage {
    //[_navigationController popViewControllerAnimated:YES]; // TODO replace with drawer
    [_geoPackageCoordinatorDelegate geoPackageCoordinatorCompletionHandlerForDatabase:_database.name withDelete:NO];
}


- (void) deleteGeoPackage {
    NSLog(@"Coordinator handling delete");
    //[_navigationController popViewControllerAnimated:YES]; // TODO replace with drawer
    [_geoPackageCoordinatorDelegate geoPackageCoordinatorCompletionHandlerForDatabase:_database.name withDelete:YES];
}


- (void) callCompletionHandler {
    NSLog(@"Close pressed");
    [_geoPackageCoordinatorDelegate geoPackageCoordinatorCompletionHandlerForDatabase:_database.name withDelete:NO];
}


- (void) deleteLayer:(GPKGSTable *) table {
    GPKGGeoPackage *geoPackage = nil;
    
    @try {
        geoPackage = [_manager open:_database.name];
        [geoPackage deleteUserTable:table.name];
        [_active removeTable:table];
        [_geoPackageViewController removeLayerNamed:table.name];
        [_mapDelegate updateMapLayers];
    }
    @catch (NSException *exception) {
        [GPKGSUtils showMessageWithDelegate:self
                                   andTitle:[NSString stringWithFormat:@"%@ %@ - %@ Table", [GPKGSProperties getValueOfProperty:GPKGS_PROP_GEOPACKAGE_TABLE_DELETE_LABEL], _database.name, table.name]
                                 andMessage:[NSString stringWithFormat:@"%@", [exception description]]];
    }
    @finally {
        [geoPackage close];
    }
}


- (void) toggleLayer:(GPKGSTable *) table; {
    if ([_database exists:table]) {
        
        if ([_active isActive:_database]) {
            GPKGSDatabase *activeDatabase = [_active getDatabaseWithName:_database.name];
            if ([activeDatabase existsWithTable:table.name ofType:table.getType]) {
                [_active removeTable:table];
            } else {
                [_active addTable:table];
            }
        } else {
            [_active addTable:table];
        }
        
        [_mapDelegate updateMapLayers];
    }
}


- (void) showLayerDetails:(GPKGUserDao *) layerDao {
    NSLog(@"In showLayerDetails with %@", layerDao.tableName);
    // TODO: Create a layer details view and show it
    
    //MCLayerCoordinator *layerCoordinator = [[MCLayerCoordinator alloc] initWithNavigationController:_navigationController andDatabase:_database andDao:layerDao]; // TODO replace with drawer
    //[_childCoordinators addObject:layerCoordinator];
    //[layerCoordinator start];
}


#pragma mark - CreateLayerViewController delegate methods
- (void) newFeatureLayer {
    NSLog(@"Adding new feature layer");
    _featureDetailsController = [[MCFeatureLayerDetailsViewController alloc] init];
    _featureDetailsController.database = _database;
    _featureDetailsController.delegate = self;
    //[_navigationController pushViewController:_featureDetailsController animated:YES]; // TODO replace with drawer
}


// Temporarily moving this to new layer since initially they can only make tile layers.
- (void) newTileLayer {
    NSLog(@"Adding new tile layer");
    _tileData = [[GPKGSCreateTilesData alloc] init];
    _tileDetailsController = [[MCTileLayerDetailsViewController alloc] init];
    _tileDetailsController.delegate = self;
    _tileDetailsController.drawerViewDelegate = _drawerDelegate;
    // [_navigationController pushViewController:_tileDetailsController animated:YES]; // TODO replace with drawer
}


#pragma mark - GPKGSFeatureLayerCreationDelegate
- (void) createFeatueLayerIn:(NSString *)database with:(GPKGGeometryColumns *)geometryColumns andBoundingBox:(GPKGBoundingBox *)boundingBox andSrsId:(NSNumber *) srsId {
    
    GPKGGeoPackage * geoPackage;
    @try {
        geoPackage = [_manager open:database];
        [geoPackage createFeatureTableWithGeometryColumns:geometryColumns andBoundingBox:boundingBox andSrsId:srsId];
    }
    @catch (NSException *e) {
        // TODO handle this
        NSLog(@"There was a problem creating the layer, %@", e.reason);
    }
    @finally {
        [geoPackage close];
        //[_navigationController popToViewController:_geoPackageViewController animated:YES]; // TODO replace with drawer
        [self updateDatabase];
    }
    
    // TODO handle dismissing the view controllers or displaying an error message
}


#pragma mark - MCTileLayerDetailsDelegate
- (void) tileLayerDetailsCompletionHandlerWithName:(NSString *)name URL:(NSString *) url andReferenceSystemCode:(int)referenceCode {
    _tileData.name = name;
    _tileData.loadTiles.url = url;
    _tileData.loadTiles.epsg = referenceCode;
    
    //_boundingBoxViewController = [[MCBoundingBoxViewController alloc] init];
    //_boundingBoxViewController.delegate = self;
    //[_navigationController pushViewController:_boundingBoxViewController animated:YES];
    
    _boundingBoxDetailsViewController = [[MCBoundingBoxDetailsViewController alloc] init];
    _boundingBoxDetailsViewController.drawerViewDelegate = _drawerDelegate;
    [_drawerDelegate popDrawer];
    _boundingBoxDetailsViewController.boundingBoxDetailsDelegate = self;
    [_boundingBoxDetailsViewController.drawerViewDelegate pushDrawer:_boundingBoxDetailsViewController];
}


#pragma mark- MCBoundingBoxDelegate
- (void) boundingBoxCompletionHandler:(GPKGBoundingBox *)boundingBox  {
    _tileData.loadTiles.generateTiles.boundingBox = boundingBox;
    
    _zoomAndQualityViewController = [[MCZoomAndQualityViewController alloc] init];
    _zoomAndQualityViewController.zoomAndQualityDelegate = self;
    //[_navigationController pushViewController:_zoomAndQualityViewController animated:YES]; // TODO replace with drawer
}

#pragma mark MCBoundingBoxDetailsDelegate methods
// TODO clean up these delegates, some duplicates in switching to the drawers from the navigation controller.
- (void) boundingBoxDetailsCompletionHandler:(GPKGBoundingBox *) boundingBox {
    _tileData.loadTiles.generateTiles.boundingBox = boundingBox;
    
    _zoomAndQualityViewController = [[MCZoomAndQualityViewController alloc] initAsFullView:YES];
    _zoomAndQualityViewController.zoomAndQualityDelegate = self;
    _zoomAndQualityViewController.drawerViewDelegate = _drawerDelegate;
    [_drawerDelegate popDrawer];
    [_zoomAndQualityViewController.drawerViewDelegate pushDrawer:_zoomAndQualityViewController];
}


- (void) cancelBoundingBox {
    [self.mapDelegate updateMapLayers];
}


- (void) showManualBoundingBoxViewWithMinLat:(double)minLat andMaxLat:(double)maxLat andMinLon:(double)minLon andMaxLon:(double) maxLon {
    _manualBoundingBoxViewController = [[MCManualBoundingBoxViewController alloc] initWithLowerLeftLat:minLat andLowerLeftLon:minLon andUpperRightLat:maxLat andUpperRightLon:maxLon];
    _manualBoundingBoxViewController.delegate = self;
    //[_navigationController pushViewController:_manualBoundingBoxViewController animated:YES]; // TODO replace with drawer
    
}


#pragma mark- MCManualBoundingBoxDelegate
- (void) manualBoundingBoxCompletionHandlerWithLowerLeftLat:(double)lowerLeftLat andLowerLeftLon:(double)lowerLeftLon andUpperRightLat:(double)upperRightLat andUpperRightLon:(double)upperRightLon{
    [_boundingBoxViewController setBoundingBoxWithLowerLeftLat:lowerLeftLat andLowerLeftLon:lowerLeftLon andUpperRightLat:upperRightLat andUpperRightLon:upperRightLon];
    //[_navigationController popToViewController:_boundingBoxViewController animated:YES]; // TODO replace with drawer
    
}


#pragma mark- MCZoomAndQualityDelegate methods
- (void) zoomAndQualityCompletionHandlerWith:(NSNumber *) minZoom andMaxZoom:(NSNumber *) maxZoom {
    NSLog(@"In wizard, going to call completion handler");
    
    _tileData.loadTiles.generateTiles.minZoom = minZoom;
    _tileData.loadTiles.generateTiles.maxZoom = maxZoom;
    [self createTileLayer:_tileData];
    [_mapDelegate updateMapLayers];
}


- (void) cancelZoomAndQuality {
    [self.mapDelegate updateMapLayers];
}


#pragma mark - MCNewLayerWizardDelegate methods
- (void) createTileLayer:(GPKGSCreateTilesData *) tileData {
    NSLog(@"Coordinator attempting to create tiles");
    GPKGTileScaling *scaling = [GPKGSLoadTilesTask tileScaling];
    
    [GPKGSLoadTilesTask loadTilesWithCallback:self
                                  andDatabase:_database.name
                                     andTable:tileData.name
                                       andUrl:tileData.loadTiles.url
                                   andMinZoom:[tileData.loadTiles.generateTiles.minZoom intValue]
                                   andMaxZoom:[tileData.loadTiles.generateTiles.maxZoom intValue]
                            andCompressFormat:GPKG_CF_NONE // TODO: let user set this
                           andCompressQuality:[[GPKGSProperties getNumberValueOfProperty:GPKGS_PROP_LOAD_TILES_COMPRESS_QUALITY_DEFAULT] intValue]
                             andCompressScale:100 // TODO: let user set this
                            andStandardFormat:tileData.loadTiles.generateTiles.standardWebMercatorFormat
                               andBoundingBox:tileData.loadTiles.generateTiles.boundingBox
                               andTileScaling:scaling
                                 andAuthority:PROJ_AUTHORITY_EPSG
                                      andCode:[NSString stringWithFormat:@"%d",tileData.loadTiles.epsg]
                                     andLabel:[GPKGSProperties getValueOfProperty:GPKGS_PROP_GEOPACKAGE_CREATE_TILES_LABEL]];

}


#pragma mark - GPKGSLoadTilesProtocol methods
-(void) onLoadTilesCanceled: (NSString *) result withCount: (int) count {
    //TODO: fill in
    NSLog(@"Loading tiles canceled");
}


-(void) onLoadTilesFailure: (NSString *) result withCount: (int) count {
    //TODO: fill in
    NSLog(@"Loading tiles failed");
}


-(void) onLoadTilesCompleted: (int) count {
    //TODO: fill in
    NSLog(@"Loading tiles completed");
    //[_navigationController popToViewController:_geoPackageViewController animated:YES]; // TODO replace with drawer
    [_drawerDelegate popDrawer];
    [self updateDatabase];
}


@end