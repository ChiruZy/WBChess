//
//  ChessViewLayout.m
//  WBChess
//
//  Created by Overloop on 2020/12/25.
//

#import "ChessViewLayout.h"

@implementation ChessViewLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    float width = (self.collectionView.bounds.size.width - 7)/8;
    self.itemSize = CGSizeMake(width, width);
    self.minimumLineSpacing = 1;
    self.minimumInteritemSpacing = 1;
}


@end
