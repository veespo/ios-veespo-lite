//
//  VEHomeViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 10/01/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEHomeViewController.h"

#import "UIControl+VEControl.h"
#import "VEConnection.h"
#import "VETargetViewController.h"
#import "MBProgressHUD.h"
#import "NSString+Extra.h"

#import <AdSupport/AdSupport.h>

#define DEMOCODETEXT_ISO7 44.0
#define DEMOCODETEXT_IOS6 30.0

static NSString * const kVEDemoCode = @"krbk";

@interface VEHomeViewController () {
    NSMutableDictionary *_history;
}

@end

@implementation VEHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromHex(0xDBDBDB)];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:(([UIScreen mainScreen].bounds.size.height == 568.0f)?
                                                                           [UIImage imageNamed:@"background_5"]:
                                                                           [UIImage imageNamed:@"background_4"])];
    [backgroundImageView setFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:backgroundImageView];
    
    UIImageView *foregroundImageView = [[UIImageView alloc] initWithImage:(([UIScreen mainScreen].bounds.size.height == 568.0f)?
                                                                           [UIImage imageNamed:@"home_shadow_5"]:
                                                                           [UIImage imageNamed:@"home_shadow_4"])];
    [foregroundImageView setFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:foregroundImageView];
    
    [self.view sendSubviewToBack:foregroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    [self.userNameTf setPlaceholder:NSLocalizedString(@"User Name", nil)];
    
    [self.disclaimerLbl setText:NSLocalizedString(@"Disclaimer", nil)];
    
    self.historyDemoCodeBtn.tintColor = [UIColor whiteColor];
    
    _history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    [self.historyDemoCodeBtn setBackgroundImage:[UIImage imageNamed:@"bottone_home"] forState:UIControlStateNormal];
    if (_history)
        [self.historyDemoCodeBtn setTitle:NSLocalizedString(@"Categories voted", nil) forState:UIControlStateNormal];
    else
        [self.historyDemoCodeBtn setTitle:NSLocalizedString(@"No Demo", nil) forState:UIControlStateNormal];

    [self.historyDemoCodeBtn touchUpInside:^(UIEvent *event) {
        _history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
        if (_history) {
            NSArray *keys = [_history allKeys];
            NSMutableArray *categories = [[NSMutableArray alloc] init];
            for (id key in keys) {
                NSDictionary *dic = [_history objectForKey:key];
                [categories addObject:[dic objectForKey:key]];
            }
            
            [self.userNameTf resignFirstResponder];
            CGRect pickerFrame;
            ([UIScreen mainScreen].bounds.size.height == 568.0f)?(pickerFrame = CGRectMake(0, 0, 320, 568)):(pickerFrame = CGRectMake(0, 0, 320, 480));
            PickerView *historyDemoCodePicker = [[PickerView alloc] initWithFrame:pickerFrame withNSArray:categories];
            
            historyDemoCodePicker.delegate = self;
            [self.view addSubview:historyDemoCodePicker];
            [historyDemoCodePicker showPicker];
        } else {
            self.textOneTf.text = [NSString stringWithFormat:@"%c",[kVEDemoCode characterAtIndex:0]];
            self.textTwoTf.text = [NSString stringWithFormat:@"%c",[kVEDemoCode characterAtIndex:1]];
            self.textThreeTf.text = [NSString stringWithFormat:@"%c",[kVEDemoCode characterAtIndex:2]];
            self.textFourTf.text = [NSString stringWithFormat:@"%c",[kVEDemoCode characterAtIndex:3]];
        }
    }];
    
    self.logVeespoBtn.tintColor = [UIColor whiteColor];
    [self.logVeespoBtn setBackgroundImage:[UIImage imageNamed:@"bottone_home"] forState:UIControlStateNormal];
    [self.logVeespoBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    self.logVeespoBtn.enabled = NO;
    [self.logVeespoBtn touchUpInside:^(UIEvent *event) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *demoCode = [[NSString stringWithFormat:@"%@%@%@%@", self.textOneTf.text, self.textTwoTf.text, self.textThreeTf.text, self.textFourTf.text] uppercaseString];
        
        [self getTargetsList:demoCode];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([UIScreen mainScreen].bounds.size.height != 568.0f) {
        // register for keyboard notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationController.navigationBar.tintColor = UIColorFromHex(0x231F20);
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavbarHome-44"] forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavbarHome"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"NavbarShadow"]];
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x231F20);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([UIScreen mainScreen].bounds.size.height != 568.0f) {
        // unregister for keyboard notifications while not visible.
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.textOneTf.text = @"";
    self.textTwoTf.text = @"";
    self.textThreeTf.text = @"";
    self.textFourTf.text = @"";
    
    _history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    if (_history)
        [self.historyDemoCodeBtn setTitle:NSLocalizedString(@"Categories voted", nil) forState:UIControlStateNormal];
    else
        [self.historyDemoCodeBtn setTitle:NSLocalizedString(@"No Demo", nil) forState:UIControlStateNormal];
    
    self.logVeespoBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)panelShow
{
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]]) {
            [txt resignFirstResponder];
        }
    }
}

