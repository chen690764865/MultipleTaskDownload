//
//  CCBookModel.h
//  NSURLSession多任务下载
//
//  Created by chenchen on 16/8/11.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCBookModel : NSObject

/**
 *  封面
 */
@property (nonatomic, copy) NSString *cover;

/**
 *  下载地址
 */
@property (nonatomic, copy) NSString *path;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *name;


@end
