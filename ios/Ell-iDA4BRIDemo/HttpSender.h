//
//  HttpSender.h
//  Ell-iDA4BRIDemo
//
//  Created by Jose Granados on 3/12/14.
//  Copyright (c) 2014 Jose Granados. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpSender : NSObject

+ (void)sendHttp:(NSString*)url;

@end
