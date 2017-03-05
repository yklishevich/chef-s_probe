//
//  UIPlaceHolderTextView.h
//  MyStash
//
//  Created by Akber Sayani on 26/12/2015.
//  Copyright © 2015 Akber Sayani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
