//
//  SandBoxTableViewCell.h
//  TCOA
//
//  Created by 高小伟 on 2017/8/16.
//  Copyright © 2017年 ytf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SandBoxTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fileTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *sizeLb;

@end
