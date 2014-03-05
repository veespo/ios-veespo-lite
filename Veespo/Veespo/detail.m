//
//  VEEDubleInformationDetail.m
//  VeespoFramework
//
//  Created by Alessio Roberto on 26/02/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "detail.h"

// Numerics
CGFloat const _kVEDetailValueViewPadding = 10.0f;
CGFloat const _kVEDetailValueViewSeparatorSize = 1.0f;
CGFloat const _kVEDetailValueViewTitleHeight = 25.0f;

// Colors
static UIColor *kVEDetailViewSeparatorColor = nil;
static UIColor *kVEDetailViewTitleColor = nil;
static UIColor *kVEDetailViewShadowColor = nil;

// Colors
static UIColor *kVEEDubleInformationDetailValueColor = nil;
static UIColor *kVEEDubleInformationDetailUnitColor = nil;
static UIColor *kVEEDubleInformationDetailShadowColor = nil;

@interface detailview : UIView

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *globalValueLabel;

@end

@interface detail (){
    BOOL firstVote;
}

@property (nonatomic, strong) detailview *valueView;
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UILabel *userTitleLabel;
@property (nonatomic, strong) UILabel *globalTitleLabel;
@property (nonatomic, strong) UIView *horizontalSeparatorView;
@property (nonatomic, strong) UIView *verticalSeparatorView;

// Position
- (CGRect)valueViewRect;
- (CGRect)globalValueViewRect;
- (CGRect)titleViewRectForHidden:(BOOL)hidden;
- (CGRect)horizontalSeparatorViewRectForHidden:(BOOL)hidden;
- (CGRect)verticalSeparatorViewRectForHidden:(BOOL)hidden;

@end

@implementation detail

+ (void)initialize
{
	if (self == [detail class])
	{
		kVEDetailViewSeparatorColor = [UIColor blackColor];
        kVEDetailViewTitleColor = [UIColor blackColor];
        kVEDetailViewShadowColor = [UIColor grayColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _userTitleLabel = [[UILabel alloc] init];
        _userTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        _userTitleLabel.numberOfLines = 1;
        _userTitleLabel.adjustsFontSizeToFitWidth = YES;
        _userTitleLabel.backgroundColor = [UIColor clearColor];
        _userTitleLabel.textColor = kVEDetailViewTitleColor;
        _userTitleLabel.shadowColor = kVEDetailViewShadowColor;
        _userTitleLabel.shadowOffset = CGSizeMake(0, 1);
        _userTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_userTitleLabel];
        
        _globalTitleLabel = [[UILabel alloc] init];
        _globalTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        _globalTitleLabel.numberOfLines = 1;
        _globalTitleLabel.adjustsFontSizeToFitWidth = YES;
        _globalTitleLabel.backgroundColor = [UIColor clearColor];
        _globalTitleLabel.textColor = kVEDetailViewTitleColor;
        _globalTitleLabel.shadowColor = kVEDetailViewShadowColor;
        _globalTitleLabel.shadowOffset = CGSizeMake(0, 1);
        _globalTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_globalTitleLabel];
        
        _horizontalSeparatorView = [[UIView alloc] init];
        _horizontalSeparatorView.backgroundColor = kVEDetailViewShadowColor;
        [self addSubview:_horizontalSeparatorView];
        
        _verticalSeparatorView = [[UIView alloc] init];
        _verticalSeparatorView.backgroundColor = kVEDetailViewShadowColor;
        [self addSubview:_verticalSeparatorView];
        
        _valueView = [[detailview alloc] initWithFrame:[self valueViewRect]];
        [self addSubview:_valueView];
        
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 76)];
        _firstView.backgroundColor = [UIColor whiteColor];
        _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 76)];
        _questionLabel.textAlignment = NSTextAlignmentCenter;
        _questionLabel.font = [UIFont fontWithName:@"Avenir" size:20];
        _questionLabel.numberOfLines = 0;
        [_firstView addSubview:self.questionLabel];
        
        [self addSubview:self.firstView];
        
        firstVote = NO;
        
        [self setHidden:YES animated:NO];
    }
    return self;
}

#pragma mark - Position

- (CGRect)valueViewRect
{
    CGRect valueRect = CGRectZero;
    valueRect.origin.x = _kVEDetailValueViewPadding;
    valueRect.origin.y = 5;
    valueRect.size.width = self.bounds.size.width - (_kVEDetailValueViewPadding * 2);
    valueRect.size.height = self.bounds.size.height - valueRect.origin.y - _kVEDetailValueViewPadding;
    return valueRect;
}

- (CGRect)globalValueViewRect
{
    CGRect valueRect = CGRectZero;
    valueRect.origin.x = _kVEDetailValueViewPadding;
    valueRect.origin.y = _kVEDetailValueViewPadding + _kVEDetailValueViewTitleHeight;
    valueRect.size.width = self.bounds.size.width - (_kVEDetailValueViewPadding * 2);
    valueRect.size.height = self.bounds.size.height - valueRect.origin.y - _kVEDetailValueViewPadding;
    return valueRect;
}

