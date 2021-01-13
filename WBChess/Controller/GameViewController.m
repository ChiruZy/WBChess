//
//  GameViewController.m
//  WBChess
//
//  Created by Overloop on 2020/12/25.
//

#import "GameViewController.h"
#import "ChessCell.h"
//#import "ChessModel.h"
//#import "MonteCarlo.h"
#import "MCTSNode.h"
#import "MCCore.h"

@interface GameViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *restartBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *chessMap;
@property (weak, nonatomic) IBOutlet UILabel *currentFall;
@property (weak, nonatomic) IBOutlet UILabel *blackCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *whiteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *winLabel;

@property (nonatomic,strong) ChessModel *model;
@property (nonatomic,assign) NSUInteger fallCount;
@property (nonatomic,assign) NSUInteger newID;
@property (nonatomic,assign) BOOL AImode;
@property (nonatomic,assign) NSInteger mode;

@end

@implementation GameViewController

- (instancetype)initWithAIMode:(BOOL)AI mode:(GameMode)mode{
    if (self = [super init]){
        self.AImode = AI;
        _mode = mode;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chessMap registerNib:[UINib nibWithNibName:@"ChessCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.chessMap.delegate = self;
    self.chessMap.dataSource = self;
    _fallCount = 0;
    [self setCurrentUI];
}

#pragma mark - method
- (void)setCurrentUI{
    if (self.model.bow == White)  self.currentFall.text = _AImode? @"电脑考虑中": @"白";
    else if (self.model.bow == Black)  self.currentFall.text = _AImode? @"您": @"黑";
    _blackCountLabel.text = [NSString stringWithFormat:@"黑棋:  %ld", (long)self.model.blackCount];
    _whiteCountLabel.text = [NSString stringWithFormat:@"白棋:  %ld", (long)self.model.whiteCount];
}

- (NSInteger)judge{
    NSInteger continueFall = 0;
    if (self.model.fallSet.count == 0){
        [self.model continueFall];
        [self setCurrentUI];
        continueFall = 1;
        // 换边后还是无棋可下则游戏结束
        if (self.model.fallSet.count == 0 ) {
            [self gameOver];
            continueFall = 2;
        }
    }
    return continueFall;
}

- (void)gameOver{
    if (self.model.blackCount > self.model.whiteCount){
        self.winLabel.text = _AImode? @"您 赢 了": @"黑  胜";
    }else if (self.model.blackCount < self.model.whiteCount){
        self.winLabel.text = _AImode? @"您 输 了": @"白  胜";
    }else{
        self.winLabel.text = @"平  局";
    }
    self.winLabel.hidden = NO;
}

- (void)AIComputeStep{
    self.chessMap.userInteractionEnabled = NO;
    self.restartBtn.userInteractionEnabled = NO;
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        MonteCarlo *mc = [[MonteCarlo alloc]initWithRootMap:weakSelf.model.map];
//        NSInteger step = [mc startCulInStep:weakSelf.mode];
        
        MCCore *mc = [[MCCore alloc]initWithRootMap:weakSelf.model.map chessType:weakSelf.model.bow];
        NSInteger step = [mc startCulInStep:weakSelf.mode];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self AIMoveWithID:step];
        });
    });
}

- (void)AIMoveWithID:(NSUInteger)ID{
    [self.model fallWithID:ID];
    _newID = ID;
    [_chessMap reloadData];
    [self setCurrentUI];
    _fallCount += 1;
    NSInteger continueStep = [self judge];
    self.chessMap.userInteractionEnabled = YES;
    self.restartBtn.userInteractionEnabled = YES;
    if (continueStep == 1){
        [self AIComputeStep];
    }
}


#pragma mark - Data Source
- (NSInteger)numberOfSections{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 64;
}

#pragma mark - Delegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChessCell *cell = [self.chessMap dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setChessType: [self.model getChessTypeWithID:indexPath.row] isNew:indexPath.row == _newID canFall:[self.model.fallSet containsObject:@(indexPath.row)]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.model.fallSet containsObject:@(indexPath.row)]) return;
    _newID = indexPath.row;
    [self.model fallWithID:indexPath.row];
    [_chessMap reloadData];
    [self setCurrentUI];
    _fallCount += 1;
    BOOL continueFall = [self judge];
    
    if (self.AImode && continueFall == 0){
        [self AIComputeStep];
    }
}

#pragma mark - actions
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)restart:(id)sender {
    _model = nil;
    _winLabel.hidden = YES;
    _fallCount = 0;
    [self.chessMap reloadData];
    [self setCurrentUI];
    self.chessMap.userInteractionEnabled = YES;
}

- (ChessModel *)model{
    if(!_model){
        _model = [[ChessModel alloc]init];
    }
    return _model;
}

- (NSInteger)mode{
    if (_mode == 0){
        return 600;
    }else if (_mode == 1){
        return 1000;
    }
    return 1500;
}
@end
