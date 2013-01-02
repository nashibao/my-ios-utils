
/*
     File: TiledScrollView.m
 Abstract: UIScrollView subclass to manage tiled content.
 
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <QuartzCore/QuartzCore.h>
#import "TiledScrollView.h"
#import "TapDetectingView.h"
#define DEFAULT_TILE_SIZE 500

@implementation TiledScrollViewObject

@end

@interface TiledScrollView ()
- (void)updateResolution;
@end

@implementation TiledScrollView

@synthesize minimumResolution = _minimumResolution;
@synthesize maximumResolution = _maximumResolution;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.reusableTiles = [[NSMutableSet alloc] init];
        self.usingTiles = [[NSMutableDictionary alloc] init];
        self.tileContainerView = [[TapDetectingView alloc] initWithFrame:CGRectZero];
        [self.tileContainerView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.tileContainerView];
        [self setTileSize:CGSizeMake(DEFAULT_TILE_SIZE, DEFAULT_TILE_SIZE)];
        
        firstVisibleRow = firstVisibleColumn = NSIntegerMax;
        lastVisibleRow  = lastVisibleColumn  = NSIntegerMin;
        
        [super setDelegate:self];
    }
    return self;
}

- (NSString *)keyForRow:(int)row column:(int)column{
    return [NSString stringWithFormat:@"%d:%d", row, column];
}

// we don't synthesize our minimum/maximum resolution accessor methods because we want to police the values of these ivars
- (int)minimumResolution { return _minimumResolution; }
- (int)maximumResolution { return _maximumResolution; }
- (void)setMinimumResolution:(int)res { _minimumResolution = MIN(res, 0); } // you can't have a minimum resolution greater than 0
- (void)setMaximumResolution:(int)res { _maximumResolution = MAX(res, 0); } // you can't have a maximum resolution less than 0

- (UIView *)dequeueReusableTile {
    UIView *tile = [_reusableTiles anyObject];
    if (tile) {
        [_reusableTiles removeObject:tile];
    }
    return tile;
}

- (void)reloadData {
    for (UIView *view in [self.tileContainerView subviews]) {
        [_reusableTiles addObject:view];
        [view removeFromSuperview];
    }
    
    firstVisibleRow = firstVisibleColumn = NSIntegerMax;
    lastVisibleRow  = lastVisibleColumn  = NSIntegerMin;
    
    [self setNeedsLayout];
}

- (void)reloadDataWithNewContentSize:(CGSize)size {
    
    [self setZoomScale:1.0];
    [self setMinimumZoomScale:1.0];
    [self setMaximumZoomScale:1.0];
    resolution = 0;
    
    [self setContentSize:size];
    
    [self.tileContainerView setFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [self reloadData];
}


- (CGRect)getVisiBleBounds{
    CGRect visibleBounds;
    if(_visibleOffset.width>1)
        visibleBounds = CGRectMake([self bounds].origin.x-_visibleOffset.width, [self bounds].origin.y-_visibleOffset.height, [self bounds].size.width+2*_visibleOffset.width, [self bounds].size.height+2*_visibleOffset.height);
    else
        visibleBounds = [self bounds];
    
    return visibleBounds;
}

- (void)removeExistTiles:(CGRect)visibleBounds{
    for (Tile *tile in [self.tileContainerView subviews]) {
        
        // We want to see if the tiles intersect our (i.e. the scrollView's) bounds, so we need to convert their
        // frames to our own coordinate system
        CGRect scaledTileFrame = [self.tileContainerView convertRect:[tile frame] toView:self];
        
        // If the tile doesn't intersect, it's not visible, so we can recycle it
        if (! CGRectIntersectsRect(scaledTileFrame, visibleBounds)) {
            [_reusableTiles addObject:tile];
            if([_dataSource respondsToSelector:@selector(removedTiledScrollView:tile:)])
                [_dataSource removedTiledScrollView:self tile:tile];
            [tile removeFromSuperview];
            [_usingTiles removeObjectForKey:[self keyForRow:tile.row column:tile.column]];
        }
    }
}


- (TiledScrollViewObject *)currentScrollViewObject:(CGRect)visibleBounds{
    TiledScrollViewObject *obj = [[TiledScrollViewObject alloc] init];
    // calculate which rows and columns are visible by doing a bunch of math.
    obj.scaledTileWidth  = [self tileSize].width  * [self zoomScale];
    obj.scaledTileHeight = [self tileSize].height * [self zoomScale];
    obj.maxRow = floorf([_tileContainerView frame].size.height / obj.scaledTileHeight); // this is the maximum possible row
    obj.maxCol = floorf([_tileContainerView frame].size.width  / obj.scaledTileWidth);  // and the maximum possible column
    obj.firstNeededRow = MAX(0, floorf(visibleBounds.origin.y / obj.scaledTileHeight));
    obj.firstNeededCol = MAX(0, floorf(visibleBounds.origin.x / obj.scaledTileWidth));
    obj.lastNeededRow  = MIN(obj.maxRow, floorf(CGRectGetMaxY(visibleBounds) / obj.scaledTileHeight));
    obj.lastNeededCol  = MIN(obj.maxCol, floorf(CGRectGetMaxX(visibleBounds) / obj.scaledTileWidth));
    
    //    新しく画面に追加する
    for (int row = obj.firstNeededRow; row <= obj.lastNeededRow; row++) {
        for (int col = obj.firstNeededCol; col <= obj.lastNeededCol; col++) {
            
            BOOL tileIsMissing = (firstVisibleRow > row || firstVisibleColumn > col ||
                                  lastVisibleRow  < row || lastVisibleColumn  < col);
            
            if (tileIsMissing) {
                Tile *tile = [_dataSource tiledScrollView:self tileForRow:row column:col resolution:resolution];
                // set the tile's frame so we insert it at the correct position
                if(!tile)
                    continue;
                CGRect frame = CGRectMake([self tileSize].width * col, [self tileSize].height * row, [self tileSize].width, [self tileSize].height);
                [tile setFrame:frame];
                [_tileContainerView addSubview:tile];
                [tile setRow:row];
                [tile setColumn:col];
                [tile setCorrectFrame:frame];
                _usingTiles[[self keyForRow:row column:col]] = tile;
            }
        }
    }
    
    //    updateする
    firstVisibleRow = obj.firstNeededRow; firstVisibleColumn = obj.firstNeededCol;
    lastVisibleRow  = obj.lastNeededRow;  lastVisibleColumn  = obj.lastNeededCol;
    
    return obj;
}

/***********************************************************************************/
/* Most of the work of tiling is done in layoutSubviews, which we override here.   */
/* We recycle the tiles that are no longer in the visible bounds of the scrollView */
/* and we add any tiles that should now be present but are missing.                */
/***********************************************************************************/
- (void)layoutSubviews {
    
//    アニメーション中はlayoutしない
    if(_animating)return;
    
    [super layoutSubviews];
    
    CGRect visibleBounds = [self getVisiBleBounds];
    
//    すでにあるタイルが範囲内かどうかを調べる
    [self removeExistTiles:visibleBounds];
    
    
    [self currentScrollViewObject:visibleBounds];
    
}

