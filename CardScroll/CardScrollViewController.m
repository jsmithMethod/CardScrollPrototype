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
    NSMutableArray *allCards;
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
    int numCards = 10;
    float cardHeight = 568;
    allCards = [[NSMutableArray alloc] initWithCapacity:numCards];
    
    // configure the background color
    self.view.backgroundColor = [UIColor blackColor];
    
    
    // create holder to put all the cards in - this holder will go inside the scroll view
    float holderHeight = cardHeight * numCards;
    CGRect holderFrame = CGRectMake(0, 0, 320, holderHeight);
    UIView *holder = [[UIView alloc] initWithFrame:holderFrame];
    
    
    // create cards
    CGRect cardFrame = CGRectMake(0, 0, 320, cardHeight);
    
    for (int i=0; i<numCards; i++)
    {
        // adust vertical position and create card
        cardFrame.origin.y = i * cardHeight;
        CardView *card = [[CardView alloc] initWithFrame:cardFrame];
        
        // add tap recognizer to card
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCardTap:)];
        [card addGestureRecognizer:tapRecognizer];
        
        // get a unique cycling hue value for each card
        float hueRatio = (float)i / (float)numCards;
        card.backgroundColor = [UIColor colorWithHue:hueRatio saturation:1.0 brightness:1.0 alpha:1.0];
        
        // create a label to number the cards
        UILabel *label = [[UILabel alloc] initWithFrame:card.bounds];
        label.text = [NSString stringWithFormat:@"%i", i%10];
        label.textColor = [UIColor colorWithHue:hueRatio saturation:1.0 brightness:0.8 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:cardFrame.size.height];
        [card addSubview:label];
        
        // add card to the holder
        [holder addSubview:card];
        
        // add card to allCards array
        [allCards addObject:card];
    }
    
    
    // create scroll view
    CGRect frame = CGRectMake(0, 0, 320, 568);
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.pagingEnabled = YES  ;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    
    // add card holder to scroll view
    [scrollView addSubview:holder];
    scrollView.contentSize = scrollView.frame.size;
    
    // add the scroll view and set the content size
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(320, cardHeight*numCards);
    
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
    
    // transformations are CPU intensive, having a minimum range for transformations will help with performance
    float range = 600;
    
    for (int i=0; i<allCards.count; i++)
    {
        // get a reference to the current card
        CardView *card = [allCards objectAtIndex:i];
        
        // find the distance of the card to the center of the visible area
        float offset = card.orgCenter.y - scrollLoc;
        float dist = fabsf(offset);
        
        if (dist < range)
        {
            // the ratio tells us how far the card has traveled into our range
            float ratio = (range - dist) / range;
            
            if (offset > 0)
            {
                // motion applied if card is below the center
                float newRatio = 1.0 + ( (1.0 - ratio) * 1.0 );
                card.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(newRatio, newRatio), CGAffineTransformMakeTranslation(0, offset*0.4));
            }
            else
            {
                // motion applied if card is above the center
                card.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(ratio, ratio), CGAffineTransformMakeTranslation(0, -offset*0.8));
                card.alpha = ratio;
            }
            
        }
    }
}

-(void)onCardTap:(UITapGestureRecognizer *)recognizer
{
    // get refrence to tapped card
    CardView *card = (CardView *)recognizer.view;
    
    // set content offset of scroll view to the original frame position of the tapped card
    [scrollView setContentOffset:card.orgFrame.origin animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
