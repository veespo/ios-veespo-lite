
#import "MBProgressHUD.h"

@interface WebViewController : UIViewController <MBProgressHUDDelegate, UIWebViewDelegate> {
    NSURL *_url;
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *newsTitle;
@property (nonatomic, strong) NSString *local_id;

@end
