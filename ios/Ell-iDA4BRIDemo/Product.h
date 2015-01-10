//
//  Product.h
//  Ell-iDA4BRIDemo
//
//  Created by Jose Granados on 29/11/14.
//  Copyright (c) 2014 Jose Granados. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Product : NSObject

@property NSString *productName;
@property NSString *productDescription;
@property UIImage *productImage;
@property BOOL isInStock;
@property BOOL isInteresting;
@property BOOL isMannequinProminent;
@property float productPrice;
@property NSString *productReview;
@property NSString *productSize;

@end
