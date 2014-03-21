//
//  VEDoublePannel.m
//  Veespo
//
//  Created by Alessio Roberto on 07/03/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import "VEDoublePannel.h"
#import "MSAnnotatedGauge.h"

@interface VEDoublePannel () {
    BOOL firstVote;
    MSAnnotatedGauge *annotatedGauge;
    UIView *firstView;
    BOOL panelMode;
}
@property (nonatomic, strong) UILabel *questionLabel;
@end

@implementation VEDoublePannel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        annotatedGauge = [[MSAnnotatedGauge alloc] initWithFrame:CGRectMake(0, 0, 300, 76)];
        annotatedGauge.minValue = 0;
        annotatedGauge.maxValue = 10;
        annotatedGauge.startRangeLabel.text = @"Voti";
        annotatedGauge.endRangeLabel.text = @"Media n.a.";
        annotatedGauge.fillArcFillColor = [UIColor clearColor];
        annotatedGauge.fillArcStrokeColor = [UIColor clearColor];
        [self addSubview:annotatedGauge];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withPanelQuestion:(NSString *)question
{
    self = [super initWithFrame:frame];
    if (self) {
        panelMode = YES;
        annotatedGauge = [[MSAnnotatedGauge alloc] initWithFrame:CGRectMake(0, 0, 300, 76)];
        annotatedGauge.minValue = 0;
        annotatedGauge.maxValue = 10;
        annotatedGauge.startRangeLabel.text = @"Voti";
        annotatedGauge.endRangeLabel.text = @"Media n.a.";
        annotatedGauge.fillArcFillColor = [UIColor clearColor];
        annotatedGauge.fillArcStrokeColor = [UIColor clearColor];
        [self addSubview:annotatedGauge];
        
        firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 76)];
        firstView.backgroundColor = [UIColor whiteColor];
        self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 76)];
        self.questionLabel.textAlignment = NSTextAlignmentCenter;
        self.questionLabel.font = [UIFont fontWithName:@"Avenir" size:20];
        self.questionLabel.numberOfLines = 0;
        self.questionLabel.text = question;
        [firstView addSubview:self.questionLabel];
        
        [self addSubview:firstView];
        
        firstVote = NO;
    }
    return self;
}

#pragma mark - VEVisualView Public Methods
- (void)setupPannel:(NSNumber *)average totalVotes:(NSInteger)votes totalTags:(NSInteger)tags
{
    [self updatePannel:average totalVotes:votes totalTags:tags];
}

- (void)newVote:(NSNumber *)average totalVotes:(NSInteger)votes totalTags:(NSInteger)tags
{
    if (panelMode == YES && firstVote == NO) {
        firstVote = YES;
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationTransitionNone | UIViewAnimationOptionCurveLinear animations:^{
            firstView.center = CGPointMake(firstView.center.x, firstView.center.y - 100);
        } completion:^(BOOL finished) {
            [firstView removeFromSuperview];
        }];
    }
    
    [self updatePannel:average totalVotes:votes totalTags:tags];
}

#pragma mark - Private Methods
- (void)updatePannel:(NSNumber *)average totalVotes:(NSInteger)votes totalTags:(NSInteger)tags
{
    [annotatedGauge setValue:[average floatValue] + 5 animated:YES];
    annotatedGauge.startRangeLabel.text = [NSString stringWithFormat:@"Voti %d/%d", votes, tags];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumIntegerDigits:1];
    if (votes > 0)
        annotatedGauge.endRangeLabel.text = [NSString stringWithFormat:@"Media %@", [formatter stringFromNumber:average]];
    else
        annotatedGauge.endRangeLabel.text = @"Media n.a.";
}

@end
