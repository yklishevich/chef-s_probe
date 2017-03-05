//
//  AboutUsViewController.h
//  MeasureTemprature
//
//  Created by Akber Sayani on 24/09/2016.
//  Copyright © 2016 Akber Sayani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, LoadWebContentType) {
    kLoadFromURL,
    kLoadAboutUs,
    kLoadVersionen,
    kLoadVerkaufsstellen
};

@interface AboutUsViewController : BaseViewController

//@property(nonatomic,assign) BOOL loadHtml;
@property(nonatomic,assign) LoadWebContentType webContentType;
@property(nonatomic,strong) NSString *loadURL;

@end
