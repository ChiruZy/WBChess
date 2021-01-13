//
//  MCTSNode.h
//  WBChess
//
//  Created by Overloop on 2021/1/13.
//

#import <Foundation/Foundation.h>
#import "ChessModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MCTSNode : NSObject
@property (nonatomic,strong) NSArray *mapNow;
@property (nonatomic,strong) NSMutableArray *didNextArr;
@property (nonatomic,strong) NSMutableArray *didnotNextArr;

@property (nonatomic,strong) MCTSNode *superNode;
@property (nonatomic,assign) BOOL isTerminal;

@property (nonatomic,assign) double accessNum;
@property (nonatomic,assign) double profit;

@property (nonatomic,assign) NSInteger chessType;
@property (nonatomic,assign) double UCB;
@property (nonatomic,assign) NSInteger ID;

- (instancetype)initWithSuperNode:(MCTSNode * __nullable)superNode map:(NSArray *)map chessType:(ChessType)type ID:(NSInteger)ID legalNext:(NSSet *)legalNext;

@end

NS_ASSUME_NONNULL_END
