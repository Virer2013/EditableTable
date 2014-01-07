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
    
    self.tableView.editing = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.groups = [NSMutableArray array];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return [group.cars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    
    VIRGroup *group = [self.groups objectAtIndex:indexPath.section];
    VIRCar *car = [group.cars objectAtIndex:indexPath.row];
    
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

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//massive don't change
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    VIRGroup *sourceGroup = [self.groups objectAtIndex:sourceIndexPath.section];
    VIRCar *car = [sourceGroup.cars objectAtIndex:sourceIndexPath.row];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceGroup.cars];
    
    if(sourceIndexPath.section == destinationIndexPath.section) {
        
        [tempArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        sourceGroup.cars = tempArray;
        
    } else {
        
        [tempArray removeObject:car];
        sourceGroup.cars = tempArray;
        
        VIRGroup *destinationGroup = [self.groups objectAtIndex:destinationIndexPath.section];
        tempArray = [NSMutableArray arrayWithArray:destinationGroup.cars];
        [tempArray insertObject:car atIndex:destinationIndexPath.row];
        destinationGroup.cars = tempArray;
    }
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleInsert;
}




@end
