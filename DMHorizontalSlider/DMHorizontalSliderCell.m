//
//  DMHorizontalSliderCell.m
//  formulaEastwind
//
//  Created by Dima Avvakumov on 11.10.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import "DMHorizontalSliderCell.h"

@implementation DMHorizontalSliderCell

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return nil;
}

- (id) initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithFrame: CGRectMake(0.0, 0.0, 300.0, 300.0)];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView {
    
}

@end
