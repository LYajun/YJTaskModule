//
//  YJViewController.m
//  YJTaskModule
//
//  Created by lyj on 07/04/2019.
//  Copyright (c) 2019 lyj. All rights reserved.
//

#import "YJViewController.h"
#import "IEPaperDisplayViewController.h"
#import <YJTaskModule/YJScoreAlert.h>

@interface YJViewController ()

@end

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)gotoTaskMudule:(id)sender {
//    IEPaperDisplayViewController *vc = [[IEPaperDisplayViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
 
    YJScoreAlert *scoreAlert = [YJScoreAlert scoreAlert];
    scoreAlert.totalScore = 200;
    scoreAlert.answerScore = 88;

    scoreAlert.rightCount = 101;
    scoreAlert.wrongCount = 23;

    
    scoreAlert.unMarkCount = 0;
    
    scoreAlert.bigTopicCount = 23;
    scoreAlert.smallTopicCount = 133;

    [scoreAlert show];
}

@end
