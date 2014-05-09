//
//  VEHomeViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 10/01/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEHomeViewController.h"

#import "VETargetViewController.h"
#import "VEETargetObj.h"

#import "VEEReachabilityManager.h"
#import "UIControl+VEControl.h"
#import "MBProgressHUD.h"
#import "NSString+Extra.h"

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
    
    [self enabledVeespoButton];
    
    _history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    if (_history)
        [self.historyDemoCodeBtn setTitle:NSLocalizedString(@"Categories voted", nil) forState:UIControlStateNormal];
    else
        [self.historyDemoCodeBtn setTitle:NSLocalizedString(@"No Demo", nil) forState:UIControlStateNormal];
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

#pragma mark Private Properties

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
- (void)enabledVeespoButton
{
    if ([self.userNameTf.text isEqualToString:@""] || ([self.textOneTf.text isEqualToString:@""] || [self.textTwoTf.text isEqualToString:@""] || [self.textThreeTf.text isEqualToString:@""] || [self.textFourTf.text isEqualToString:@""]))
        self.logVeespoBtn.enabled = NO;
    else
        self.logVeespoBtn.enabled = YES;
}

- (void)getTargetsList:(NSString *)demoCode
{
#ifdef VEESPO
    VEVeespoAPIWrapper *veespo = [[VEVeespoAPIWrapper alloc] init];
    
    // clean user name to create correct Veespo userID
    NSString *veespoUserId;
    
    NSData *asciiEncoded = [self.userNameTf.text dataUsingEncoding:NSASCIIStringEncoding
                                              allowLossyConversion:YES];
    veespoUserId = [[NSString alloc] initWithData:asciiEncoded encoding:NSASCIIStringEncoding];
    
    veespoUserId = [NSString stringWithFormat:@"%@-%@",
                    veespoUserId,
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]
                    ];
    
    if ([veespoUserId checkIdString]) {
        
        // Check if veespoUserId is change
        if (![[NSUserDefaults standardUserDefaults] stringForKey:kVEEUserNameKey] ||
            ( ![veespoUserId isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:kVEEUserNameKey]] && [[NSUserDefaults standardUserDefaults] stringForKey:kVEEUserNameKey]) ) {
            
            [[NSUserDefaults standardUserDefaults] setObject:veespoUserId forKey:kVEEUserNameKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            VEAppDelegate *appDelegate = (VEAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate checkVeespoTokens];
        }
        
        veespoUserId = [veespoUserId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [veespo requestTargetList:[NSDictionary dictionaryWithObjectsAndKeys:demoCode, @"democode", veespoUserId, @"userid", nil]
                          success:^(id responseData, NSString *token) {
                              
                              __block NSDictionary *targetList = [[NSDictionary alloc] initWithDictionary:responseData];
                              
                              __block VETargetViewController *targetVC = [[VETargetViewController alloc] initWithStyle:UITableViewStylePlain];
                              
                              targetVC.userid = veespoUserId;
                              targetVC.token = token;
                              targetVC.title = targetList[@"categoryname"];
                              
                              // Inizializzo TargetObj
                              for (int i = 0; i < ((NSArray *)targetList[@"targets"]).count; i++) {
                                  VEETargetObj *tobj = [[VEETargetObj alloc] initWithDictionary:[targetList[@"targets"] objectAtIndex:i]];
                                  [targetVC.targetList addObject:tobj];
                              }
                              
                              // Creo o aggiorno storico utente
                              
                              NSDictionary *history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
                              
                              if (history == nil) {
                                  history = @{demoCode: @{demoCode: targetList[@"category"], @"desc1": targetList[@"categoryname"]}};
                                  [[NSUserDefaults standardUserDefaults] setObject:history forKey:@"history"];
                              } else {
                                  NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:history];
                                  [tmp setObject:@{demoCode: targetList[@"category"], @"desc1": targetList[@"categoryname"]} forKey:demoCode];
                                  [[NSUserDefaults standardUserDefaults] setObject:tmp forKey:@"history"];
                              }
                              
                              // Verifico se ci sono target già votati dall'utente e li ordino alfabeticamente
                              [veespo requestTargetsForUser:veespoUserId withCategory:targetList[@"category"] withToken:token success:^(id responseData) {
                                  
                                  if (((NSArray *)responseData).count > 0) {
                                      NSArray *userTargetsList = [NSArray new];
                                      
                                      NSArray *list = [[NSArray alloc] initWithArray:responseData];
                                      userTargetsList = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                          NSString *name1 = obj1[@"desc1"];
                                          NSString *name2 = obj2[@"desc1"];
                                          return [name1 compare:name2];
                                      }];
                                      
                                      for (int i = 0; i < userTargetsList.count; i++) {
                                          for (int j = 0; j < targetVC.targetList.count; j++) {
                                              VEETargetObj *tobj = [targetVC.targetList objectAtIndex:j];
                                              if ([[userTargetsList objectAtIndex:i][@"target"] isEqualToString:tobj.targetId]) {
                                                  tobj.voted = YES;
                                              }
                                          }
                                      }
                                  }

                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  
                                  [self.navigationController pushViewController:targetVC animated:YES];
                              } failure:^(id error) {
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  
                                  [self.navigationController pushViewController:targetVC animated:YES];
                              }];
                              
                          } failure:^(id error) {
                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:[error objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                              [alert show];
                          }];
    }
    else {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Name error", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
#endif
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
        
        [self enabledVeespoButton];
        
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
        
        [self enabledVeespoButton];
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
            
            [self enabledVeespoButton];
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
    
    [self enabledVeespoButton];
}


@end
