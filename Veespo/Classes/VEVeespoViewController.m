//
//  VEVeespoViewController.m
//  Veespo
//
//  Created by Alessio Roberto on 22/09/13.
//  Copyright (c) 2013 Veespo Ltd. All rights reserved.
//

#import "VEVeespoViewController.h"

#define DEMOCODETEXT_WIDTH 44.0
#define DEMOCODETEXT_HEIGHT 44.0

@interface VEVeespoViewController () {
    UITextField *textOneTf;
    UITextField *textTwoTf;
    UITextField *textThreeTf;
    UITextField *textFourTf;
    UITextField *userNameTf;
    UIButton *historyDemoCodeBtn;
    UIButton *logVeespoBtn;
    UILabel *disclaimerLbl;
    UIPickerView *historyDemoCodePicker;
}

@end

@implementation VEVeespoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
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
    
    historyDemoCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyDemoCodeBtn.frame = CGRectMake(20, userNameTf.frame.origin.y + 27 + 60, 130, 35);
    [historyDemoCodeBtn setTitle:@"Storico Accessi" forState:UIControlStateNormal];
    historyDemoCodeBtn.tintColor = UIColorFromRGB(0x1D7800);
    logVeespoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    logVeespoBtn.frame = CGRectMake(216, historyDemoCodeBtn.frame.origin.y, 71, 35);
    [logVeespoBtn setTitle:@"Accedi" forState:UIControlStateNormal];
    
    [self.view addSubview:textOneTf];
    [self.view addSubview:textTwoTf];
    [self.view addSubview:textThreeTf];
    [self.view addSubview:textFourTf];
    [self.view addSubview:userNameTf];
    [self.view addSubview:historyDemoCodeBtn];
    [self.view addSubview:logVeespoBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
