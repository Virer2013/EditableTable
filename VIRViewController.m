//
//  VIRViewController.m
//  HWEditTable
//
//  Created by Administrator on 07.01.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "VIRViewController.h"
#import "VIRCar.h"
#import "VIRGroup.h"

@interface VIRViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *groups;

@end

const NSInteger indexRow = 1;

@implementation VIRViewController

- (void)loadView {
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    //self.tableView.editing = YES;
    
    self.tableView.allowsSelectionDuringEditing = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.groups = [NSMutableArray array];
    /*
    for (int i = 0; i < (arc4random() % 4 + 2); i++) {
        VIRGroup *group = [[VIRGroup alloc] init];
        group.nameGroup = [NSString stringWithFormat:@"Group #%d", i];
        
        NSMutableArray *array = [NSMutableArray array];
    
        for (int j = 0; j < (arc4random() % 6 + 7); j++) {
            [array addObject:[VIRCar randomCar]];
        }
        
        group.cars = array;
        
        [self.groups addObject:group];
    }
  
    [self.tableView reloadData];
    */
    self.navigationItem.title = @"Cars";
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.leftBarButtonItem = addButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)actionEdit:(UIBarButtonItem *)sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if(self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(actionEdit:)];
    
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
}

- (void)actionAdd:(UIBarButtonItem *)sender {
    
    VIRGroup *group = [[VIRGroup alloc] init];
    group.nameGroup = [NSString stringWithFormat:@"Group #%d", [self.groups count]];
    
    group.cars = @[[VIRCar randomCar], [VIRCar randomCar]];
    
    NSInteger newSectionIndex = 0;
    
    [self.groups insertObject:group atIndex:newSectionIndex];
    
    [self.tableView beginUpdates];
    
    NSIndexSet *insertSections = [NSIndexSet indexSetWithIndex:newSectionIndex];
    
    UITableViewRowAnimation animation = UITableViewRowAnimationFade;
    
    if([self.groups count] > 1){
        animation = [self.groups count] % 2 ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
    }
    
    [self.tableView insertSections:insertSections withRowAnimation:animation];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.groups count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.groups objectAtIndex:section] nameGroup];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    VIRGroup *group = [self.groups objectAtIndex:section];
    
    return [group.cars count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        static NSString *addCarIndentifier = @"AddCarCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCarIndentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addCarIndentifier];
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.text = @"Tap to add new Car";
        }
        
        return cell;
    } else {
        static NSString *indentifier = @"CarCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        }
        
        VIRGroup *group = [self.groups objectAtIndex:indexPath.section];
        VIRCar *car = [group.cars objectAtIndex:indexPath.row - 1];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", car.nameCar];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", car.dateOfBay];
        
        if(car.dateOfBay >= 2014) {
            cell.detailTextLabel.textColor = [UIColor blueColor];
        } else if (car.dateOfBay >= 2010) {
            cell.detailTextLabel.textColor = [UIColor greenColor];
        } else {
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row > 0;
}

//massive don't change
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    VIRGroup *sourceGroup = [self.groups objectAtIndex:sourceIndexPath.section];
    VIRCar *car = [sourceGroup.cars objectAtIndex:sourceIndexPath.row - indexRow];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.cars];
    
    if(sourceIndexPath.section == destinationIndexPath.section) {
        
        [tempArray exchangeObjectAtIndex:sourceIndexPath.row - indexRow withObjectAtIndex:destinationIndexPath.row - indexRow];
        sourceGroup.cars = tempArray;
        
    } else {
        
        [tempArray removeObject:car];
        sourceGroup.cars = tempArray;
        
        VIRGroup *destinationGroup = [self.groups objectAtIndex:destinationIndexPath.section];
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.cars];
        [tempArray insertObject:car atIndex:destinationIndexPath.row - indexRow];
        destinationGroup.cars = tempArray;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        VIRGroup *sourceGroup = [self.groups objectAtIndex:indexPath.section];
        VIRCar *car = [sourceGroup.cars objectAtIndex:indexPath.row - indexRow];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.cars];
        [tempArray removeObject:car];
        sourceGroup.cars = tempArray;
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView endUpdates];
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if(proposedDestinationIndexPath.row == 0){
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0){
        VIRGroup *group = [self.groups objectAtIndex:indexPath.section];
        
        NSMutableArray *tempArray = nil;
        
        if(group.cars){
            tempArray = [NSMutableArray arrayWithArray:group.cars];
        } else {
            tempArray = [NSMutableArray array];
        }
        
        NSInteger newCarIndex = 0;
        
        [tempArray insertObject:[VIRCar randomCar] atIndex:newCarIndex];
        group.cars = tempArray;
        
        [self.tableView beginUpdates];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newCarIndex + indexRow inSection:indexPath.row];
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    }
    
}
@end
