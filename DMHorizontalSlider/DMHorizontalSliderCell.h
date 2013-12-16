//
//  DMHorizontalSliderCell.h
//  formulaEastwind
//
//  Created by Dima Avvakumov on 11.10.13.
//  Copyright (c) 2013 East-Media Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMHorizontalSliderCell : UIView

@property (strong, nonatomic) NSString *identifier;

- (id) initWithReuseIdentifier: (NSString *) identifier;
- (void) initView;

@end
