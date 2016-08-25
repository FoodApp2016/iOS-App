//
//  RequestHandler.h
//  Surplus
//
//  Created by Dhruv Manchala on 8/24/16.
//  Copyright © 2016 Dhruv Manchala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHandler : NSObject

-(void)getAllRestaurants:(void(^)(NSError *, NSData *))completionHandler;

@end
