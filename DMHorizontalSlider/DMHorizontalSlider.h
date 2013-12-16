//
//  DMHorizontalSlider.h
//  DMHorizontalSlider
//
//  Created by Dima Avvakumov on 11.10.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMHorizontalSliderCell.h"

@class DMHorizontalSlider;
@protocol DMHorizontalSliderDelegate <NSObject>

- (NSInteger) numberOfColumnsInHorizontalSlider: (DMHorizontalSlider *) sliderView;
- (float) horizontalSlider: (DMHorizontalSlider *) sliderView widthAtColumn: (NSInteger) column;
- (DMHorizontalSliderCell *) horizontalSlider: (DMHorizontalSlider *) sliderView cellForColumn: (NSInteger) column;

@end

@interface DMHorizontalSlider : UIView <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet id<DMHorizontalSliderDelegate> delegate;

#pragma mark - Inset methods
- (void) setContentInset: (UIEdgeInsets) inset;
- (UIEdgeInsets) contentInset;

#pragma mark - Reload methods
- (void) reloadData;

#pragma mark - Dequeue methods
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (DMHorizontalSliderCell *) dequeueReusableCellWithIdentifier: (NSString *) identifier;

@end
