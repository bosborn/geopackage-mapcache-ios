//
//  MasterViewController.m
//  geopackage-sample-ios
//
//  Created by Brian Osborn on 5/5/15.
//  Copyright (c) 2015 NGA. All rights reserved.
//

#import "MasterViewController.h"
#import "GPKGGeoPackage.h"
#import "GPKGGeoPackageFactory.h"
#import "GPKGGeoPackageManager.h"
#import "GPKGGeometryColumnsDao.h"


@interface MasterViewController ()

@property (nonatomic, strong) GPKGGeoPackage *geoPackage;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GPKGGeoPackageManager *manager = [GPKGGeoPackageFactory getManager];
    self.geoPackage = [manager open:@"TestName"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonTapped:(id)sender {
    
    NSMutableString *resultString = [NSMutableString string];
    
    NSArray *featureTables = [self.geoPackage getFeatureTables];
    for (NSString *featureTable in featureTables) {
        [resultString appendString:@"\n"];
        [resultString appendString:featureTable];
    }
    
    GPKGGeometryColumnsDao *dao = [self.geoPackage getGeometryColumnsDao];
    
    BOOL tableExists = [dao isTableExists];
    [resultString appendString:@"\n"];
    [resultString appendString:@"\n"];
    [resultString appendFormat:@"Table Exists: %d", tableExists];
    
    GPKGResultSet *allGeometryColumns = [dao queryForAll];
    [resultString appendString:@"\n\n"];
    [resultString appendFormat:@"Count: %d", allGeometryColumns.count];
    while([allGeometryColumns moveToNext]){
        GPKGGeometryColumns *geomColumn = (GPKGGeometryColumns *)[dao getObject: allGeometryColumns];

        [resultString appendString:@"\n\n"];
        [resultString appendString:geomColumn.tableName];
        [resultString appendString:@"\n"];
        [resultString appendString:geomColumn.columnName];
        [resultString appendString:@"\n"];
        [resultString appendString:geomColumn.geometryTypeName];
        [resultString appendString:@"\n"];
        [resultString appendString:[geomColumn.srsId stringValue]];
        [resultString appendString:@"\n"];
        [resultString appendString:[geomColumn.z stringValue]];
        [resultString appendString:@"\n"];
        [resultString appendString:[geomColumn.m stringValue]];
    }
    [allGeometryColumns close];
    
    NSArray *idValues = @[@"multipoint2d", @"geom"];
    GPKGGeometryColumns *idValuesResult = (GPKGGeometryColumns *)[dao queryForMultiIdObject:idValues];
    
    GPKGGeometryColumns *idValueResult = (GPKGGeometryColumns *)[dao queryForIdObject:@"linestring2d"];
    
    GPKGResultSet *equalResult = [dao queryForEqWithField:GC_COLUMN_Z andValue: [NSNumber numberWithInt:1]];
    while([equalResult moveToNext]){
        GPKGGeometryColumns *geomColumn = (GPKGGeometryColumns *)[dao getObject: equalResult];
    }
    [equalResult close];
    
    int count = [dao count];
    int count2 = [dao countWhere:[NSString stringWithFormat:@"%@ = 'linestring2d'", GC_COLUMN_TABLE_NAME]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    GPKGColumnValue *tableNameCV = [[GPKGColumnValue alloc] init];
    tableNameCV.value = @"linestring3d";
    [dictionary setObject:tableNameCV forKey:GC_COLUMN_TABLE_NAME];
    GPKGColumnValue *zCV = [[GPKGColumnValue alloc] init];
    zCV.value = [NSNumber numberWithInt:1];
    zCV.tolerance = [NSNumber numberWithDouble:0.5];
    [dictionary setObject:zCV forKey:GC_COLUMN_Z];

    GPKGResultSet *dictionaryResult = [dao queryForColumnValueFieldValues:dictionary];
    while([dictionaryResult moveToNext]){
        GPKGGeometryColumns *geomColumn = (GPKGGeometryColumns *)[dao getObject: dictionaryResult];
    }
    
    self.resultText.text = resultString;
    
    [dao dropTable];
    
    tableExists = [dao isTableExists];
    
}

@end
