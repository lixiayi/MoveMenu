//
//  titlesVC.m
//  YunTongKaTest
//
//  Created by xiaoyi li on 17/6/16.
//  Copyright © 2017年 xiaoyi li. All rights reserved.
//

#import "titlesVC.h"

#define BTN_ITEM_WIDTH  66
#define BTN_ITEM_HEIGHT 40
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface titlesVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *titleScroll;

@property (nonatomic, strong) NSMutableArray *titleList;

@property (nonatomic, strong) UIScrollView *contentScroll;

@end

@implementation titlesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.titleScroll];
    
    [self createBtnItems];
    
    [self.view addSubview:self.contentScroll];
}

- (UIScrollView *)titleScroll {
    
    if (!_titleScroll) {
        
        CGRect scrFrame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 44);
        _titleScroll = [[UIScrollView alloc] initWithFrame:scrFrame];
        _titleScroll.delegate = self;
        _titleScroll.contentSize = CGSizeMake(BTN_ITEM_WIDTH * [self.titleList count], BTN_ITEM_HEIGHT);
        _titleScroll.showsHorizontalScrollIndicator = NO;
        _titleScroll.showsVerticalScrollIndicator = NO;
        _titleScroll.tag = 99;
        
    }
    
    return _titleScroll;
}

- (NSMutableArray *)titleList {
    
    if (!_titleList) {
        
        _titleList = [NSMutableArray arrayWithObjects:
                      @"头条",@"视频",@"娱乐",@"体育",@"广州",
                      @"网易号",@"薄荷",@"财经",@"科技",@"汽车",
                      @"社会",@"时尚",@"军事",@"直播",@"图片",nil];
        
    }
    
    return _titleList;
}


- (UIScrollView *)contentScroll {
    
    if (!_contentScroll) {
        
        CGRect scrFrame = CGRectMake(0, 64 + BTN_ITEM_HEIGHT, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - BTN_ITEM_HEIGHT);
        _contentScroll = [[UIScrollView alloc] initWithFrame:scrFrame];
        _contentScroll.delegate = self;
        _contentScroll.contentSize = CGSizeMake(BTN_ITEM_WIDTH * [self.titleList count], BTN_ITEM_HEIGHT);
        _contentScroll.showsHorizontalScrollIndicator = NO;
        _contentScroll.showsVerticalScrollIndicator = NO;
        _contentScroll.backgroundColor = [UIColor blueColor];
        _contentScroll.pagingEnabled = YES;
        _contentScroll.contentSize = CGSizeMake(kWidth * [self.titleList count], kHeight - 64 - BTN_ITEM_HEIGHT);
        _contentScroll.tag = 100;
    }
    
    return _contentScroll;
}

- (void)createBtnItems {
    for (int index=0; index<self.titleList.count; index++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame = CGRectMake(BTN_ITEM_WIDTH *index, 0, BTN_ITEM_WIDTH, BTN_ITEM_HEIGHT);
        NSString *t = self.titleList[index];
        [item setTitle:t forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:16];
        [item setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        item.tag = index;
        [item addTarget:self action:@selector(btnItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScroll addSubview:item];
        
    }
}


- (void)btnItemClick:(UIButton *)btn {
    
    for (int i=0; i<self.titleScroll.subviews.count; i++) {
        if (i == btn.tag) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:20];
        } else {
            UIButton *temp = (UIButton *)[self.titleScroll.subviews objectAtIndex:i];
            [temp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            temp.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
    
    
    [self createTableWithIndex:btn.tag];
    
    CGRect srollRect = CGRectMake(btn.tag * kWidth, 0, kWidth, kHeight - 64 - BTN_ITEM_HEIGHT);
    [self.contentScroll scrollRectToVisible:srollRect animated:YES];
    
    
    // 判断当前btn位于中间左边还是右边
    CGRect srollRect1 = CGRectMake(btn.frame.origin.x - kWidth/2 + 40, 0, kWidth, kHeight - 64 - BTN_ITEM_HEIGHT);
    if (btn.frame.origin.x > kWidth/2) {
        
        [self.titleScroll scrollRectToVisible:srollRect1 animated:true];
    }
    
}

- (void)createTableWithIndex:(NSInteger)index {
    CGRect tableFrame = CGRectMake(kWidth *index, 0, kWidth, kHeight - 64 - BTN_ITEM_HEIGHT);
    UITableView *table = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tag = index;
    [self.contentScroll addSubview:table];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *flag = @"flag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:flag];
    }
    
    cell.textLabel.text = [self.titleList objectAtIndex:tableView.tag];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
        if (scrollView.tag == 100) {
    
            CGPoint point=scrollView.contentOffset;
            int currentPage = point.x/kWidth;
    
            for (int i=0; i<self.titleScroll.subviews.count; i++) {
                UIButton *btn = (UIButton *)self.titleScroll.subviews[i];
                if (i == currentPage) {
                    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:20];
                } else {
                    UIButton *temp = (UIButton *)[self.titleScroll.subviews objectAtIndex:i];
                    [temp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    temp.titleLabel.font = [UIFont systemFontOfSize:16];
                }
                
                
            }
            
            // 判断当前btn位于中间左边还是右边
            CGRect srollRect1 = CGRectMake(currentPage * BTN_ITEM_WIDTH - kWidth/2 + 40, 0, BTN_ITEM_WIDTH, BTN_ITEM_HEIGHT);
            
            if (currentPage * BTN_ITEM_WIDTH > kWidth/2) {
                
                [self.titleScroll scrollRectToVisible:srollRect1 animated:true];
            } else {
                
                [self.titleScroll scrollRectToVisible:CGRectMake(0, 0, BTN_ITEM_WIDTH, BTN_ITEM_HEIGHT) animated:true];
            }
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
