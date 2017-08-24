//
//  HomepageTableViewController.m
//  GCDTestDemo
//
//  Created by BillBo on 2017/8/24.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "HomepageTableViewController.h"
#import "BasicViewController.h"

@interface HomepageTableViewController ()

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation HomepageTableViewController


- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.titleArray = @[@"NSThread",@"MoreNSThread",@"NSOperation",@"GCD"];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    cell.textLabel.textColor = [UIColor redColor];
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicViewController *v = [[BasicViewController alloc] initWithThreadType:indexPath.row title:self.titleArray[indexPath.row]];
    
    [self.navigationController pushViewController:v animated:YES];
    
}

@end
