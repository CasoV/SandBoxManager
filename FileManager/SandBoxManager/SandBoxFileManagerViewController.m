//
//  SandBoxFileManagerViewController.m
//  TCOA
//
//  Created by 高小伟 on 2017/8/16.
//  Copyright © 2017年 ytf. All rights reserved.
//

#import "SandBoxFileManagerViewController.h"
#import "SandBoxTableViewCell.h"
#import "SandBoxModel.h"
#import <QuickLook/QuickLook.h>
@interface SandBoxFileManagerViewController ()<UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDelegate,QLPreviewControllerDataSource>
@property(nonatomic,strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *fileTableView;

//保存本地的地址
@property (nonatomic ,copy) NSString *fileSvPath;
@end

@implementation SandBoxFileManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //获取沙盒下所有文件名
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSFileManager* fm=[NSFileManager defaultManager];
    NSArray *files = [fm subpathsAtPath:docDir];
    
    for (NSString *fileName in files) {
        if ([fileName containsString:@".png"] || [fileName containsString:@".jpg"]) {
            SandBoxModel *modelImg = [SandBoxModel new];
            modelImg.fileName = fileName;
            modelImg.imgName = [NSString stringWithFormat:@"%@/%@",docDir,fileName];
            modelImg.isImg = YES;
            modelImg.flilePath = modelImg.imgName;
            modelImg.fileType = @".jpg";
            modelImg.fileSize = [NSString stringWithFormat:@"%.fKB", [self sizeOfDirectory:modelImg.imgName]];
            [self.dataArr addObject:modelImg];
        }else if ([fileName containsString:@".doc"]||[fileName containsString:@".docx"]){
            SandBoxModel *modelImg = [SandBoxModel new];
            modelImg.fileName = fileName;
            modelImg.imgName = @"word";
            modelImg.isImg = NO;
            modelImg.fileType = @".doc";
            modelImg.flilePath = [NSString stringWithFormat:@"%@/%@",docDir,fileName];
            modelImg.fileSize = [NSString stringWithFormat:@"%.fKB", [self sizeOfDirectory:modelImg.flilePath]];
            [self.dataArr addObject:modelImg];
        
        }else if ([fileName containsString:@".xls"]||[fileName containsString:@".xlsx"]){
            SandBoxModel *modelImg = [SandBoxModel new];
            modelImg.fileName = fileName;
            modelImg.imgName = @"excel";
             modelImg.fileType = @".xls";
            modelImg.isImg = YES;
            modelImg.flilePath = [NSString stringWithFormat:@"%@/%@",docDir,fileName];
            modelImg.fileSize = [NSString stringWithFormat:@"%.fKB", [self sizeOfDirectory:modelImg.flilePath]];
            [self.dataArr addObject:modelImg];
            
        }else if ([fileName containsString:@".ppt"]||[fileName containsString:@".pptx"]){
            SandBoxModel *modelImg = [SandBoxModel new];
            modelImg.fileName = fileName;
            modelImg.imgName = @"powerPoint";
             modelImg.fileType = @".ppt";
            modelImg.isImg = YES;
            modelImg.flilePath = [NSString stringWithFormat:@"%@/%@",docDir,fileName];
            modelImg.fileSize = [NSString stringWithFormat:@"%.fKB", [self sizeOfDirectory:modelImg.flilePath]];
            [self.dataArr addObject:modelImg];
            
        }
        
        
    }
    [_fileTableView reloadData];
}
/**
 返回上一页

 @param sender Btn
 */
- (IBAction)back:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}
/**
 计算文件大小

 @param dir 路径
 @return 文件大小
 */
-(float)sizeOfDirectory:(NSString *)dir{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:dir];
    if (isExist) {
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:dir error:nil] fileSize];
        return fileSize/1024;
    } else {
        NSLog(@"file is not exist");
        return 0;
    }
}


#pragma UITableViewDeleagte UITableViewDataSourse
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SandBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SandBoxTableViewCell"];

    SandBoxModel *model = _dataArr[indexPath.row];
    if (model.isImg) {
        cell.fileTypeImg.image = [[UIImage alloc]initWithContentsOfFile:model.imgName];
    }else{
        cell.fileTypeImg.image = [UIImage imageNamed:model.imgName];
    }
    cell.nameLb.text = model.fileName;
    cell.sizeLb.text = model.fileSize;
    return cell;

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SandBoxModel *model = _dataArr[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除沙盒文件
        if(![model.flilePath  isEqual: @""]){
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            [fileManager removeItemAtPath:model.flilePath  error:nil];
            [_dataArr removeObject:model];
            [_fileTableView reloadData];
        }
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SandBoxModel *model = _dataArr[indexPath.row];
    _fileSvPath = model.flilePath;
    if(_fileSvPath){
        QLPreviewController *preViewCon = [QLPreviewController new];
        preViewCon.dataSource = self;
        [preViewCon setDelegate:self];
        [self presentViewController:preViewCon animated:YES completion:nil];
    }

}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
#pragma 懒加载
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    
    return _dataArr;
}

#pragma QLPreViewDelegate
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}
- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.fileSvPath];
}
- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    //删除文件
    //    if(![self.fileSvPath  isEqual: @""]){
    //        NSFileManager * fileManager = [[NSFileManager alloc]init];
    //        [fileManager removeItemAtPath:self.fileSvPath error:nil];
    //    }
    
}

@end
