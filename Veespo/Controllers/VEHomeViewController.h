//
//  VEHomeViewController.h
//  Veespo
//
//  Created by Alessio Roberto on 10/01/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerView.h"

@interface VEHomeViewController : UIViewController <UITextFieldDelegate, PickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *historyDemoCodeBtn;
@property (nonatomic, weak) IBOutlet UIButton *logVeespoBtn;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *disclaimerLbl;
@property (nonatomic, weak) IBOutlet UITextField *textOneTf;
@property (nonatomic, weak) IBOutlet UITextField *textTwoTf;
@property (nonatomic, weak) IBOutlet UITextField *textThreeTf;
@property (nonatomic, weak) IBOutlet UITextField *textFourTf;
@property (nonatomic, weak) IBOutlet UITextField *userNameTf;

- (void)panelShow;

@end
