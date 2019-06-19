//
//  MCGeoPackageList.m
//  MapDrawer
//
//  Created by Tyler Burgett on 8/15/18.
//  Copyright © 2018 GeoPackage. All rights reserved.
//

#import "MCGeoPackageList.h"

@interface MCGeoPackageList()
@property (strong, nonatomic) NSMutableArray *childCoordinators;
@property (nonatomic, strong) GPKGSDatabases *active;
@end


@implementation MCGeoPackageList

- (instancetype) initWithGeoPackages: (NSMutableArray *) geoPackages asFullView: (BOOL) fullView andDelegate:(id<MCGeoPacakageListViewDelegate>) delegate {
    self = [super initAsFullView:fullView];
    _geoPackages = geoPackages;
    _geopackageListViewDelegate = delegate;
    _active = [GPKGSDatabases getInstance];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 126.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"MCGeoPackageCell" bundle:nil] forCellReuseIdentifier:@"geopackage"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MCEmptyStateCell" bundle:nil] forCellReuseIdentifier:@"emptyState"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MCTutorialCell" bundle:nil] forCellReuseIdentifier:@"tutorialCell"];
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)gestureIsInConflict:(UIPanGestureRecognizer *) recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    
    if (CGRectContainsPoint(self.tableView.frame, point)) {
        return true;
    }
    
    return false;
}


- (void)refreshWithGeoPackages:(NSMutableArray *) geoPackages {
    _geoPackages = geoPackages;
    [self.tableView reloadData];
}


- (void) updateAndReloadData {
    [self.tableView reloadData];
}


- (IBAction)createGeoPackage:(id)sender {
    UIAlertController *newGeoPackageAlert = [UIAlertController alertControllerWithTitle:@"New GeoPackage" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [newGeoPackageAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"";
    }];
    
    UIAlertAction *confirmCreate = [UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Name: %@", newGeoPackageAlert.textFields[0].text);
        
        NSString * newName = newGeoPackageAlert.textFields[0].text;
        [self.geopackageListViewDelegate createGeoPackage:newName];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [newGeoPackageAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [newGeoPackageAlert addAction:confirmCreate];
    [newGeoPackageAlert addAction:cancel];
    
    [self presentViewController:newGeoPackageAlert animated:YES completion:nil];
}



- (IBAction)downloadGeopackage:(id)sender {
    [_geopackageListViewDelegate downloadGeopackage];
}


- (void)toggleGeoPacakge:(NSIndexPath *) indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.geopackageListViewDelegate toggleActive:[self.geoPackages objectAtIndex:indexPath.row]];
        MCGeoPackageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell toggleActiveIndicator];
    });
}


- (void)deleteGeoPackageAtIndexPath:(NSIndexPath *) indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.geopackageListViewDelegate deleteGeoPackage:[self.geoPackages objectAtIndex:indexPath.row]];
    });
}


#pragma mark - TableView delegate and data souce methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_geoPackages.count > 0) {
        
        if (indexPath.row == _geoPackages.count) {
            MCTutorialCell *tutorialCell = (MCTutorialCell *)[self.tableView dequeueReusableCellWithIdentifier:@"tutorialCell"];
            return tutorialCell;
        }
        
        MCGeoPackageCell *cell = (MCGeoPackageCell *)[self.tableView dequeueReusableCellWithIdentifier:@"geopackage"];
        
        if (!cell) {
            cell = [[MCGeoPackageCell alloc] init];
        }
        
        GPKGSDatabase *database = [_geoPackages objectAtIndex:indexPath.row];
        
        cell.geoPackageNameLabel.text = database.name;
        cell.featureLayerDetailsLabel.text = [NSString stringWithFormat:@"%ld Feature layers", (long)[database getFeatures].count];
        cell.tileLayerDetailsLabel.text = [NSString stringWithFormat:@"%ld Tile layers", (long)[database getTileCount]];
        
        if ([_active isActive:database]) {
            [cell activeLayersIndicatorOn];
        } else {
            [cell activeLayersIndicatorOff];
        }
        
        return cell;
    }
    
    
    
    MCEmptyStateCell *cell = (MCEmptyStateCell *)[self.tableView dequeueReusableCellWithIdentifier:@"emptyState"];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_geoPackages.count == 0) { // special case for empty state
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 1;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return _geoPackages.count + 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[MCEmptyStateCell class]]){
        [_geopackageListViewDelegate downloadGeopackage];
    } else if([cell isKindOfClass:[MCTutorialCell class]]){
        return;
    } else {
        GPKGSDatabase *selectedGeoPackage = [_geoPackages objectAtIndex:indexPath.row];
        NSLog(@"didSelectRowAtIndexPath for %@", selectedGeoPackage.name);
        [_geopackageListViewDelegate didSelectGeoPackage:selectedGeoPackage];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[MCEmptyStateCell class]]){
        return 400.0;
    } else if([cell isKindOfClass:[MCTutorialCell class]]) {
        return 200.0;
    } else {
        return 126.0;
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[MCEmptyStateCell class]] || [cell isKindOfClass:[MCTutorialCell class]]){
        return nil;
    }
    
    UIContextualAction *toggleGeoPackageAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Toggle" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self toggleGeoPacakge:indexPath];
        completionHandler(YES);
    }];
    
    // TODO: add check for state of the geopackage data, if it is on or off set this button accordingly
    
    MCGeoPackageCell *geoPackageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([geoPackageCell.visibilityStatusIndicator isHidden]) {
        toggleGeoPackageAction.backgroundColor = [UIColor colorWithRed:0.13 green:0.31 blue:0.48 alpha:1.0];
        toggleGeoPackageAction.title = @"Add to map";
    } else {
        toggleGeoPackageAction.backgroundColor = [UIColor grayColor];
        toggleGeoPackageAction.title = @"Remove from map";
    }
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[toggleGeoPackageAction]];
    configuration.performsFirstActionWithFullSwipe = YES;
    return configuration;
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[MCEmptyStateCell class]] || [cell isKindOfClass:[MCTutorialCell class]]){
        return nil;
    }
    
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self deleteGeoPackageAtIndexPath:indexPath];
        completionHandler(YES);
    }];
    delete.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[delete]];
    configuration.performsFirstActionWithFullSwipe = YES;
    return configuration;
}


#pragma mark - MCGeoPackageCoordinatorDelegate method
- (void) geoPackageCoordinatorCompletionHandlerForDatabase:(NSString *)database withDelete:(BOOL)didDelete {
    
    /*if (didDelete) {
        [self.manager delete:database];
        [self.active removeDatabase:database andPreserveOverlays:false];
    }*/
    
    [self updateAndReloadData];
}


@end