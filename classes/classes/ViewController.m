//
//  ViewController.m
//  DMHorizontalSlider
//
//  Created by Dima Avvakumov on 14.12.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DMHorizontalSliderDataSource

- (NSInteger) numberOfColumnsInHorizontalSlider:(DMHorizontalSlider *)sliderView {
    return 100.0;
}

- (float) horizontalSlider:(DMHorizontalSlider *)sliderView widthAtColumn:(NSInteger)column {
    return 400.0;
}

- (DMHorizontalSliderCell *) horizontalSlider:(DMHorizontalSlider *)sliderView cellForColumn:(NSInteger)column {
    
    NSString *identifier = @"myIdentifier";
    SliderCellView *cell = (SliderCellView *) [sliderView dequeueReusableCellWithIdentifier: identifier];
    if (cell == nil) {
        cell = [[SliderCellView alloc] initWithReuseIdentifier:identifier];
    }
    [cell setTitle: [NSString stringWithFormat:@"Column - %d", column]];
    
    return cell;
}

@end
