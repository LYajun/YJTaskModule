//
//  YJViewController.m
//  YJTaskModule
//
//  Created by lyj on 07/04/2019.
//  Copyright (c) 2019 lyj. All rights reserved.
//

#import "YJViewController.h"
#import "IEPaperDisplayViewController.h"


@interface YJViewController ()

@end

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)gotoTaskMudule:(id)sender {
    IEPaperDisplayViewController *vc = [[IEPaperDisplayViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
 
}

@end
