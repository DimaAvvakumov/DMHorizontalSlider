//
//  ViewController.m
//  DMHorizontalSlider
//
//  Created by Dima Avvakumov on 14.12.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet DMHorizontalSlider *sliderView;


@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *identifier = @"myIdentifier";
    [_sliderView registerClass:[SliderCellView class] forCellReuseIdentifier:identifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [_sliderView reloadData];
    
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
    [cell setTitle: [NSString stringWithFormat:@"Column - %d", column]];
    
    return cell;
}

@end
