//
//  ChessCell.m
//  WBChess
//
//  Created by Overloop on 2020/12/25.
//

#import "ChessCell.h"

@interface ChessCell()
@property (weak, nonatomic) IBOutlet UIImageView *chess;


@end

@implementation ChessCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setChessType:(ChessType)type isNew:(BOOL)isNew canFall:(BOOL)canFall{
    switch (type) {
        case White:
            [self.chess setImage:[UIImage imageNamed:(isNew ? @"whiteNew" : @"whiteChess")]];
            break;
        case Black:
            [self.chess setImage:[UIImage imageNamed:(isNew ? @"blackNew" : @"blackChess")]];
            break;
        case Blank:
            [self.chess setImage:canFall?[UIImage imageNamed:@"greenPoint"]:nil];
            break;
    }
}
@end
