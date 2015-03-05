//
//  ViewController.m
//  CardScroll
//
//  Created by Jason Smith on 8/6/14.
//  Copyright (c) 2014 Method. All rights reserved.
//

#import "ViewController.h"
#import "CardScrollViewController.h"


@interface ViewController ()
{
    CardScrollViewController *cardScroll;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    cardScroll = [[CardScrollViewController alloc] init];
    cardScroll.view.frame = self.view.bounds;
    [self.view addSubview:cardScroll.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
