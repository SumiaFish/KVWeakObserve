//
//  HomeViewController.m
//  KVWeakObserve
//
//  Created by kevin on 2020/5/11.
//  Copyright © 2020 kevin. All rights reserved.
//

#import "HomeViewController.h"

#import "DetailViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"home";
    self.view.backgroundColor = UIColor.whiteColor;
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)pushAction:(id)sender {
    
    DetailViewController *detail = [[DetailViewController alloc] initWithNibName:NSStringFromClass(DetailViewController.class) bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
