//
//  DQTextFild.m
//  邓琪
//
//  Created by 505 on 16/4/14.
//  Copyright © 505. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BYDBlock)(void);
typedef void(^Myblock) (NSInteger index);
@interface HotSearchTableViewCell : UITableViewCell

- (void)infortdataArr:(NSMutableArray *)arr;
@property (nonatomic,strong) Myblock block;
@property (nonatomic,strong) BYDBlock DBlock;
@end
