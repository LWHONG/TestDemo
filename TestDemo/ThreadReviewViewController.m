
//
//  ThreadReviewViewController.m
//  TestDemo
//
//  Created by Tim Lam on 24/8/2017.
//  Copyright © 2017 Tim Lam. All rights reserved.
//

#import "ThreadReviewViewController.h"

@interface ThreadReviewViewController ()
{
    dispatch_queue_t queue;//并发队列
    dispatch_queue_t queue1; //区别于主队列和并发队列的，第三个队列，串行的
}

@end

@implementation ThreadReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    queue = dispatch_queue_create("111", DISPATCH_QUEUE_CONCURRENT);
    queue1 = dispatch_queue_create("111", 0);

    NSLog(@"00000"); //这个是为了对比后面打印的标记位置

    NSLog(@"main p1: %@", [NSThread currentThread]);
    //这里是主队列、主线程
    dispatch_async(queue1, ^{//首先构建一个第三个队列的执行环境
        NSLog(@"con p1: %@", [NSThread currentThread]);
        //这里是queue1队列的执行环境，假如现在是线程a在执行
        dispatch_sync(queue, ^{
            NSLog(@"con p2: %@", [NSThread currentThread]);
            //这里是并发队列的执行环境，但是却是线程a在执行
            sleep(2);
            NSLog(@"111111");
        });

    });

    NSLog(@"main p2: %@", [NSThread currentThread]);
    //这里是主队列、主线程
    dispatch_sync(queue, ^{

        //这里是主线程执行，但不是主队列
        NSLog(@"main p3: %@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"22222");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
