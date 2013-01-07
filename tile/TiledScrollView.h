
/*
     File: TiledScrollView.h
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

#import "Tile.h"

@class TapDetectingView;

@protocol TiledScrollViewDataSource;

@interface TiledScrollViewObject : NSObject

@property(nonatomic)float scaledTileWidth;
@property(nonatomic)float scaledTileHeight;
@property(nonatomic)int maxRow;
@property(nonatomic)int maxCol;
@property(nonatomic)int firstNeededRow;
@property(nonatomic)int firstNeededCol;
@property(nonatomic)int lastNeededRow;
@property(nonatomic)int lastNeededCol;

@end


@interface TiledScrollView : UIScrollView <UIScrollViewDelegate> {
    int                              resolution;
    // we use the following ivars to keep track of which rows and columns are visible
    int firstVisibleRow, firstVisibleColumn, lastVisibleRow, lastVisibleColumn;
    BOOL _animating;
}


@property (strong, nonatomic) NSMutableSet *reusableTiles;
@property (strong, nonatomic) NSMutableDictionary *usingTiles;
@property (nonatomic, weak) id <TiledScrollViewDataSource> dataSource;
@property (nonatomic) CGSize tileSize;
@property (nonatomic) CGSize visibleOffset;
@property (nonatomic, strong) TapDetectingView *tileContainerView;
@property (nonatomic) int minimumResolution;
@property (nonatomic) int maximumResolution;

- (NSString *)keyForRow:(int)row column:(int)column;
- (UIView *)dequeueReusableTile;  // Used by the delegate to acquire an already allocated tile, in lieu of allocating a new one.
- (void)reloadData;
- (void)reloadDataWithNewContentSize:(CGSize)size;

//拡散するアニメーション
- (void)spreadOutTilesFromRow:(NSInteger)row column:(NSInteger)column duration:(NSTimeInterval)duration;

//集まってくるアニメーション
- (void)spreadInTilesFromRow:(NSInteger)row column:(NSInteger)column duration:(NSTimeInterval)duration;

@end


@protocol TiledScrollViewDataSource <NSObject>

@required
- (Tile *)tiledScrollView:(TiledScrollView *)scrollView tileForRow:(int)row column:(int)column resolution:(int)resolution;

@optional
- (void)tiledScrollViewDidSpreadIn:(TiledScrollView *)scrollView;
- (void)removedTiledScrollView:(TiledScrollView *)scrollView tile:(UIView *)tile;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

@end


