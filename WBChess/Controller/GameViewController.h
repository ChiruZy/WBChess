//
//  GameViewController.h
//  WBChess
//
//  Created by Overloop on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GameMode) {
    Easy,
    Medium,
    Hard,
};


@interface GameViewController : UIViewController

- (instancetype)initWithAIMode:(BOOL)AI mode:(GameMode)mode;

@end

NS_ASSUME_NONNULL_END
