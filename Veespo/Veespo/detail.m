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
CGFloat const _kVEDetailValueViewTitleHeight = 20.0f;
CGFloat const _kVEDetailValueViewTitleWidth = 75.0f;

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
@property (nonatomic, strong) UIView *horizzontalSeparatorView;
@property (nonatomic, strong) UIView *verticalSeparatorView;

// Position
- (CGRect)valueViewRect;
- (CGRect)globalValueViewRect;
- (CGRect)titleViewRectForHidden:(BOOL)hidden;
- (CGRect)separatorViewRectForHidden:(BOOL)hidden;

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
        [self addSubview:_userTitleLabel];
        
        _globalTitleLabel = [[UILabel alloc] init];
        _globalTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        _globalTitleLabel.numberOfLines = 1;
        _globalTitleLabel.adjustsFontSizeToFitWidth = YES;
        _globalTitleLabel.backgroundColor = [UIColor clearColor];
        _globalTitleLabel.textColor = kVEDetailViewTitleColor;
        _globalTitleLabel.shadowColor = kVEDetailViewShadowColor;
        _globalTitleLabel.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:_globalTitleLabel];
        
        _horizzontalSeparatorView = [[UIView alloc] init];
        _horizzontalSeparatorView.backgroundColor = kVEDetailViewShadowColor;
        [self addSubview:_horizzontalSeparatorView];
        
        _valueView = [[detailview alloc] init];
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
    valueRect.origin.y = _kVEDetailValueViewPadding + _kVEDetailValueViewTitleHeight;
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
    titleRect.size.width = self.bounds.size.width - (_kVEDetailValueViewPadding * 2);
    titleRect.size.height = _kVEDetailValueViewTitleHeight;
    return titleRect;
}

- (CGRect)globalTitleViewRectForHidden:(BOOL)hidden
{
    CGRect titleRect = CGRectZero;
    titleRect.origin.x = _kVEDetailValueViewPadding + 140;
    titleRect.origin.y = hidden ? -_kVEDetailValueViewTitleHeight : 2;
    titleRect.size.width = self.bounds.size.width - (_kVEDetailValueViewPadding * 2);
    titleRect.size.height = _kVEDetailValueViewTitleHeight;
    return titleRect;
}

- (CGRect)separatorViewRectForHidden:(BOOL)hidden
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

#pragma mark - Setters

- (void)setTitleTexts:(NSString *)userTitleText globalTitleText:(NSString *)globalTitleText
{
    self.userTitleLabel.text = userTitleText;
    self.globalTitleLabel.text = globalTitleText;
    self.horizzontalSeparatorView.hidden = !(userTitleText != nil);
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
    self.horizzontalSeparatorView.backgroundColor = separatorColor;
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
                self.horizzontalSeparatorView.alpha = 0.0;
                self.valueView.valueLabel.alpha = 0.0;
                self.valueView.globalValueLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.userTitleLabel.frame = [self titleViewRectForHidden:YES];
                self.globalTitleLabel.frame = [self globalTitleViewRectForHidden:YES];
                self.horizzontalSeparatorView.frame = [self separatorViewRectForHidden:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.userTitleLabel.frame = [self titleViewRectForHidden:NO];
                self.userTitleLabel.alpha = 1.0;
                self.globalTitleLabel.frame = [self globalTitleViewRectForHidden:NO];
                self.globalTitleLabel.alpha = 1.0;
                self.valueView.valueLabel.alpha = 1.0;
                self.valueView.globalValueLabel.alpha = 1.0;
                self.horizzontalSeparatorView.frame = [self separatorViewRectForHidden:NO];
                self.horizzontalSeparatorView.alpha = 1.0;
            } completion:nil];
        }
    }
    else
    {
        self.userTitleLabel.frame = [self titleViewRectForHidden:hidden];
        self.userTitleLabel.alpha = hidden ? 0.0 : 1.0;
        self.globalTitleLabel.frame = [self globalTitleViewRectForHidden:hidden];
        self.globalTitleLabel.alpha = hidden ? 0.0 : 1.0;
        self.horizzontalSeparatorView.frame = [self separatorViewRectForHidden:hidden];
        self.horizzontalSeparatorView.alpha = hidden ? 0.0 : 1.0;
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
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationTransitionNone | UIViewAnimationOptionCurveLinear animations:^{
            _firstView.center = CGPointMake(_firstView.center.x, _firstView.center.y - 100);
        } completion:^(BOOL finished) {
            [_firstView removeFromSuperview];
            [self setTitleTexts:@"La tua media" globalTitleText:@"Media globale"];
            [self setHidden:NO animated:YES];
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
        [self setValueText:[NSString stringWithFormat:@"%@",[formatter stringFromNumber:average]] unitText:@"n.a."];
    else
        [self setValueText:@"n.a." unitText:@"n.a."];
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
        _valueLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:50];
        _valueLabel.textColor = kVEEDubleInformationDetailValueColor;
        _valueLabel.shadowColor = kVEEDubleInformationDetailShadowColor;
        _valueLabel.shadowOffset = CGSizeMake(0, 1);
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.adjustsFontSizeToFitWidth = NO;
        _valueLabel.numberOfLines = 1;
        [self addSubview:_valueLabel];
        
        _globalValueLabel = [[UILabel alloc] init];
        _globalValueLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:50];
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
    self.valueLabel.frame = CGRectMake(20, 30, 100, 50);
    self.globalValueLabel.frame = CGRectMake(150, 30, 100, 50);
}

@end
