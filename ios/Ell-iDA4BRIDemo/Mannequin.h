//
//  Mannequin.h
//  Ell-iDA4BRIDemo
//
//  Created by Jose Granados on 29/11/14.
//  Copyright (c) 2014 Jose Granados. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"

@interface Mannequin : NSObject

@property NSString *name;
@property NSMutableArray *setOfProducts;
@property Beacon *associatedBeacon;

@end
