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

#define DEMOCODETEXT_WIDTH 44.0
#define DEMOCODETEXT_HEIGHT 44.0

@interface VEViewController () {
    UITextField *textOneTf;
    UITextField *textTwoTf;
    UITextField *textThreeTf;
    UITextField *textFourTf;
    UITextField *userNameTf;
    UIButton *historyDemoCodeBtn;
    UIButton *logVeespoBtn;
    UILabel *disclaimerLbl;
    NSMutableDictionary *_history;
    NSString *_demoCode;
}

@end

@implementation VEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _demoCode = nil;
	
    textOneTf = [[UITextField alloc] initWithFrame:CGRectMake(60, 107, DEMOCODETEXT_WIDTH, DEMOCODETEXT_HEIGHT)];
    textOneTf.delegate = self;
    [textOneTf setReturnKeyType:UIReturnKeyNext];
    [textOneTf setTextAlignment:NSTextAlignmentCenter];
    [textOneTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    //    [textOneTf setBackgroundColor:[UIColor whiteColor]];
    [textOneTf setBorderStyle:UITextBorderStyleRoundedRect];
    
    textTwoTf = [[UITextField alloc] initWithFrame:CGRectMake(textOneTf.frame.origin.x + DEMOCODETEXT_WIDTH + 8, 107, DEMOCODETEXT_WIDTH, DEMOCODETEXT_HEIGHT)];
    textTwoTf.delegate = self;
    [textTwoTf setReturnKeyType:UIReturnKeyNext];
    [textTwoTf setTextAlignment:NSTextAlignmentCenter];
    [textTwoTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    //    [textTwoTf setBackgroundColor:[UIColor whiteColor]];
    [textTwoTf setBorderStyle:UITextBorderStyleRoundedRect];
    
    textThreeTf = [[UITextField alloc] initWithFrame:CGRectMake(textTwoTf.frame.origin.x + DEMOCODETEXT_WIDTH + 8, 107, DEMOCODETEXT_WIDTH, DEMOCODETEXT_HEIGHT)];
    textThreeTf.delegate = self;
    [textThreeTf setReturnKeyType:UIReturnKeyNext];
    [textThreeTf setTextAlignment:NSTextAlignmentCenter];
    [textThreeTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    //    [textThreeTf setBackgroundColor:[UIColor whiteColor]];
    [textThreeTf setBorderStyle:UITextBorderStyleRoundedRect];
    
    textFourTf = [[UITextField alloc] initWithFrame:CGRectMake(textThreeTf.frame.origin.x + DEMOCODETEXT_WIDTH + 8, 107, DEMOCODETEXT_WIDTH, DEMOCODETEXT_HEIGHT)];
    textFourTf.delegate = self;
    [textFourTf setReturnKeyType:UIReturnKeyNext];
    [textFourTf setTextAlignment:NSTextAlignmentCenter];
    [textFourTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    //    [textFourTf setBackgroundColor:[UIColor whiteColor]];
    [textFourTf setBorderStyle:UITextBorderStyleRoundedRect];
    
    userNameTf = [[UITextField alloc] initWithFrame:CGRectMake(60, textOneTf.frame.origin.y + DEMOCODETEXT_HEIGHT + 44, 200, 27)];
    [userNameTf setReturnKeyType:UIReturnKeyGo];
    [userNameTf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [userNameTf setPlaceholder:@"Nome dell'utente"];
    //    [userNameTf setBackgroundColor:[UIColor whiteColor]];
    [userNameTf setBorderStyle:UITextBorderStyleRoundedRect];
    userNameTf.delegate = self;
    
    historyDemoCodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    historyDemoCodeBtn.frame = CGRectMake(20, userNameTf.frame.origin.y + userNameTf.frame.size.height + 10, 130, 35);
    [historyDemoCodeBtn setTitle:@"Storico Accessi" forState:UIControlStateNormal];
    [historyDemoCodeBtn touchUpInside:^(UIEvent *event) {
        _history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];

        NSArray *keys = [_history allKeys];
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        for (id key in keys) {
            [categories addObject:[_history objectForKey:key]];
        }
        
        [userNameTf resignFirstResponder];
        CGRect pickerFrame;
        ([UIScreen mainScreen].bounds.size.height == 568.0f)?(pickerFrame = CGRectMake(0, 0, 320, 568)):(pickerFrame = CGRectMake(0, 0, 320, 480));
        VEPickerView *historyDemoCodePicker = [[VEPickerView alloc] initWithFrame:pickerFrame withNSArray:categories];
        
        historyDemoCodePicker.delegate = self;
        [self.view addSubview:historyDemoCodePicker];
        [historyDemoCodePicker showPicker];
    }];
    
    logVeespoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    logVeespoBtn.frame = CGRectMake(216, userNameTf.frame.origin.y + userNameTf.frame.size.height + 10, 71, 35);
    [logVeespoBtn setTitle:@"Accedi" forState:UIControlStateNormal];
    [logVeespoBtn touchUpInside:^(UIEvent *event) {
        if (![userNameTf.text isEqualToString:@""]) {
            VEConnection *connection = [[VEConnection alloc] init];
            
            if (_demoCode == nil)
                _demoCode = [[NSString stringWithFormat:@"%@%@%@%@", textOneTf.text, textTwoTf.text, textThreeTf.text, textFourTf.text] uppercaseString];
            
            [connection requestTargetList:[NSDictionary dictionaryWithObjectsAndKeys:_demoCode, @"democode", userNameTf.text, @"userid", nil]
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
                                        
                                        // Creo o aggiorno storico utente
                                        
                                        NSDictionary *history = [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
                                        
                                        if (history == nil) {
                                            history = @{_demoCode: responseData[@"category"]};
                                            [[NSUserDefaults standardUserDefaults] setObject:history forKey:@"history"];
                                        } else {
                                            NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:history];
                                            [tmp setObject:responseData[@"category"] forKey:_demoCode];
                                            [[NSUserDefaults standardUserDefaults] setObject:tmp forKey:@"history"];
                                        }
                                        
                                        [self.navigationController pushViewController:targetVC animated:YES];
                                    } else {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:[responseData objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alert show];
                                    }
                                }
             ];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Inserire un nome utente" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    [self.view addSubview:textOneTf];
    [self.view addSubview:textTwoTf];
    [self.view addSubview:textThreeTf];
    [self.view addSubview:textFourTf];
    [self.view addSubview:userNameTf];
    [self.view addSubview:historyDemoCodeBtn];
    [self.view addSubview:logVeespoBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _demoCode = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    else
        [theTextField resignFirstResponder];
    return YES;
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
            _demoCode = key;
            break;
        }
    }
}

@end
