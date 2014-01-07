//
//  VIRCar.m
//  HWEditTable
//
//  Created by Administrator on 07.01.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "VIRCar.h"

@implementation VIRCar

static NSString *carNames[] = {
    @"C-MAX", @"Escape", @"Fiesta III 3D", @"Focus II Sedan", @"Focus Turnier II",
    @"Focus Hatchback III", @"Fusion", @"Maverick", @"Mondeo III", @"Mondeo IV",
    @"Mondeo IV Hatchback", @"Mondeo IV Turnier", @"Pickup"
};

static int carCounts = 13;

+ (VIRCar *)randomCar {
    
    VIRCar *car = [[VIRCar alloc] init];
    
    car.nameCar = carNames[arc4random() % carCounts];
    car.dateOfBay = arc4random() % 15 + 2000;
    
    return car;
}

@end
