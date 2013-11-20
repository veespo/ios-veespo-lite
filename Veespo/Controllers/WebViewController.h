
#import "MBProgressHUD.h"

@interface WebViewController : UIViewController <MBProgressHUDDelegate, UIWebViewDelegate> {
    NSURL *_url;
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSURL *url;

@end