- (CGRect)titleViewRectForHidden:(BOOL)hidden
{
    CGRect titleRect = CGRectZero;
    titleRect.origin.x = _kVEDetailValueViewPadding;
    titleRect.origin.y = hidden ? -_kVEDetailValueViewTitleHeight : 2;
    titleRect.size.width = (self.bounds.size.width - (_kVEDetailValueViewPadding * 2)) / 2;
    titleRect.size.height = _kVEDetailValueViewTitleHeight;
    return titleRect;
}

- (CGRect)globalTitleViewRectForHidden:(BOOL)hidden
{
    CGRect titleRect = CGRectZero;
    titleRect.origin.x = _kVEDetailValueViewPadding + ((self.bounds.size.width - (_kVEDetailValueViewPadding * 2)) / 2);
    titleRect.origin.y = hidden ? -_kVEDetailValueViewTitleHeight : 2;
    titleRect.size.width = (self.bounds.size.width - (_kVEDetailValueViewPadding * 2)) / 2;
    titleRect.size.height = _kVEDetailValueViewTitleHeight;
    return titleRect;
}

- (CGRect)horizontalSeparatorViewRectForHidden:(BOOL)hidden
{
    CGRect separatorRect = CGRectZero;
    separatorRect.origin.x = _kVEDetailValueViewPadding;
    separatorRect.origin.y = _kVEDetailValueViewTitleHeight;
    separatorRect.size.width = self.bounds.size.width - (_kVEDetailValueViewPadding * 2);
    separatorRect.size.height = _kVEDetailValueViewSeparatorSize;
    if (hidden)
    {
        separatorRect.origin.x -= self.bounds.size.width;
    }
    return separatorRect;
}

- (CGRect)verticalSeparatorViewRectForHidden:(BOOL)hidden
{
    CGRect separatorRect = CGRectZero;
    separatorRect.origin.x = _kVEDetailValueViewPadding + ((self.bounds.size.width - (_kVEDetailValueViewPadding * 2)) / 2);
    separatorRect.origin.y = _kVEDetailValueViewPadding;
    separatorRect.size.width = _kVEDetailValueViewSeparatorSize;
    separatorRect.size.height = self.bounds.size.height - (_kVEDetailValueViewSeparatorSize * 2);
    if (hidden)
    {
        separatorRect.origin.y -= self.bounds.size.height;
    }
    return separatorRect;
}

#pragma mark - Setters

- (void)setTitleTexts:(NSString *)userTitleText globalTitleText:(NSString *)globalTitleText
{
    self.userTitleLabel.text = userTitleText;
    self.globalTitleLabel.text = globalTitleText;
    self.horizontalSeparatorView.hidden = !(userTitleText != nil);
    self.verticalSeparatorView.hidden = !(userTitleText != nil);
}

- (void)setValueText:(NSString *)valueText unitText:(NSString *)unitText
{
    self.valueView.valueLabel.text = valueText;
    self.valueView.globalValueLabel.text = unitText;
    [self.valueView setNeedsLayout];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    self.userTitleLabel.textColor = titleTextColor;
    [self.valueView setNeedsDisplay];
}

- (void)setValueAndUnitTextColor:(UIColor *)valueAndUnitColor
{
    self.valueView.valueLabel.textColor = valueAndUnitColor;
    [self.valueView setNeedsDisplay];
}

