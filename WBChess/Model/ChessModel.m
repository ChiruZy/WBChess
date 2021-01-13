//
//  ChessModel.m
//  WBChess
//
//  Created by Overloop on 2020/12/26.
//

#import "ChessModel.h"


@implementation ChessModel
#pragma mark - init
- (instancetype)init{
    if (self = [super init]) {
        _map = nil;
        self.bow = arc4random()%2;
        self.map[3][3] = @0;
        self.map[3][4] = @1;
        self.map[4][3] = @1;
        self.map[4][4] = @0;
        [self updateMap];
    }
    return self;
}

#pragma mark - instance method
- (ChessType)getChessTypeWithRow:(NSUInteger)row col:(NSUInteger)col{
    return [self.map[row][col] intValue];
}

- (ChessType)getChessTypeWithID:(NSUInteger)ID{
    NSUInteger row = ID / 8;
    NSUInteger col = ID % 8;
    return [self getChessTypeWithRow:row col:col];
}

- (void)updateMap{
    _fallSet = [ChessModel getFallSet:_map currentType:_bow];
    [self countChess];
}

- (void)continueFall{
    _bow = (_bow+1)%2;
    [self updateMap];
}

- (void)fallWithID:(NSUInteger)ID{
    [ChessModel fall:_map ID:ID currentType:_bow];
    _bow = (_bow+1)%2;
    [self updateMap];
}

- (void)countChess{
    _blackCount = 0;
    _whiteCount = 0;
    for (int row = 0; row < 8 ; row ++)
        for (int col = 0; col < 8; col ++)
            if ([_map[row][col] intValue] == Black)    _blackCount ++;
            else if ([_map[row][col] intValue] == White) _whiteCount ++;
}

#pragma mark - Class Method
+ (NSSet *)getFallSet:(NSArray*)map currentType:(NSInteger)bow{
    NSMutableSet *set = [NSMutableSet new];
    NSArray *stepArr = @[@[@1, @0], @[@1, @1], @[@1, @-1], @[@0, @1], @[@0, @-1], @[@-1, @0], @[@-1, @1], @[@-1, @-1]];
    for (int row = 0; row < 8 ; row ++){
        for (int col = 0; col < 8; col ++) {
            if ([map[row][col] intValue] != 2) continue;;
            for (int i = 0; i < 8; i++) {
                NSArray *step = stepArr[i];
                NSInteger nextRow = row;
                NSInteger nextCol = col;
                BOOL crossed = NO;
                BOOL found = NO;
                while (1) {
                    nextRow += [step[0] intValue];
                    nextCol += [step[1] intValue];
                    
                    // 超出边界返回
                    if (nextCol >= 8 || nextRow >= 8 || nextCol <0 || nextRow < 0)
                        break;
                    // 没有对应棋子返回
                    NSInteger nextType = [map[nextRow][nextCol] intValue];
                    if (nextType >=2 || (nextType == bow && !crossed))
                        break;
                    
                    if (nextType == bow && crossed) {
                        found = YES;
                        break;
                    }else if (nextType == (bow + 1) % 2){
                        crossed = YES;
                    }
                }
                if (found)  {
                    [set addObject:@(row * 8 + col)];
                    break;
                }
            }
        }
    }
    return [set copy];
}

+(void)fall:(NSMutableArray *)map row:(NSUInteger)row col:(NSUInteger)col currentType:(NSInteger)bow{
    NSArray *stepArr = @[@[@1, @0], @[@1, @1], @[@1, @-1], @[@0, @1], @[@0, @-1], @[@-1, @0], @[@-1, @1], @[@-1, @-1]];
    for (int i = 0; i<8; i++) {
        NSArray *step = stepArr[i];
        NSInteger nextRow = row;
        NSInteger nextCol = col;
        BOOL crossed = NO;
        NSMutableArray *routes = @[].mutableCopy;
        while (1) {
            [routes addObject:@(nextRow * 8 + nextCol)];
            nextRow += [step[0] intValue];
            nextCol += [step[1] intValue];
            if (nextCol >= 8 || nextRow >= 8 || nextCol <0 || nextRow < 0)
                break;
            NSInteger nextType = [map[nextRow][nextCol] intValue];
            if (nextType >=2 || (nextType == bow && !crossed))
                break;
            
            if (nextType == bow && crossed) {
                for (NSNumber *route in routes) {
                    map[[route intValue]/8][[route intValue]%8] = @(bow);
                }
                break;
            }else if (nextType == (bow + 1) % 2){
                crossed = YES;
            }
        }
    }
}


+ (void)fall:(NSMutableArray*)map ID:(NSInteger)ID currentType:(NSInteger)bow{
    [ChessModel fall:map row:ID / 8 col:ID%8 currentType:bow];
}

#pragma mark - lazyload
- (NSArray *)map{
    if (!_map){
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < 8; i++) {
            [temp addObject:@[@2,@2,@2,@2,@2,@2,@2,@2].mutableCopy];
        }
        _map = temp.copy;
    }
    return _map;
}

@end
