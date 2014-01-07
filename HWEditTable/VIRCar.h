//
//  VIRCar.h
//  HWEditTable
//
//  Created by Administrator on 07.01.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIRCar : NSObject

@property(strong, nonatomic) NSString *nameCar;
@property (assign, nonatomic) NSInteger dateOfBay;

+ (VIRCar *)randomCar;

@end
