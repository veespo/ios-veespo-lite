
#import "WebViewController.h"

@implementation WebViewController
@synthesize url = _url;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Feedback", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(openVeespo:)
                                              ];
    if (self.token == nil)
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationController.navigationBar.tintColor = UIColorFromHex(0x1D7800);
    } else {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
    
    CGRect appBounds = [UIScreen mainScreen].bounds;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, appBounds.size.height)];
    
    UIScrollView *webScroll = [[webView subviews]lastObject];
    [webScroll setBounces:NO];
    [webView setScalesPageToFit:YES];
    webView.delegate = self;
    webView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:_url];
    
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
    
    [self.view addSubview:webView];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}

- (IBAction)openVeespo:(id)sender
{
#ifdef VEESPO
    VEVeespoViewController *veespoViewController = nil;
    
    NSDictionary *d = @{
                        @"local_id": self.local_id, @"desc1": self.headline, @"desc2": self.newsTitle, @"lang": [[NSLocale preferredLanguages] objectAtIndex:0]
                        };
    
    veespoViewController = [[VEVeespoViewController alloc]
                            initWidgetWithToken:_token
                            targetInfo:d
                            withQuestion:[NSString stringWithFormat:NSLocalizedString(@"Veespo News Question", nil), self.headline]
                            detailsView:nil
                            ];
    
    veespoViewController.closeVeespoViewController = ^(NSDictionary *data){
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"%s %@", __PRETTY_FUNCTION__, data]];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [veespoViewController showWidget:^(NSDictionary *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messagio di debug"
                                                        message:[NSString stringWithFormat:@"Error %@", error]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
#endif
}

@end
