//
//  PBGauge.m
//  SimpleGauge
//
//  Created by Mike Sabatini on 1/30/13.
//  Copyright (c) 2013 Mike Sabatini. All rights reserved.
//

#import "MSAnnotatedGauge.h"
#import "MSArcLayer.h"

@interface MSAnnotatedGauge ()
@end

@implementation MSAnnotatedGauge

- (void)setup
{
    [super setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGPoint innerArcEndPoint = [self.backgroundArcLayer pointForArcEdge:ArcEdgeInner andArcSide:ArcSideEnd];
        innerArcEndPoint = CGPointMake(innerArcEndPoint.x - 60, innerArcEndPoint.y);
        
        _startRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(innerArcEndPoint.x, frame.size.height - 20 - 18, self.frame.size.width-(innerArcEndPoint.x), 18)];
        _startRangeLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        _startRangeLabel.textColor = UIColorFromHex(0x373737);
        _startRangeLabel.textAlignment = NSTextAlignmentLeft;
        _startRangeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_startRangeLabel];
        
        
        _endRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(innerArcEndPoint.x, frame.size.height - 20, self.frame.size.width-(innerArcEndPoint.x), 20)];
        _endRangeLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        _endRangeLabel.textColor = UIColorFromHex(0x373737);
        _endRangeLabel.textAlignment = NSTextAlignmentLeft;
        _endRangeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_endRangeLabel];
    }
    return self;
}

#pragma mark - Setters
- (void)setValue:(float)value
{
    [super setValue:value];
    if ( value <= self.maxValue && value >= self.minValue )
    {
        [self updateValueLabelAnimated:NO];
    }
}

- (void)updateValueLabelAnimated:(BOOL)animated
{
    if ( animated )
    {
        [NSTimer scheduledTimerWithTimeInterval:.05
                                         target:self
                                       selector:@selector(incrementTimerFired:)
                                       userInfo:nil
                                        repeats:YES];
    }
}

//- (void)updateValueLabelWithValue:(float)value
//{
////    _valueLabel.text = [_valueFormatter stringFromNumber:@(value-5)];
//}

@end
