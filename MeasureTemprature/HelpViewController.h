//
//  HelpViewController.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 25/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, LoadContentType) {
    kLoadPDF,
    kLoadVideo
};

@interface HelpViewController : BaseViewController

@property(nonatomic,assign) LoadContentType contentType;

@end
