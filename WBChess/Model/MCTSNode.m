//
//  MCTSNode.m
//  WBChess
//
//  Created by Overloop on 2021/1/13.
//

#import "MCTSNode.h"
#define NSLog(FORMAT, ...) printf("%s", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
@implementation MCTSNode

- (instancetype)initWithSuperNode:(MCTSNode * __nullable)superNode map:(NSArray *)map chessType:(ChessType)type ID:(NSInteger)ID legalNext:(NSSet *)legalNext{
    if (self = [super init]){
        _mapNow = map;
        _chessType = type;
        _ID = ID;
        _superNode = superNode;
        _didNextArr = @[].mutableCopy;
        _didnotNextArr = [legalNext allObjects].mutableCopy;
        
        _accessNum = 0;
        _profit = 0;
        _isTerminal = _didnotNextArr.count == 0;
        
//        [self printMap:map];
    }
    return self;
}

#pragma mark - private
- (double)UCB{
    return (_profit / _accessNum) + 1 / sqrt(2) * sqrt(2 * log(self.superNode.accessNum) / _accessNum);
}

//- (void)printMap:(NSArray *)map{
//    for (int i=0; i<8; i++) {
//        for (int j=0; j<8; j++) {
//            if ([map[i][j] isEqual:@(2)]) {
//                NSLog(@"  ");
//                continue;
//            }
//            NSLog(@"%@ ",map[i][j]);
//        }
//        NSLog(@"\n");
//    }
//    NSLog(@"\n");
//}
@end
