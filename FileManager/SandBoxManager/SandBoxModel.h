//
//  SandBoxModel.h
//  TCOA
//
//  Created by 高小伟 on 2017/8/17.
//  Copyright © 2017年 ytf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SandBoxModel : NSObject
@property(nonatomic ,copy)NSString *fileName;
@property(nonatomic,copy)NSString *imgName;
@property(nonatomic,assign)BOOL isImg;
@property(nonatomic,copy)NSString *fileSize;
@property(nonatomic,copy)NSString *flilePath;
@property(nonatomic,copy)NSString *fileType;
@end
