//
//  YHCPickerView.h
//  TestDB
//
//  Created by Yashesh Chauhan on 01/10/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VEPickerViewDelegate <NSObject>

- (void)selectedRow:(int)row withString:(NSString *)text;
- (void)pickerClosed;

@end

@interface VEPickerView : UIView <UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    UIPickerView *pickerView;
    UIToolbar *picketToolbar;
    NSArray *arrRecords;
    UIActionSheet *aac;
    
    NSMutableArray *copyListOfItems;
	BOOL letUserSelectRow;
    
    id <VEPickerViewDelegate> delegate;
    
}


@property (nonatomic, retain) NSArray *arrRecords;
@property (nonatomic, retain) id <VEPickerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues;
- (void)showPicker;
- (void)btnDoneClick;
@end
