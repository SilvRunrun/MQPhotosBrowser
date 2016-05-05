//
//  RootViewController.m
//  MQPhotosBrowser
//
//  Created by ma on 16/5/5.
//  Copyright © 2016年 silvrunrun. All rights reserved.
//

#import "RootViewController.h"
#import "DemoObject.h"
#import "Demo1ViewController.h"

@interface RootViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *demos;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Demos";
    
    self.demos = @[[DemoObject demoWithTitle:@"网络加载图片1 需传入url" class:@"Demo1ViewController"],
                   [DemoObject demoWithTitle:@"网络加载图片2 需传入url和源视图" class:@"Demo2ViewController"],
                   [DemoObject demoWithTitle:@"本地加载图片3 需传入带图片的源视图" class:@"Demo3ViewController"],
                   [DemoObject demoWithTitle:@"本地加载图片4 需传入图片" class:@"Demo4ViewController"]];
    
    [self setupSubviews];
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    DemoObject *demo = self.demos[indexPath.row];
    cell.textLabel.text = demo.demoTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DemoObject *demo = self.demos[indexPath.row];
    UIViewController *vc = [[NSClassFromString(demo.demoClass) alloc] init];
    vc.title = demo.demoTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
