//
//  WebVC.h
//  DemoLumIt
//
//  Created by Alessio Roberto on 13/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WebVC : UIViewController <MBProgressHUDDelegate, UIWebViewDelegate> {
    NSURL *_url;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSURL *url;

@end
