//
//  YHCPickerView.h
//  TestDB
//
//  Created by Yashesh Chauhan on 01/10/12.
//  Copyright (c) 2012 Yashesh Chauhan. All rights reserved.
//

@protocol PickerViewDelegate <NSObject>

- (void)selectedRow:(int)row withString:(NSString *)text;
- (void)pickerClosed;

@end

@interface PickerView : UIView <UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    UIPickerView *pickerView;
    UIToolbar *picketToolbar;
    NSArray *arrRecords;
    UIActionSheet *aac;
    
    NSMutableArray *copyListOfItems;
	BOOL letUserSelectRow;
    
    id <PickerViewDelegate> delegate;
    
}


@property (nonatomic, retain) NSArray *arrRecords;
@property (nonatomic, retain) id <PickerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withNSArray:(NSArray *)arrValues;
- (void)showPicker;
- (void)btnDoneClick;
@end