- (void)spreadOutTilesFromRow:(NSInteger)row column:(NSInteger)column duration:(NSTimeInterval)duration{
    _animating=YES;
    
    CGRect visibleBounds = [self getVisiBleBounds];
    [self currentScrollViewObject:visibleBounds];
    
    Tile *selectedTile = _usingTiles[[self keyForRow:row column:column]];
    
//    中心
    CGRect newframe = CGRectMake([self tileSize].width*column, [self tileSize].height*row, [self tileSize].width, [self tileSize].height);
    [UIView animateWithDuration:duration animations:^{
        for (Tile *tile in [_tileContainerView subviews]) {
            if(tile != selectedTile)
                [tile setAlpha:0.0f];
        }
    } completion:^(BOOL finished) {
    //    真ん中に集めてから
        for (Tile *tile in [_tileContainerView subviews]) {
            [tile setFrame:newframe];
            [tile setAlpha:1.0f];
        }
    //    拡散する
        [UIView animateWithDuration:duration animations:^(void){
            for (Tile *tile in [_tileContainerView subviews]) {
                [tile setFrame:tile.correctFrame];
            }
        }completion:^(BOOL finished){
            _animating=NO;
        }];
            
    }];
}

- (void)spreadInTilesFromRow:(NSInteger)row column:(NSInteger)column duration:(NSTimeInterval)duration{
    _animating=YES;
    CGRect visibleBounds = [self getVisiBleBounds];
    [self currentScrollViewObject:visibleBounds];
    
//    中心
    CGRect newframe = CGRectMake([self tileSize].width*column, [self tileSize].height*row, [self tileSize].width, [self tileSize].height);
    
    [UIView animateWithDuration:duration animations:^(void){
        for (Tile *tile in [_tileContainerView subviews]) {
            [tile setFrame:newframe];
        }
    }completion:^(BOOL finished){
        _animating=NO;
        if([_dataSource respondsToSelector:@selector(tiledScrollViewDidSpreadIn:)])
            [_dataSource tiledScrollViewDidSpreadIn:self];
    }];
}


