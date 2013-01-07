//
//  TileViewController.h
//  musicmap
//
//  Created by nashibao on 2012/12/29.
//
//

#import <UIKit/UIKit.h>

#import "TiledScrollView.h"

#import "TapDetectingView.h"

@interface TilePath : NSObject

@property (nonatomic) int row;
@property (nonatomic) int column;
@property (nonatomic) int resolution;

+ (TilePath *)tilePathForRow:(int)row column:(int)column resolution:(int)resolution;

@end

@interface TileViewController : UIViewController <TiledScrollViewDataSource, TapDetectingViewDelegate>

@property (strong, nonatomic) TiledScrollView *tiledScrollView;
@property (nonatomic) CGRect defaultFrame;
@property (nonatomic) float scale;

- (void)updateView;

- (id)dataForPath:(TilePath *)tilePath;

- (void)updateTile:(Tile *)tile tilePath:(TilePath *)tilePath withData:(id)data;


//サイズ
- (CGSize)tileSize;
- (CGSize)contentSize;
//数
- (int)tileRowCount;
- (int)tileColumnCount;

@end
