//
//  MCZoomAndQualityViewController.m
//  mapcache-ios
//
//  Created by Tyler Burgett on 2/7/18.
//  Copyright © 2018 NGA. All rights reserved.
//

#import "MCZoomAndQualityViewController.h"

@interface MCZoomAndQualityViewController ()
@property (strong, nonatomic) NSMutableArray *cellArray;
@property (strong, nonatomic) GPKGSFieldWithTitleCell *minZoomCell;
@property (strong, nonatomic) GPKGSFieldWithTitleCell *maxZoomCell;
@property (strong, nonatomic) GPKGSSegmentedControlCell *tileFormatCell;
@property (strong, nonatomic) GPKGSButtonCell *buttonCell;
@end

@implementation MCZoomAndQualityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCellTypes];
    [self initCellArray];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UIAccessibilityTraitNone;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initCellArray {
    _cellArray = [[NSMutableArray alloc] init];
    
    GPKGSSectionTitleCell *titleCell = [self.tableView dequeueReusableCellWithIdentifier:@"title"];
    titleCell.sectionTitleLabel.text = @"Tile Storage Options";
    [_cellArray addObject:titleCell];
    
    _minZoomCell = [self.tableView dequeueReusableCellWithIdentifier:@"fieldWithTitle"];
    _minZoomCell.title.text = @"Minimum Zoom";
    _minZoomCell.field.keyboardType = UIKeyboardTypeNumberPad;
    [_minZoomCell.field setReturnKeyType:UIReturnKeyDone];
    [_cellArray addObject:_minZoomCell];
    
    _maxZoomCell = [self.tableView dequeueReusableCellWithIdentifier:@"fieldWithTitle"];
    _maxZoomCell.title.text = @"Maximum Zoom";
    _maxZoomCell.field.keyboardType = UIKeyboardTypeNumberPad;
    [_maxZoomCell.field setReturnKeyType:UIReturnKeyDone];
    [_cellArray addObject:_maxZoomCell];
    
    _tileFormatCell = [self.tableView dequeueReusableCellWithIdentifier:@"segmentedControl"];
    _tileFormatCell.label.text = @"Tile Format";
    NSArray *formats = [[NSArray alloc] initWithObjects: @"GeoPackage", @"Standard", nil];
    [_tileFormatCell setItems:formats];
    [_cellArray addObject:_tileFormatCell];
    
    _buttonCell = [self.tableView dequeueReusableCellWithIdentifier:@"button"];
    [_buttonCell.button setTitle:@"Create Tile Layer" forState:UIControlStateNormal];
    _buttonCell.delegate = self;
    [_cellArray addObject:_buttonCell];
}


- (void) registerCellTypes {
    [self.tableView registerNib:[UINib nibWithNibName:@"GPKGSSectionTitleCell" bundle:nil] forCellReuseIdentifier:@"title"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GPKGSFieldWithTitleCell" bundle:nil] forCellReuseIdentifier:@"fieldWithTitle"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GPKGSSegmentedControlCell" bundle:nil] forCellReuseIdentifier:@"segmentedControl"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GPKGSButtonCell" bundle:nil] forCellReuseIdentifier:@"button"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cellArray objectAtIndex:indexPath.row];
}


#pragma mark - UITextFieldDelegate methods
- (void) textFieldDidEndEditing:(UITextField *)textField {
    // TODO check some values and enable or disable the button accordingly
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -  GPKGSButtonCellDelegate method
- (void) performButtonAction:(NSString *)action {
    NSLog(@"Button tapped in zoom and format screen");
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *minZoom = [formatter numberFromString:_minZoomCell.field.text];
    NSNumber *maxZoom = [formatter numberFromString:_maxZoomCell.field.text];
    
    [_delegate zoomAndQualityCompletionHandlerWith:minZoom andMaxZoom:maxZoom];
}

@end