#pragma mark Keyboard and view managment

#define kOFFSET_FOR_KEYBOARD 80.0

- (void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)deobservKeyboardNotifications
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Veespo

- (void)getTargetsList:(NSString *)demoCode
{
    VEConnection *connection = [[VEConnection alloc] init];
    
    // clean usern name to create correct Veespo userID
    NSString *veespoUserId;
    
    NSData *asciiEncoded = [self.userNameTf.text dataUsingEncoding:NSASCIIStringEncoding
                                              allowLossyConversion:YES];
    veespoUserId = [[NSString alloc] initWithData:asciiEncoded encoding:NSASCIIStringEncoding];
    
    if ([veespoUserId checkIdString]) {
        veespoUserId = [veespoUserId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [connection requestTargetList:[NSDictionary dictionaryWithObjectsAndKeys:demoCode, @"democode", veespoUserId, @"userid", nil]
                            withBlock:^(id responseData, NSString *token) {
                                if (token != nil) {
                                    VETargetViewController *targetVC = [[VETargetViewController alloc] initWithStyle:UITableViewStylePlain];
                                    
                                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                                        targetVC.userid = [NSString stringWithFormat:@"%@-%@",
                                                           veespoUserId,
                                                           [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
                                                           ];
                                        targetVC.token = token;
                                    } else {
                                        targetVC.userid = [NSString stringWithFormat:@"%@-%@",
                                                           veespoUserId,
                                                           [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]
                                                           ];
                                        targetVC.token = token;
                                    }
                                    targetVC.targetList = responseData[@"targets"];
                                    targetVC.title = responseData[@"categoryname"];
                                    
                                    // Creo o aggiorno storico utente
                                    
                                    NSDictionary *history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
                                    
                                    if (history == nil) {
                                        history = @{demoCode: @{demoCode: responseData[@"category"], @"desc1": responseData[@"categoryname"]}};
                                        [[NSUserDefaults standardUserDefaults] setObject:history forKey:@"history"];
                                    } else {
                                        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:history];
                                        [tmp setObject:@{demoCode: responseData[@"category"], @"desc1": responseData[@"categoryname"]} forKey:demoCode];
                                        [[NSUserDefaults standardUserDefaults] setObject:tmp forKey:@"history"];
                                    }
                                    
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    [self.navigationController pushViewController:targetVC animated:YES];
                                } else {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:[responseData objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alert show];
                                }
                            }
         ];
    }
    else {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Name error", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - TextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
        return YES;
    if(textField == self.textOneTf) {
        self.textOneTf.text = string;
        [self.textTwoTf becomeFirstResponder];
    } else if (textField == self.textTwoTf) {
        self.textTwoTf.text = string;
        [self.textThreeTf becomeFirstResponder];
    } else if (textField == self.textThreeTf) {
        self.textThreeTf.text = string;
        [self.textFourTf becomeFirstResponder];
    } else if (textField == self.textFourTf) {
        self.textFourTf.text = string;
        [textField resignFirstResponder];
        if ([self.userNameTf.text isEqualToString:@""] || ([self.textOneTf.text isEqualToString:@""] || [self.textTwoTf.text isEqualToString:@""] || [self.textThreeTf.text isEqualToString:@""] || [self.textFourTf.text isEqualToString:@""]))
            self.logVeespoBtn.enabled = NO;
        else
            self.logVeespoBtn.enabled = YES;
    } else
        return YES;
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField == self.userNameTf && ([self.textOneTf.text isEqualToString:@""] || [self.textTwoTf.text isEqualToString:@""] || [self.textThreeTf.text isEqualToString:@""] || [self.textFourTf.text isEqualToString:@""]))
        [self.textOneTf becomeFirstResponder];
    else if (theTextField == self.textOneTf)
        [self.textTwoTf becomeFirstResponder];
    else if (theTextField == self.textTwoTf)
        [self.textThreeTf becomeFirstResponder];
    else if (theTextField == self.textThreeTf)
        [self.textFourTf becomeFirstResponder];
    else {
        [theTextField resignFirstResponder];
        if ([self.userNameTf.text isEqualToString:@""] || ([self.textOneTf.text isEqualToString:@""] || [self.textTwoTf.text isEqualToString:@""] || [self.textThreeTf.text isEqualToString:@""] || [self.textFourTf.text isEqualToString:@""]))
            self.logVeespoBtn.enabled = NO;
        else
            self.logVeespoBtn.enabled = YES;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField != self.userNameTf) textField.text = nil;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]]) {
            [txt resignFirstResponder];
            if ([self.userNameTf.text isEqualToString:@""] || ([self.textOneTf.text isEqualToString:@""] || [self.textTwoTf.text isEqualToString:@""] || [self.textThreeTf.text isEqualToString:@""] || [self.textFourTf.text isEqualToString:@""]))
                self.logVeespoBtn.enabled = NO;
            else
                self.logVeespoBtn.enabled = YES;
        }
    }
}

