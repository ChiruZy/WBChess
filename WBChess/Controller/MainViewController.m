//
//  MainViewController.m
//  WBChess
//
//  Created by Overloop on 2020/12/25.
//

#import "MainViewController.h"
#import "GameViewController.h"




@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *modeButton;
@property (nonatomic,assign) GameMode mode;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mode = Easy;
}


- (IBAction)startGame:(id)sender {
    GameViewController *gvc = [[GameViewController alloc]initWithAIMode:NO mode:self.mode];
    [self.navigationController pushViewController:gvc animated:YES];
}
- (IBAction)startGameWithAI:(id)sender {
    GameViewController *gvc = [[GameViewController alloc]initWithAIMode:YES mode:self.mode];
    [self.navigationController pushViewController:gvc animated:YES];
}

- (IBAction)changeMode:(id)sender {
    self.mode = (self.mode + 1) % 3;
    NSString *title = self.mode == 0? @"选择难度：简单" : self.mode == 1? @"选择难度：一般": @"选择难度：困难";
    
    [self.modeButton setTitle:title forState:UIControlStateNormal];
}
- (IBAction)option:(id)sender {
    
}

@end
