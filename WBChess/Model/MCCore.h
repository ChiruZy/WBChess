//
//  MCCore.h
//  WBChess
//
//  Created by Overloop on 2021/1/13.
//

#import <Foundation/Foundation.h>
#import "ChessModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCCore : NSObject

- (instancetype)initWithRootMap:(NSArray *)map chessType:(ChessType)type;

- (NSInteger)startCulInStep:(NSInteger)step;

@end

NS_ASSUME_NONNULL_END