#pragma mark - Piker Delegate

- (void)pickerClosed
{
    if (![self.userNameTf.text isEqualToString:@""] || (![self.textOneTf.text isEqualToString:@""] || ![self.textTwoTf.text isEqualToString:@""] || ![self.textThreeTf.text isEqualToString:@""] || ![self.textFourTf.text isEqualToString:@""]))
        self.logVeespoBtn.enabled = NO;
    else
        self.logVeespoBtn.enabled = YES;
}

- (void)selectedRow:(int)row withString:(NSString *)text
{
    _history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    NSArray *keys = [_history allKeys];
    for (id key in keys) {
        NSDictionary *dic = [_history objectForKey:key];
        if ([[dic objectForKey:key] isEqualToString:text]) {
            self.textOneTf.text = [NSString stringWithFormat:@"%c",[key characterAtIndex:0]];
            self.textTwoTf.text = [NSString stringWithFormat:@"%c",[key characterAtIndex:1]];
            self.textThreeTf.text = [NSString stringWithFormat:@"%c",[key characterAtIndex:2]];
            self.textFourTf.text = [NSString stringWithFormat:@"%c",[key characterAtIndex:3]];
            break;
        }
    }
    if ([self.userNameTf.text isEqualToString:@""] || ([self.textOneTf.text isEqualToString:@""] || [self.textTwoTf.text isEqualToString:@""] || [self.textThreeTf.text isEqualToString:@""] || [self.textFourTf.text isEqualToString:@""]))
        self.logVeespoBtn.enabled = NO;
    else
        self.logVeespoBtn.enabled = YES;
}


@end
