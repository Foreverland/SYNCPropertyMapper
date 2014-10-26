//
//  NSManagedObject+HYPPropertyMapper.m
//
//  Created by Christoffer Winterkvist on 7/2/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

@import CoreData;

@interface NSString (PrivateInflections)

- (NSString *)convertToRemoteString;
- (NSString *)convertToLocalString;

@end

@interface NSManagedObject (HYPPropertyMapper)

- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)hyp_dictionary;

@end
