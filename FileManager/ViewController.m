//
//  ViewController.m
//  FileManager
//
//  Created by 高小伟 on 2017/8/17.
//  Copyright © 2017年 gxw. All rights reserved.
//

#import "ViewController.h"
#import "SandBoxFileManagerViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //将文件拷入沙盒
    [self copyFileToSandBoxByFileName:@"201707271125431700.docx"];
    [self copyFileToSandBoxByFileName:@"Screenshot_2017-07-20-11-17-15-90.png"];
    [self copyFileToSandBoxByFileName:@"zsk_search.png"];
    [self copyFileToSandBoxByFileName:@"M_1484207815561.jpg"];
    

}

//跳转
- (IBAction)present:(id)sender {
    UIStoryboard *sandBoxSb = [UIStoryboard storyboardWithName:@"SandBoxFileManager" bundle:nil];
    SandBoxFileManagerViewController *sandBox = [sandBoxSb instantiateViewControllerWithIdentifier:@"SandBoxFileManagerViewController"];
    [self presentViewController:sandBox animated:YES completion:nil];
}


-(void)copyFileToSandBoxByFileName:(NSString *)fileName{
    NSArray *fileArr = [fileName componentsSeparatedByString:@"."];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docPath = [[paths objectAtIndex:0]
                         stringByAppendingPathComponent:fileName];
    NSString *docPathBun = [[NSBundle mainBundle] pathForResource:fileArr[0] ofType:fileArr[1]];
    if(![[NSFileManager defaultManager]  fileExistsAtPath:docPath])
    [[NSFileManager defaultManager] copyItemAtPath:docPathBun toPath:docPath error:nil];

}

@end
