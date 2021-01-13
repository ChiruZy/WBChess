//
//  ChessCell.h
//  WBChess
//
//  Created by Overloop on 2020/12/25.
//

#import <UIKit/UIKit.h>
#import "ChessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChessCell : UICollectionViewCell
- (void)setChessType:(ChessType)type isNew:(BOOL)isNew canFall:(BOOL)canFall;
@end

NS_ASSUME_NONNULL_END
