//
//  MCCore.m
//  WBChess
//
//  Created by Overloop on 2021/1/13.
//

#import "MCCore.h"
#import "MCTSNode.h"

#define NSLog(FORMAT, ...) printf("%s", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

@interface MCCore()
@property (nonatomic,strong) MCTSNode *root;

@end

@implementation MCCore

- (instancetype)initWithRootMap:(NSArray *)map chessType:(ChessType)type{
    if(self = [super init]){
        _root = [[MCTSNode alloc]initWithSuperNode:nil map:map chessType:type ID:0 legalNext:[ChessModel getFallSet:map currentType:type]];
    }
    return self;
}

- (NSInteger)startCulInStep:(NSInteger)step{
    if (self.root.didnotNextArr.count == 1) return [self.root.didnotNextArr[0] intValue];
    for (int i = 0; i< step; i++){
        MCTSNode *endNode = [self selectPolicy:self.root];
        NSInteger gain = [self simulatePolicy:endNode];
        [self backPropagateWithGain:gain endNode:endNode];
    }
    return [self UCB1:self.root].ID;
}

#pragma mark - private
- (NSMutableArray *)deepCopyMap:(NSArray *)map{
    NSMutableArray *new = [NSMutableArray new];
    for (int i = 0; i<8; i++)
        [new addObject: [map[i] mutableCopy]];
    return new;
}


- (MCTSNode *)createNodeWithSuperNode:(MCTSNode *)superNode ID:(NSInteger)ID{
    NSMutableArray *newMap = [self deepCopyMap: superNode.mapNow];
    [ChessModel fall:newMap ID:ID currentType:superNode.chessType];
    
    NSInteger newBow = (superNode.chessType + 1) % 2;
    NSSet *set = [ChessModel getFallSet:newMap currentType:newBow];
    MCTSNode *newNode = [[MCTSNode alloc]initWithSuperNode:superNode map:newMap chessType:newBow ID:ID legalNext:set];
    
    return newNode;
}

- (void)printMap:(NSArray *)map{
    for (int i=0; i<8; i++) {
        for (int j=0; j<8; j++) {
            if ([map[i][j] isEqual:@(2)]) {
                NSLog(@"  ");
                continue;
            }
            NSLog(@"%@ ",map[i][j]);
        }
        NSLog(@"\n");
    }
    NSLog(@"\n");
}


- (NSInteger)gain:(NSArray *)map{
    int whiteCount = 0;
    int blackCount = 0;
    for (int i = 0; i<8; i++)
        for (int j=0;j<8;j++)
            if ([map[i][j] intValue] == 0) blackCount ++;
            else if ([map[i][j] intValue] == 1) whiteCount ++;
    if (whiteCount > blackCount) return 1;
    else return -1;
}

#pragma mark - core
- (MCTSNode *)selectPolicy:(MCTSNode *)root{
    MCTSNode *currentNode = root;
    while (!currentNode.isTerminal) {
        if (currentNode.didnotNextArr.count > 0){
            return [self expand:currentNode];
        }else{
            currentNode = [self UCB1:currentNode];
        }
    }
    return currentNode;
}

- (MCTSNode *)expand:(MCTSNode *)root{
    NSInteger randomIdx = arc4random() % root.didnotNextArr.count;
    MCTSNode *expandNode = [self createNodeWithSuperNode:root ID:[root.didnotNextArr[randomIdx] intValue]];
    
    [root.didNextArr addObject:expandNode];
    [root.didnotNextArr removeObjectAtIndex:randomIdx];
    return expandNode;
}

- (MCTSNode *)UCB1:(MCTSNode *)root{
    MCTSNode* max = root.didNextArr[0];
    double maxUCB = max.UCB;
    for (MCTSNode* node in root.didNextArr) {
        if (node.UCB > maxUCB){
            max = node;
            maxUCB = node.UCB;
        }
    }
    return max;
}

- (NSInteger)simulatePolicy:(MCTSNode *)root{
    MCTSNode *node = root;
    while(!node.isTerminal){
        NSInteger randomID = [node.didnotNextArr[arc4random() % node.didnotNextArr.count] intValue];
        node = [self createNodeWithSuperNode:node ID:randomID];
    }
    [self printMap:node.mapNow];
    return [self gain: node.mapNow];
}

- (void)backPropagateWithGain:(NSInteger)gain endNode:(MCTSNode *)endNode{
    MCTSNode *currentNode = endNode;
    while (currentNode) {
        currentNode.accessNum += 1;
        currentNode.profit += (currentNode.chessType == _root.chessType? -gain : gain);
        currentNode = currentNode.superNode;
    }
}



@end