/*****************************************************************************************/
/* The following method handles changing the resolution of our tiles when our zoomScale  */
/* gets below 50% or above 100%. When we fall below 50%, we lower the resolution 1 step, */
/* and when we get above 100% we raise it 1 step. The resolution is stored as a power of */
/* 2, so -1 represents 50%, and 0 represents 100%, and so on.                            */
/*****************************************************************************************/
- (void)updateResolution {
    
    // delta will store the number of steps we should change our resolution by. If we've fallen below
    // a 25% zoom scale, for example, we should lower our resolution by 2 steps so delta will equal -2.
    // (Provided that lowering our resolution 2 steps stays within the limit imposed by minimumResolution.)
    int delta = 0;
    
    // check if we should decrease our resolution
    for (int thisResolution = _minimumResolution; thisResolution < resolution; thisResolution++) {
        int thisDelta = thisResolution - resolution;
        // we decrease resolution by 1 step if the zoom scale is <= 0.5 (= 2^-1); by 2 steps if <= 0.25 (= 2^-2), and so on
        float scaleCutoff = pow(2, thisDelta); 
        if ([self zoomScale] <= scaleCutoff) {
            delta = thisDelta;
            break;
        } 
    }
    
    // if we didn't decide to decrease the resolution, see if we should increase it
    if (delta == 0) {
        for (int thisResolution = _maximumResolution; thisResolution > resolution; thisResolution--) {
            int thisDelta = thisResolution - resolution;
            // we increase by 1 step if the zoom scale is > 1 (= 2^0); by 2 steps if > 2 (= 2^1), and so on
            float scaleCutoff = pow(2, thisDelta - 1); 
            if ([self zoomScale] > scaleCutoff) {
                delta = thisDelta;
                break;
            } 
        }
    }
    
    if (delta != 0) {
        resolution += delta;
        
        // if we're increasing resolution by 1 step we'll multiply our zoomScale by 0.5; up 2 steps multiply by 0.25, etc
        // if we're decreasing resolution by 1 step we'll multiply our zoomScale by 2.0; down 2 steps by 4.0, etc
        float zoomFactor = pow(2, delta * -1); 
        
        // save content offset, content size, and tileContainer size so we can restore them when we're done
        // (contentSize is not equal to containerSize when the container is smaller than the frame of the scrollView.)
        CGPoint contentOffset = [self contentOffset];   
        CGSize  contentSize   = [self contentSize];
        CGSize  containerSize = [_tileContainerView frame].size;
        
        // adjust all zoom values (they double as we cut resolution in half)
        [self setMaximumZoomScale:[self maximumZoomScale] * zoomFactor];
        [self setMinimumZoomScale:[self minimumZoomScale] * zoomFactor];
        [super setZoomScale:[self zoomScale] * zoomFactor];
        
        // restore content offset, content size, and container size
        [self setContentOffset:contentOffset];
        [self setContentSize:contentSize];
        [_tileContainerView setFrame:CGRectMake(0, 0, containerSize.width, containerSize.height)];
        
        // throw out all tiles so they'll reload at the new resolution
        [self reloadData];        
    }        
}
        
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _tileContainerView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    if (scrollView == self) {
        
        // the following two lines are a bug workaround that will no longer be needed after OS 3.0.
        [super setZoomScale:scale+0.01 animated:NO];
        [super setZoomScale:scale animated:NO];
        
        // after a zoom, check to see if we should change the resolution of our tiles
        [self updateResolution];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if([_dataSource respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        [_dataSource scrollViewWillBeginDecelerating:scrollView];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([_dataSource respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [_dataSource scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([_dataSource respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [_dataSource scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if([_dataSource respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        [_dataSource scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([_dataSource respondsToSelector:@selector(scrollViewDidScroll:)])
        [_dataSource scrollViewDidScroll:scrollView];
}

#pragma mark UIScrollView overrides

// the scrollViewDidEndZooming: delegate method is only called after an *animated* zoom. We also need to update our 
// resolution for non-animated zooms. So we also override the new setZoomScale:animated: method on UIScrollView
- (void)setZoomScale:(float)scale animated:(BOOL)animated {
    [super setZoomScale:scale animated:animated];
    
    // the delegate callback will catch the animated case, so just cover the non-animated case
    if (!animated) {
        [self updateResolution];
    }
}

// We override the setDelegate: method because we can't manage resolution changes unless we are our own delegate.
- (void)setDelegate:(id)delegate {
    NSLog(@"You can't set the delegate of a TiledZoomableScrollView. It is its own delegate.");
}

@end