- (void)setTextShadowColor:(UIColor *)shadowColor
{
    self.valueView.valueLabel.shadowColor = shadowColor;
    self.userTitleLabel.shadowColor = shadowColor;
    self.globalTitleLabel.shadowColor = shadowColor;
    [self.valueView setNeedsDisplay];
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    self.horizontalSeparatorView.backgroundColor = separatorColor;
    self.verticalSeparatorView.backgroundColor = separatorColor;
    [self setNeedsDisplay];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (animated)
    {
        if (hidden)
        {
            [UIView animateWithDuration:0.25f * 0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.userTitleLabel.alpha = 0.0;
                self.globalTitleLabel.alpha = 0.0;
                self.horizontalSeparatorView.alpha = 0.0;
                self.verticalSeparatorView.alpha = 0.0;
                self.valueView.valueLabel.alpha = 0.0;
                self.valueView.globalValueLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.userTitleLabel.frame = [self titleViewRectForHidden:YES];
                self.globalTitleLabel.frame = [self globalTitleViewRectForHidden:YES];
                self.horizontalSeparatorView.frame = [self horizontalSeparatorViewRectForHidden:YES];
                self.verticalSeparatorView.frame = [self verticalSeparatorViewRectForHidden:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.userTitleLabel.frame = [self titleViewRectForHidden:NO];
                self.userTitleLabel.alpha = 1.0;
                self.globalTitleLabel.frame = [self globalTitleViewRectForHidden:NO];
                self.globalTitleLabel.alpha = 1.0;
                self.valueView.valueLabel.alpha = 1.0;
                self.valueView.globalValueLabel.alpha = 1.0;
                self.horizontalSeparatorView.frame = [self horizontalSeparatorViewRectForHidden:NO];
                self.horizontalSeparatorView.alpha = 1.0;
                self.verticalSeparatorView.frame = [self verticalSeparatorViewRectForHidden:NO];
                self.verticalSeparatorView.alpha = 1.0;
            } completion:nil];
        }
    }
    else
    {
        self.userTitleLabel.frame = [self titleViewRectForHidden:hidden];
        self.userTitleLabel.alpha = hidden ? 0.0 : 1.0;
        self.globalTitleLabel.frame = [self globalTitleViewRectForHidden:hidden];
        self.globalTitleLabel.alpha = hidden ? 0.0 : 1.0;
        self.horizontalSeparatorView.frame = [self horizontalSeparatorViewRectForHidden:hidden];
        self.horizontalSeparatorView.alpha = hidden ? 0.0 : 1.0;
        self.verticalSeparatorView.frame = [self verticalSeparatorViewRectForHidden:hidden];
        self.verticalSeparatorView.alpha = hidden ? 0.0 : 1.0;
        self.valueView.valueLabel.alpha = hidden ? 0.0 : 1.0;
        self.valueView.globalValueLabel.alpha = hidden ? 0.0 : 1.0;
    }
}

- (void)setHidden:(BOOL)hidden
{
    [self setHidden:hidden animated:NO];
}

#pragma mark - VEVisualView Public Methods
- (void)setupPannel:(NSNumber *)average totalVotes:(NSInteger)votes totalTags:(NSInteger)tags
{
    [self updatePannel:average totalVotes:votes totalTags:tags];
}

- (void)newVote:(NSNumber *)average totalVotes:(NSInteger)votes totalTags:(NSInteger)tags
{
    if (firstVote == NO) {
        firstVote = YES;
        [UIView animateWithDuration:0.35f delay:0 options:UIViewAnimationTransitionNone | UIViewAnimationOptionCurveLinear animations:^{
            _firstView.center = CGPointMake(_firstView.center.x, _firstView.center.y - 100);
            [self setTitleTexts:NSLocalizedString(@"Panel title 1", nil) globalTitleText:NSLocalizedString(@"Panel title 2", nil)];
            [self setHidden:NO animated:YES];
        } completion:^(BOOL finished) {
            [_firstView removeFromSuperview];
        }];
    }
    
    [self updatePannel:average totalVotes:votes totalTags:tags];
}

#pragma mark - Private Methods
- (void)updatePannel:(NSNumber *)average totalVotes:(NSInteger)votes totalTags:(NSInteger)tags
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundCeiling];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumIntegerDigits:1];
    
    
    if (votes > 0)
        [self setValueText:[formatter stringFromNumber:average] unitText:[formatter stringFromNumber:_globalAverage]];
    else
        [self setValueText:@"n.a." unitText:[formatter stringFromNumber:_globalAverage]];
}

@end

@implementation detailview

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [detailview class])
	{
		kVEEDubleInformationDetailValueColor = [UIColor blackColor];
        kVEEDubleInformationDetailUnitColor = [UIColor blackColor];
        kVEEDubleInformationDetailShadowColor = [UIColor grayColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:46];
        _valueLabel.textColor = kVEEDubleInformationDetailValueColor;
        _valueLabel.shadowColor = kVEEDubleInformationDetailShadowColor;
        _valueLabel.shadowOffset = CGSizeMake(0, 1);
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.adjustsFontSizeToFitWidth = NO;
        _valueLabel.numberOfLines = 1;
        [self addSubview:_valueLabel];
        
        _globalValueLabel = [[UILabel alloc] init];
        _globalValueLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:46];
        _globalValueLabel.textColor = kVEEDubleInformationDetailValueColor;
        _globalValueLabel.shadowColor = kVEEDubleInformationDetailShadowColor;
        _globalValueLabel.shadowOffset = CGSizeMake(0, 1);
        _globalValueLabel.backgroundColor = [UIColor clearColor];
        _globalValueLabel.textAlignment = NSTextAlignmentCenter;
        _globalValueLabel.adjustsFontSizeToFitWidth = NO;
        _globalValueLabel.numberOfLines = 1;
        [self addSubview:_globalValueLabel];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    self.valueLabel.frame = CGRectMake(_kVEDetailValueViewPadding, 20, (self.bounds.size.width - (_kVEDetailValueViewPadding * 2)) / 2, 50);
    self.globalValueLabel.frame = CGRectMake(_kVEDetailValueViewPadding + ((self.bounds.size.width - (_kVEDetailValueViewPadding * 2)) / 2), 20, (self.bounds.size.width - (_kVEDetailValueViewPadding * 2)) / 2, 50);
}

@end
