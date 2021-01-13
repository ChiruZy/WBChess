//
//  ChessModel.h
//  WBChess
//
//  Created by Overloop on 2020/12/26.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ChessType) {
    Black,
    White,
    Blank,
};

@interface ChessModel : NSObject
@property (nonatomic,strong) NSMutableArray *map;
@property (nonatomic,strong) NSSet *fallSet;
@property (nonatomic,assign) NSInteger whiteCount;
@property (nonatomic,assign) NSInteger blackCount;

@property (nonatomic,assign) ChessType bow;
+ (NSSet *)getFallSet:(NSArray*)map currentType:(NSInteger)bow;
+ (void)fall:(NSMutableArray*)map ID:(NSInteger)ID currentType:(NSInteger)bow;
+ (void)fall:(NSMutableArray*)map row:(NSUInteger)row col:(NSUInteger)col currentType:(NSInteger)bow;

- (ChessType)getChessTypeWithRow:(NSUInteger)row col:(NSUInteger)col;
- (ChessType)getChessTypeWithID:(NSUInteger)ID;
- (void)fallWithID:(NSUInteger)ID;
- (void)continueFall;
@end


NS_ASSUME_NONNULL_END
