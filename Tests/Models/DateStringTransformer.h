//
//  DateStringTransformer.h
//  Demo
//
//  Created by Aleksandr Kelbas on 13/04/2016.
//
//

#import <Foundation/Foundation.h>


/*
 This class is transforming "/Date(1460537233000)/" string into an NSDate object that can be stored in Core Data
 */
@interface DateStringTransformer : NSValueTransformer

@end
