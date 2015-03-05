//
//  CardView.m
//  CardScroll
//
//  Created by Jason Smith on 8/6/14.
//  Copyright (c) 2014 Method. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.orgCenter = self.center;
        self.orgFrame = self.frame;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    
}
*/

@end
