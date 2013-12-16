//
//  DMHorizontalSlider.m
//  DMHorizontalSlider
//
//  Created by Dima Avvakumov on 11.10.13.
//  Copyright (c) 2013 Dima Avvakumov. All rights reserved.
//

#import "DMHorizontalSlider.h"

@interface DMHorizontalSlider()

@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger countItems;
@property (strong, nonatomic) NSMutableArray *widthForColumn;
@property (strong, nonatomic) NSMutableArray *offsetForColumn;
@property (assign, nonatomic) float maxOffset;

@property (assign, nonatomic) float minOffsetForChange;
@property (assign, nonatomic) float maxOffsetForChange;

@property (strong, nonatomic) NSMutableDictionary *lastVisibleCells;
@property (strong, nonatomic) NSMutableDictionary *dequeuePool;

@end

@implementation DMHorizontalSlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void) initView {
    // add observer
    [self addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:nil];
    
    // add scroll view
    CGRect scrollFrame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setShowsHorizontalScrollIndicator: YES];
    [_scrollView setShowsVerticalScrollIndicator: NO];
    [self addSubview: _scrollView];
    
    // init
    [self reset];
    
    self.lastVisibleCells = [NSMutableDictionary dictionaryWithCapacity:5];
    self.dequeuePool = [NSMutableDictionary dictionaryWithCapacity:1];
    self.minOffsetForChange = 0.0;
    self.maxOffsetForChange = 0.0;
}

- (void) dealloc {
    [self removeObserver:self forKeyPath:@"delegate"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"delegate"]) {
        [self reloadData];
    }
}

#pragma mark - Inset methods

- (void) setContentInset: (UIEdgeInsets) inset {
    [_scrollView setContentInset:inset];
}

- (UIEdgeInsets) contentInset {
    return _scrollView.contentInset;
}

#pragma mark - Reload methods

- (void) reset {
    self.countItems = 0;
    
    [self removeAllVisibleCells];
}

- (void) reloadData {
    [self reset];
    
    if (_delegate == nil) {
        return;
    }
    
    // reset items count
    self.countItems = [_delegate numberOfColumnsInHorizontalSlider: self];
    
    // reset column width
    float widthOffset = 0.0;
    self.widthForColumn = [NSMutableArray arrayWithCapacity: _countItems];
    self.offsetForColumn = [NSMutableArray arrayWithCapacity: _countItems];
    for (NSInteger i = 0; i < _countItems; i++) {
        float w = [_delegate horizontalSlider:self widthAtColumn:i];
        [_widthForColumn addObject: [NSNumber numberWithFloat:w]];
        [_offsetForColumn addObject: [NSNumber numberWithFloat:widthOffset]];
        
        widthOffset += w;
    }
    self.maxOffset = widthOffset;
    
    self.minOffsetForChange = 0.0;
    self.maxOffsetForChange = 0.0;
    
    [self updateSlider];
}

- (void) removeAllVisibleCells {
    // remove old cells
    NSArray *visibleKeys = [_lastVisibleCells allKeys];
    for (NSString *cellKey in visibleKeys) {
        [self putCellToDequeue: cellKey];
    }
}

- (void) updateSlider {
    if (_delegate == nil) return;
    
    float offset = _scrollView.contentOffset.x + _scrollView.contentInset.left;
    
    if (offset < 0.0) return;
    if (offset > _maxOffset) return;
    
    if (offset > _minOffsetForChange && offset < _maxOffsetForChange) return;
    
    float scrollWidth = self.frame.size.width;
    
    NSInteger firstVisibleColumn = [self columnByOffset:offset];
    NSInteger lastVisibleColumn = [self columnByOffset:(offset + scrollWidth)];
    
    // compute range
    float minFirstOffset = [[_offsetForColumn objectAtIndex:firstVisibleColumn] floatValue];
    float minLastOffset = [[_offsetForColumn objectAtIndex:lastVisibleColumn] floatValue] - scrollWidth;
    float minOffset = MAX(minFirstOffset, minLastOffset);
    
    float maxFirstOffset = minFirstOffset + [[_widthForColumn objectAtIndex:firstVisibleColumn] floatValue];
    float maxLastOffset = minLastOffset + [[_widthForColumn objectAtIndex:lastVisibleColumn] floatValue];
    float maxOffset = MIN(maxFirstOffset, maxLastOffset);
    
    self.minOffsetForChange = minOffset;
    self.maxOffsetForChange = maxOffset;
    
    // remove old cells
    NSArray *visibleKeys = [_lastVisibleCells allKeys];
    for (NSString *cellKey in visibleKeys) {
        NSInteger cellIndex = [cellKey integerValue];
        
        if (cellIndex < firstVisibleColumn || cellIndex > lastVisibleColumn) {
            [self putCellToDequeue: cellKey];
        }
    }
    
    // add new cells
    for (int i = firstVisibleColumn; i <= lastVisibleColumn; i++) {
        NSString *cellKey = [NSString stringWithFormat:@"%d", i];
        if ([_lastVisibleCells objectForKey:cellKey]) {
            continue;
        }
        
        DMHorizontalSliderCell *cell = [_delegate horizontalSlider:self cellForColumn:i];
        [_lastVisibleCells setObject:cell forKey:cellKey];

        float offsetX = [[_offsetForColumn objectAtIndex: i] floatValue];
        float w = [[_widthForColumn objectAtIndex: i] floatValue];
        CGRect cellFrame = CGRectMake(offsetX, 0.0, w, self.frame.size.height);
        [cell setFrame:cellFrame];
        
        [_scrollView addSubview: cell];
    }
    
    // expand scroll size
    [_scrollView setContentSize:CGSizeMake(_maxOffset, self.frame.size.height)];
}

- (NSInteger) columnByOffset: (float) offset {
    NSInteger column = 0;
    for (NSInteger i = 0; i < _countItems; i++) {
        float columnOffset = [[_offsetForColumn objectAtIndex: i] floatValue];
        float columnWidth  = [[_widthForColumn objectAtIndex: i] floatValue];
        
        if ((columnOffset + columnWidth) > offset) {
            return i;
        }
        
        column = i;
    }
    return column;
}

#pragma mark - Dequeue methods

- (void) putCellToDequeue: (NSString *) cellKey {
    // take cell view
    DMHorizontalSliderCell *cell = [_lastVisibleCells objectForKey:cellKey];
    
    // remove from scene
    [cell removeFromSuperview];
    
    // put to pool
    NSString *identifier = cell.identifier;
    NSMutableArray *cellList = [_dequeuePool objectForKey:identifier];
    if (cellList == nil) {
        cellList = [NSMutableArray arrayWithCapacity: 5];
        [_dequeuePool setObject:cellList forKey:identifier];
    }
    [cellList addObject:cell];
    
    // remove from visible list
    [_lastVisibleCells removeObjectForKey:cellKey];
}

- (DMHorizontalSliderCell *) dequeueReusableCellWithIdentifier: (NSString *) identifier {
    NSMutableArray *cellList = [_dequeuePool objectForKey:identifier];
    if (cellList == nil) return nil;
    if ([cellList count] == 0) return nil;
    
    DMHorizontalSliderCell *cell = [cellList lastObject];
    [cellList removeLastObject];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateSlider];
}

@end
