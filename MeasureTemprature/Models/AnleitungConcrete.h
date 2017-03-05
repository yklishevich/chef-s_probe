//
//  AnleitungConcrete.h
//  
//
//  Created by Akber Sayani on 06/11/2016.
//  Copyright (c) 2016 Sayani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnleitungConcrete : NSObject {
    NSString *descriptionText;
    NSString *document;
    NSString *anleitungConcreteId;
}

@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, copy) NSString *document;
@property (nonatomic, copy) NSString *anleitungConcreteId;

+ (AnleitungConcrete *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
