//
//  VEViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 20/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import <AdSupport/AdSupport.h>

#import "VEViewController.h"
#import "UIControl+VEControl.h"
#import "VEConnection.h"
#import "VETargetViewController.h"
#import "MBProgressHUD.h"

#define DEMOCODETEXT_ISO7 44.0
#define DEMOCODETEXT_IOS6 30.0

static NSString * const kVEDemoCode = @"yumx";

@interface VEViewController () {
    UIButton *historyDemoCodeBtn;
    UIButton *logVeespoBtn;
    UILabel *disclaimerLbl;
    UITextField *textOneTf;
    UITextField *textTwoTf;
    UITextField *textThreeTf;
    UITextField *textFourTf;
    UITextField *userNameTf;
    
    NSMutableDictionary *_history;
}

@end

@implementation VEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x1D7800);
    } else {
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x1D7800);
    }
    
    [self.view setBackgroundColor:UIColorFromRGB(0xDBDBDB)];
    
    [self initDemoCodeTextField];
    
    CGFloat titleLabelY = 8;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabelY, 300, 60)];
    titleLabel.text = NSLocalizedString(@"DemoCode Title", nil);
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.shadowColor = [UIColor whiteColor];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        titleLabel.backgroundColor = [UIColor clearColor];
    }
    
    historyDemoCodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    historyDemoCodeBtn.frame = CGRectMake(10, userNameTf.frame.origin.y + userNameTf.frame.size.height + 40, 130, 35);
    historyDemoCodeBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    _history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    if (_history)
        [historyDemoCodeBtn setTitle:NSLocalizedString(@"Categories voted", nil) forState:UIControlStateNormal];
    else
        [historyDemoCodeBtn setTitle:NSLocalizedString(@"No Demo", nil) forState:UIControlStateNormal];
    [historyDemoCodeBtn touchUpInside:^(UIEvent *event) {
        if (_history) {
            NSArray *keys = [_history allKeys];
            NSMutableArray *categories = [[NSMutableArray alloc] init];
            for (id key in keys) {
                [categories addObject:[_history objectForKey:key]];
            }
            
            [userNameTf resignFirstResponder];
            CGRect pickerFrame;
            ([UIScreen mainScreen].bounds.size.height == 568.0f)?(pickerFrame = CGRectMake(0, 0, 320, 568)):(pickerFrame = CGRectMake(0, 0, 320, 480));
            PickerView *historyDemoCodePicker = [[PickerView alloc] initWithFrame:pickerFrame withNSArray:categories];
            
            historyDemoCodePicker.delegate = self;
            [self.view addSubview:historyDemoCodePicker];
            [historyDemoCodePicker showPicker];
        } else {
            textOneTf.text = [NSString stringWithFormat:@"%c",[kVEDemoCode characterAtIndex:0]];
            textTwoTf.text = [NSString stringWithFormat:@"%c",[kVEDemoCode characterAtIndex:1]];
            textThreeTf.text = [NSString stringWithFormat:@"%c",[kVEDemoCode characterAtIndex:2]];
            textFourTf.text = [NSString stringWithFormat:@"%c",[kVEDemoCode characterAtIndex:3]];
        }
    }];
    
    logVeespoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    logVeespoBtn.frame = CGRectMake(230, userNameTf.frame.origin.y + userNameTf.frame.size.height + 40, 71, 35);
    logVeespoBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [logVeespoBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [logVeespoBtn touchUpInside:^(UIEvent *event) {
        if (![userNameTf.text isEqualToString:@""]) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *demoCode = [[NSString stringWithFormat:@"%@%@%@%@", textOneTf.text, textTwoTf.text, textThreeTf.text, textFourTf.text] uppercaseString];
            
            [self getTargetsList:demoCode];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Fill Form", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:historyDemoCodeBtn];
    [self.view addSubview:logVeespoBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    textOneTf.text = @"";
    textTwoTf.text = @"";
    textThreeTf.text = @"";
    textFourTf.text = @"";
    
    _history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
    if (_history)
        [historyDemoCodeBtn setTitle:NSLocalizedString(@"Categories voted", nil) forState:UIControlStateNormal];
    else
        [historyDemoCodeBtn setTitle:NSLocalizedString(@"No Demo", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDemoCodeTextField
{
    CGFloat dimension = (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) ? DEMOCODETEXT_ISO7 : DEMOCODETEXT_IOS6;
//    CGFloat textFieldY = (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) ? 127.0 : 83.0;
    CGFloat textFieldY = 83.0;
    CGFloat textFieldX = (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) ? 60.0 : 88.0;
    
    textOneTf = [[UITextField alloc] initWithFrame:CGRectMake(textFieldX, textFieldY, dimension, dimension)];
    textOneTf.delegate = self;
    [textOneTf setReturnKeyType:UIReturnKeyNext];
    [textOneTf setTextAlignment:NSTextAlignmentCenter];
    [textOneTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textOneTf setBorderStyle:UITextBorderStyleRoundedRect];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [textOneTf setBorderStyle:UITextBorderStyleLine];
        [textOneTf setBackgroundColor:[UIColor whiteColor]];
    }
    
    textTwoTf = [[UITextField alloc] initWithFrame:CGRectMake(textOneTf.frame.origin.x + dimension + 8, textFieldY, dimension, dimension)];
    textTwoTf.delegate = self;
    [textTwoTf setReturnKeyType:UIReturnKeyNext];
    [textTwoTf setTextAlignment:NSTextAlignmentCenter];
    [textTwoTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textTwoTf setBorderStyle:UITextBorderStyleRoundedRect];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [textTwoTf setBorderStyle:UITextBorderStyleLine];
        [textTwoTf setBackgroundColor:[UIColor whiteColor]];
    }
    
    textThreeTf = [[UITextField alloc] initWithFrame:CGRectMake(textTwoTf.frame.origin.x + dimension + 8, textFieldY, dimension, dimension)];
    textThreeTf.delegate = self;
    [textThreeTf setReturnKeyType:UIReturnKeyNext];
    [textThreeTf setTextAlignment:NSTextAlignmentCenter];
    [textThreeTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textThreeTf setBorderStyle:UITextBorderStyleRoundedRect];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [textThreeTf setBorderStyle:UITextBorderStyleLine];
        [textThreeTf setBackgroundColor:[UIColor whiteColor]];
    }
    
    textFourTf = [[UITextField alloc] initWithFrame:CGRectMake(textThreeTf.frame.origin.x + dimension + 8, textFieldY, dimension, dimension)];
    textFourTf.delegate = self;
    [textFourTf setReturnKeyType:UIReturnKeyNext];
    [textFourTf setTextAlignment:NSTextAlignmentCenter];
    [textFourTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textFourTf setBorderStyle:UITextBorderStyleRoundedRect];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [textFourTf setBorderStyle:UITextBorderStyleLine];
        [textFourTf setBackgroundColor:[UIColor whiteColor]];
    }
    
    userNameTf = [[UITextField alloc] initWithFrame:CGRectMake(60, textOneTf.frame.origin.y + dimension + 24, 200, 27)];
    [userNameTf setReturnKeyType:UIReturnKeyGo];
    [userNameTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [userNameTf setPlaceholder:NSLocalizedString(@"User Name", nil)];
    [userNameTf setBorderStyle:UITextBorderStyleRoundedRect];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [userNameTf setBorderStyle:UITextBorderStyleLine];
        [userNameTf setBackgroundColor:[UIColor whiteColor]];
    }
    userNameTf.delegate = self;
    userNameTf.text = @"";
    
    [self.view addSubview:textOneTf];
    [self.view addSubview:textTwoTf];
    [self.view addSubview:textThreeTf];
    [self.view addSubview:textFourTf];
    [self.view addSubview:userNameTf];
}

#pragma mark - Veespo

- (void)getTargetsList:(NSString *)demoCode
{
    VEConnection *connection = [[VEConnection alloc] init];
    
    [connection requestTargetList:[NSDictionary dictionaryWithObjectsAndKeys:demoCode, @"democode", userNameTf.text, @"userid", nil]
                        withBlock:^(id responseData, NSString *token) {
                            if (token != nil) {
                                VETargetViewController *targetVC = [[VETargetViewController alloc] initWithStyle:UITableViewStylePlain];
                                
                                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                                    targetVC.userid = [NSString stringWithFormat:@"%@-%@",
                                                       userNameTf.text,
                                                       [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
                                                       ];
                                    targetVC.token = token;
                                } else {
                                    targetVC.userid = [NSString stringWithFormat:@"%@-%@",
                                                       userNameTf.text,
                                                       [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]
                                                       ];
                                    targetVC.token = token;
                                }
                                targetVC.targetList = responseData[@"targets"];
                                targetVC.title = responseData[@"category"];
                                
                                // Creo o aggiorno storico utente
                                
                                NSDictionary *history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
                                
                                if (history == nil) {
                                    history = @{demoCode: responseData[@"category"]};
                                    [[NSUserDefaults standardUserDefaults] setObject:history forKey:@"history"];
                                } else {
                                    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:history];
                                    [tmp setObject:responseData[@"category"] forKey:demoCode];
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


#pragma mark - TextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""])
        return YES;
    if(textField == textOneTf) {
        textOneTf.text = string;
        [textTwoTf becomeFirstResponder];
    } else if (textField == textTwoTf) {
        textTwoTf.text = string;
        [textThreeTf becomeFirstResponder];
    } else if (textField == textThreeTf) {
        textThreeTf.text = string;
        [textFourTf becomeFirstResponder];
    } else if (textField == textFourTf) {
        textFourTf.text = string;
        [userNameTf becomeFirstResponder];
    } else
        return YES;
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField == textOneTf)
        [textTwoTf becomeFirstResponder];
    else if (theTextField == textTwoTf)
        [textThreeTf becomeFirstResponder];
    else if (theTextField == textThreeTf)
        [textFourTf becomeFirstResponder];
    else if (theTextField == textFourTf)
        [userNameTf becomeFirstResponder];
    else {
        [theTextField resignFirstResponder];
        if (![userNameTf.text isEqualToString:@""]) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *demoCode = [[NSString stringWithFormat:@"%@%@%@%@", textOneTf.text, textTwoTf.text, textThreeTf.text, textFourTf.text] uppercaseString];
            
            [self getTargetsList:demoCode];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Fill Form", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField != userNameTf) textField.text = nil;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]]) {
            [txt resignFirstResponder];
        }
    }
}

#pragma mark - Piker Delegate

- (void)pickerClosed
{
    
}

- (void)selectedRow:(int)row withString:(NSString *)text
{
    NSArray *keys = [_history allKeys];
    for (id key in keys) {
        if ([[_history objectForKey:key] isEqualToString:text]) {
            textOneTf.text = [NSString stringWithFormat:@"%c",[key characterAtIndex:0]];
            textTwoTf.text = [NSString stringWithFormat:@"%c",[key characterAtIndex:1]];
            textThreeTf.text = [NSString stringWithFormat:@"%c",[key characterAtIndex:2]];
            textFourTf.text = [NSString stringWithFormat:@"%c",[key characterAtIndex:3]];
            break;
        }
    }
}

@end
