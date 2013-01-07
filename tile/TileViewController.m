//
//  TileViewController.m
//  musicmap
//
//  Created by nashibao on 2012/12/29.
//
//

#import "TileViewController.h"

@implementation TilePath

+ (TilePath *)tilePathForRow:(int)row column:(int)column resolution:(int)resolution{
    TilePath *tilePath = [[TilePath alloc] init];
    tilePath.row = row;
    tilePath.column = column;
    tilePath.resolution = resolution;
    return tilePath;
}

@end

@interface TileViewController ()

@end

@implementation TileViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.tiledScrollView = [[TiledScrollView alloc] init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaultFrame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.scale = 1.0f;
    self.tiledScrollView.height = self.view.height;
    self.tiledScrollView.width = self.view.width;
    [self.view addSubview:self.tiledScrollView];
    self.tiledScrollView.tileContainerView.delegate = self;
    [self updateView];
}

- (void)updateView{
    CGSize tileSize = [self tileSize];
    [self.tiledScrollView setTileSize:tileSize];
    [_tiledScrollView setMaximumResolution:0];
    [_tiledScrollView setMinimumResolution:-1];
    [_tiledScrollView setDataSource:self];
    [[_tiledScrollView tileContainerView] setDelegate:self];
    CGSize contentSize = [self contentSize];
    [_tiledScrollView reloadDataWithNewContentSize:contentSize];
}

- (Tile *)tiledScrollView:(TiledScrollView *)scrollView tileForRow:(int)row column:(int)column resolution:(int)resolution{
    if([self tileRowCount] <= row || [self tileColumnCount] <= column)
        return nil;
    
    Tile *tile = (Tile *)[self.tiledScrollView dequeueReusableTile];
    
    if (!tile) {
        CGSize tileSize = [self tileSize];
        tile = [[Tile alloc] initWithFrame:CGRectMake(0, 0, tileSize.width, tileSize.height)];
    }
    
    TilePath *path = [TilePath tilePathForRow:row column:column resolution:resolution];
    
    id data = [self dataForPath:path];
    
    [self updateTile:tile tilePath:path withData:data];
    
    return tile;
}

- (id)dataForPath:(TilePath *)tilePath{
    return nil;
}

- (void)updateTile:(Tile *)tile tilePath:(TilePath *)tilePath withData:(id)data{
    [tile.textLabel setText:[NSString stringWithFormat:@"%d,%d:%@", tilePath.row, tilePath.column, data]];
}

- (CGSize)tileSize{
    return CGSizeMake(300, 300);
}

- (CGSize)contentSize{
    CGSize tileSize = [self tileSize];
    return CGSizeMake(tileSize.width * [self tileColumnCount], tileSize.height * [self tileRowCount]);
}

//数
- (int)tileRowCount{
    return 0;
}

- (int)tileColumnCount{
    return 0;
}


//タップ
- (void)tapDetectingView:(TapDetectingView *)view gotSingleTapAtPoint:(CGPoint)tapPoint{
    return;
    int row = tapPoint.x / _tiledScrollView.tileSize.width;
    int column = tapPoint.y / _tiledScrollView.tileSize.height;
    CGSize tileSize = [self tileSize];
    [_tiledScrollView setContentOffset:CGPointMake(row*tileSize.width-_tiledScrollView.frame.size.width/2+tileSize.width/2
                                                   , column*tileSize.height-_tiledScrollView.frame.size.height/2+tileSize.height/2) animated:YES];
}

//だぶるタップ
- (void)tapDetectingView:(TapDetectingView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint{
    int row = tapPoint.x / _tiledScrollView.tileSize.width;
    int column = tapPoint.y / _tiledScrollView.tileSize.height;
    [_tiledScrollView spreadOutTilesFromRow:column column:row duration:0.8f];
}

//ピンチ
BOOL pinch_animating = NO;

- (void)tapDetectingView:(TapDetectingView *)view gotPinchGesture:(UIPinchGestureRecognizer *)recognizer{
    if(pinch_animating)
        return;
    pinch_animating = YES;
    float rate = 2.0f;
    if(recognizer.velocity>0){
        rate = 2.0f;
    }else{
        rate = 0.5f;
    }
    self.scale *= rate;
    CGRect oldrect = _tiledScrollView.frame;
    CGRect newrect = CGRectMake(oldrect.origin.x-oldrect.size.width*(rate - 1)/2, oldrect.origin.y-oldrect.size.height*(rate - 1)/2, oldrect.size.width*rate, oldrect.size.height*rate);
    [_tiledScrollView setFrame:newrect];
    CGPoint poi = CGPointMake(_tiledScrollView.contentOffset.x-oldrect.size.width*(rate - 1)/2, _tiledScrollView.contentOffset.y-oldrect.size.height*(rate - 1)/2);
    [_tiledScrollView setContentOffset:poi animated:NO];
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationCurveEaseInOut animations:^(void){
        _tiledScrollView.transform = CGAffineTransformScale( _tiledScrollView.transform, 1/rate,1/rate);
    }completion:^(BOOL finished){
        pinch_animating = NO;
    }];
}

@end
