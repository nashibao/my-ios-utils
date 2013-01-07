//
//  Tile.m
//  musicmap
//
//  Created by shibao na on 11/09/05.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Tile.h"

@implementation Tile

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.textLabel = [[UILabel alloc] initWithFrame:frame];
        self.textLabel.height = frame.size.height - 4;
        self.textLabel.width = frame.size.width - 4;
        [self.textLabel setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.textLabel];
    }
    return self;
}

@end
