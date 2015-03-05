//
//  CardScrollViewController.m
//  CardScroll
//
//  Created by Jason Smith on 8/6/14.
//  Copyright (c) 2014 Method. All rights reserved.
//

#import "CardScrollViewController.h"
#import "CardView.h"

@interface CardScrollViewController () <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    NSMutableArray *allPanels;
}

@end

@implementation CardScrollViewController

-(void)viewDidLoad
{
    [self setup];
}

-(void)setup
{
    // initialize variables
    int numPanels = 10;
    float panelHeight = 568;
    allPanels = [[NSMutableArray alloc] initWithCapacity:numPanels];
    
    // configure the background color
    self.view.backgroundColor = [UIColor blackColor];
    
    
    // create holder to put all the panels in - this holder will go inside the scroll view
    float holderHeight = panelHeight * numPanels;
    CGRect holderFrame = CGRectMake(0, 0, 320, holderHeight);
    UIView *holder = [[UIView alloc] initWithFrame:holderFrame];
    
    
    // create panels
    CGRect panelFrame = CGRectMake(0, 0, 320, panelHeight);
    
    for (int i=0; i<numPanels; i++)
    {
        // adust vertical position and create panel
        panelFrame.origin.y = i * panelHeight;
        CardView *panel = [[CardView alloc] initWithFrame:panelFrame];
        
        // get a unique cycling hue value for each card
        float hueRatio = (float)i / (float)numPanels;
        panel.backgroundColor = [UIColor colorWithHue:hueRatio saturation:1.0 brightness:1.0 alpha:1.0];
        
        // create a label to number the panels
        UILabel *label = [[UILabel alloc] initWithFrame:panel.bounds];
        label.text = [NSString stringWithFormat:@"%i", i%10];
        label.textColor = [UIColor colorWithHue:hueRatio saturation:1.0 brightness:0.8 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:panelFrame.size.height];
        [panel addSubview:label];
        
        // add panel to the holder
        [holder addSubview:panel];
        
        // add panel to panels array
        [allPanels addObject:panel];
    }
    
    
    // create scroll view
    CGRect frame = CGRectMake(0, 0, 320, 568);
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    // add panel holder to scroll view
    [scrollView addSubview:holder];
    scrollView.contentSize = scrollView.frame.size;
    
    // add the scroll view and set the content size
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(320, panelHeight*numPanels);
    
    // call animateCards to initialize positions
    [self animateCards];

}


-(void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [self animateCards];
}


-(void)animateCards
{
    float scrollLoc = scrollView.contentOffset.y + self.view.frame.size.height * 0.5;
    float range = 600;
    
    for (int i=0; i<allPanels.count; i++)
    {
        CardView *panel = [allPanels objectAtIndex:i];
        float offset = panel.orgPos.y - scrollLoc;
        float dist = fabsf(offset);
        
        if (dist < range)
        {
            float ratio = (range - dist) / range;
            
            if (offset > 0)
            {
                float newRatio = 1.0 + ( (1.0 - ratio) * 1.0 );
                panel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(newRatio, newRatio), CGAffineTransformMakeTranslation(0, offset*0.4));
            }
            else
            {
                panel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(ratio, ratio), CGAffineTransformMakeTranslation(0, -offset*0.8));
                panel.alpha = ratio;
            }
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
