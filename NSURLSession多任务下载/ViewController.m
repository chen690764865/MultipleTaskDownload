//
//  ViewController.m
//  NSURLSession多任务下载
//
//  Created by chenchen on 16/8/11.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import "CCBookModel.h"
#import "ViewController.h"
#import "YYModel.h"

@interface ViewController () <NSURLSessionDownloadDelegate>

/**
 *  全局的session
 */
@property (nonatomic, strong) NSURLSession* session;

/**
 *  全局属性接收请求到的数据
 */
@property (nonatomic, strong) NSArray* bookList;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{

    //url
    NSURL* url = [NSURL URLWithString:@"http://42.62.15.100/yyting/snsresource/getAblumnAudios.action?ablumnId=2719&imei=RkVGNzBFMkYtNjc2QS00NkQwLUEwOTYtNUU5Q0QyOUVGMzdE&nwt=1&q=50506&sc=1438f6d61a2907bfa8b3ea0973474ac1&sortType=1&token=j5xm1WPkdnI-uxtFXlv6CsWiNfwjfQYPQb63ToXOFc8%2A"];

    //用苹果提供的全局session发起任务,用自定义的session设置代理,实现代理方法
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error) {

        //判断请求失败
        if (error != nil || data.length == 0) {
            NSLog(@"请求失败 %@", error);
            return;
        }

        //json数据反序列化
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        //result是字典
        NSLog(@"%@", [result class]);
        //使用第三方框架yymodel字典转模型
        NSArray* bookList = [NSArray yy_modelArrayWithClass:[CCBookModel class] json:result[@"list"]];

        //使用全局属性接收
        self.bookList = bookList;
        NSLog(@"%@", self.bookList);

        //刷新数据源方法 因为当前线程是在子线程,如果在子线程刷新数据的话,有可能造成数据还没有请求回来,界面已经显示了,所以应该在主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }] resume];
}

#pragma mark - NSURLSessionDownloadDelegate

/**
 *  监听下载进度的代理方法
 *
 *  @param session                   当前session
 *  @param downloadTask              下载任务相关信息
 *  @param bytesWritten              当前下载的数据大小
 *  @param totalBytesWritten         已经下载好的数据大小
 *  @param totalBytesExpectedToWrite 需要下载的数据总大小
 */
- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{

    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"当前下载进度 %f", progress);
}

- (void)URLSession:(NSURLSession*)session downloadTask:(NSURLSessionDownloadTask*)downloadTask didFinishDownloadingToURL:(NSURL*)location
{

    //
}

#pragma mark -  懒加载

- (NSURLSession*)session
{

    if (_session == nil) {

        NSURLSessionConfiguration* conf = [NSURLSessionConfiguration defaultSessionConfiguration];

        //初始化session的同时设置代理
        _session = [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    }
    return _session;
}

@end
