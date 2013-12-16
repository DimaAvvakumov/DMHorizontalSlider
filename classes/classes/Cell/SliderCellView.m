//
//  SliderCellView.m
//  DMHorizontalSlider
//
//  Created by Dima Avvakumov on 14.12.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "SliderCellView.h"

@interface SliderCellView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SliderCellView

- (id)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithReuseIdentifier:identifier];
    if (self) {
        // bind views
        UIView *mainView = [[[NSBundle mainBundle] loadNibNamed:@"SliderCellView" owner:self options:nil] objectAtIndex:0];
        CGRect mainFrame = CGRectZero;
        mainFrame.size = self.frame.size;
        [mainView setFrame: mainFrame];
        [self addSubview:mainView];
        
    }
    return self;
}

- (void) setTitle: (NSString *) text {
    [_titleLabel setText:text];
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
