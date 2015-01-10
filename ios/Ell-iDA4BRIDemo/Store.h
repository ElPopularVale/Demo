//
//  Store.h
//  Ell-iDA4BRIDemo
//
//  Created by Jose Granados on 30/11/14.
//  Copyright (c) 2014 Jose Granados. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ResourcePath(path)[[NSBundle mainBundle] pathForResource:path ofType:nil]

#define ImageWithPath(path)[UIImage imageWithContentsOfFile:path]

@interface Store : NSObject

@property (nonatomic,strong) NSMutableArray *productArray;
@property (nonatomic,strong) NSMutableArray *mannequinArray;
@property (nonatomic,strong) NSMutableArray *highlightedProductsArray;

@end
