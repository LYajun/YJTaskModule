//
//  YJWrittingImageView.m
//  LGTeachCloud
//
//  Created by 刘亚军 on 2019/5/28.
//  Copyright © 2019 刘亚军. All rights reserved.
//

#import "YJWrittingImageView.h"
#import "YJUploadCell.h"
#import <LGTalk/LGTPhotoManage.h>
#import "YJAnswerWrittingImage.h"
#import "YJPaperModel.h"
#import <Masonry/Masonry.h>
#import "YJConst.h"
#import <LGAlertHUD/LGAlertHUD.h>
#import <YJNetManager/YJNetManager.h>
#import "YJWrittingImageViewer.h"
static NSInteger maxUploadCount = 3;
@interface YJWrittingImageView ()<UICollectionViewDelegate,UICollectionViewDataSource,LGTPhotoManageDelegate>
@property (nonatomic,strong) LGTPhotoManage *photoManager;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,assign) BOOL isMore;
@property (nonatomic,assign) NSInteger currentIndex;
@end
@implementation YJWrittingImageView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.equalTo(self);
            make.width.mas_equalTo(self.collectionViewItemWidth*3+10);
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerDidFinishCountdownNoti:) name:@"YJAnswerTimerDidFinishCountdown" object:nil];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)timerDidFinishCountdownNoti:(NSNotification *)noti{
    UIViewController *controller = [LGTPhotoManage manage].ownController;
    if (controller.presentedViewController) {
        [controller.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)setSmallModel:(YJPaperSmallModel *)smallModel{
    _smallModel = smallModel;
    [self.imageArr removeAllObjects];
    [self.imageArr addObject:@""];
    if (!IsArrEmpty(smallModel.yj_imgUrlArr)) {
        for (NSString *url in smallModel.yj_imgUrlArr) {
            YJAnswerWrittingImage *image = [[YJAnswerWrittingImage alloc] init];
            image.imgUrl = url;
            [self.imageArr insertObject:image atIndex:self.imageArr.count-1];
            if (self.imageArr.count == maxUploadCount+1) {
                [self.imageArr removeObjectAtIndex:self.imageArr.count-1];
            }
        }
    }else{
        smallModel.yj_imgUrlArr = @[];
    }
    [self.collectionView reloadData];
}
- (CGFloat)collectionViewItemWidth{
    if (IsIPad) {
        return 120;
    }
    return (LG_ScreenWidth - 80)/3;
}
- (void)uploadImageWithImgArr:(NSArray *)imgArr Completion:(void (^) (NSArray *imgUrlArr)) completion{
    if ([[YJTaskModuleConfig currentSysID] isEqualToString:YJTaskModule_SysID_Multimedia]) {
        [self multimedia_uploadImageWithImgArr:imgArr Completion:completion];
    }else if ([[YJTaskModuleConfig currentSysID] isEqualToString:YJTaskModule_SysID_Preview]){
        [self kq_uploadImageWithImgArr:imgArr Completion:completion];
    }else{
        [self task_uploadImageWithImgArr:imgArr Completion:completion];
    }
}
- (void)task_uploadImageWithImgArr:(NSArray *)imgArr Completion:(void (^) (NSArray *imgUrlArr)) completion{
    YJUploadModel *uploadModel = [[YJUploadModel alloc] init];
    NSMutableArray *imageDatas = [NSMutableArray array];
    NSMutableArray *fileNames = [NSMutableArray array];
    for (UIImage *image in imgArr) {
        [fileNames addObject:[NSString stringWithFormat:@"%.f-%li.png",[[NSDate date] timeIntervalSince1970],imageDatas.count]];
        NSData *imgData = [image yj_compressImageOnlength:200];
        [imageDatas addObject:imgData];
    }
    uploadModel.uploadDatas = imageDatas;;
    uploadModel.name = @"file";
    uploadModel.fileNames = fileNames;
    uploadModel.fileType = @"image/png";
    
    NSString *exerciseApiUrl = [NSUserDefaults yj_stringForKey:YJTaskModule_ApiUrl_UserDefault_Key];
    NSString *url = [exerciseApiUrl stringByAppendingString:@"/api/Common/UploadImg"];
    [LGAlert showIndeterminateWithStatus:@"上传图片..."];
    [[YJNetManager defaultManager].setRequest(url).setRequestType(YJRequestTypeUpload).setUploadModel(uploadModel) startRequestWithProgress:^(NSProgress *progress) {
        NSLog(@"%f",progress.fractionCompleted);
    } success:^(id response) {
        NSLog(@"成功：%@",response);
        if ([[response objectForKey:@"Code"] isEqualToString:@"00"]) {
            NSArray *imagesUrls = [response objectForKey:@"Data"];
            if (!IsArrEmpty(imagesUrls)) {
                [NSUserDefaults yj_setObject:@(YES) forKey:UserDefaults_YJAnswerStatusChanged];
                [LGAlert showSuccessWithStatus:@"上传成功"];
            }else{
                [LGAlert showErrorWithStatus:@"上传失败"];
            }
            if (completion) {
                completion(IsArrEmpty(imagesUrls) ? nil : imagesUrls);
            }
        }else{
            [LGAlert showErrorWithStatus:[response objectForKey:@"Msg"]];
            if (completion) {
                completion(nil);
            }
        }
    } failure:^(NSError *error) {
        [LGAlert showErrorWithError:error];
        if (completion) {
            completion(nil);
        }
    }];
}
- (void)deleteImgWithImgUrl:(NSString *)imgUrl{
    if ([[YJTaskModuleConfig currentSysID] isEqualToString:YJTaskModule_SysID_Multimedia]) {
        [self multimedia_deleteImgWithImgUrl:imgUrl];
    }else if ([[YJTaskModuleConfig currentSysID] isEqualToString:YJTaskModule_SysID_Preview]){
        [self kq_deleteImgWithImgUrl:imgUrl];
    }else{
       [self task_deleteImgWithImgUrl:imgUrl];
    }
}
- (void)task_deleteImgWithImgUrl:(NSString *)imgUrl{
    if (IsStrEmpty(imgUrl)) {
        return;
    }
    NSString *exerciseApiUrl = [NSUserDefaults yj_stringForKey:YJTaskModule_ApiUrl_UserDefault_Key];
    NSString *urlStr = [exerciseApiUrl stringByAppendingString:@"api/Com/DeleteImg"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:@[imgUrl] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{@"imgList":jsonStr};
     [[YJNetManager defaultManager].setRequest(urlStr).setRequestType(YJRequestTypePOST).setParameters(params) startRequestWithSuccess:^(id  _Nonnull response) {
         if ([response[@"Code"] isEqualToString:@"00"]) {
             NSLog(@"删除图片成功");
         }else{
             NSLog(@"删除图片失败");
         }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"删除图片失败");
    }];
    
}
- (void)kq_uploadImageWithImgArr:(NSArray *)imgArr Completion:(void (^) (NSArray *imgUrlArr)) completion{
    NSString *imgApiUrl = [NSUserDefaults yj_stringForKey:YJTaskModule_ImgApiUrl_UserDefault_Key];
   
    NSString *assignmentId = [NSUserDefaults yj_stringForKey:YJTaskModule_AssignmentID_UserDefault_Key];
    NSString *resId = [NSUserDefaults yj_stringForKey:YJTaskModule_ResID_UserDefault_Key];
    NSString *userId = [NSUserDefaults yj_stringForKey:YJTaskModule_UserID_UserDefault_Key];
    NSDate *second = [NSDate date];
    long secondTimeZone = [second timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%ld",secondTimeZone];
    NSString *str = [NSString stringWithFormat:@"%@%@",timeStr,userId];

    NSString *md5Str = [NSString yj_md5EncryptStr:str].yj_reverse;
    NSString *urlStr = [NSString stringWithFormat:@"%@fileHandler.ashx",imgApiUrl];
      NSDictionary *params =@{@"userId":kApiParams(userId),
                              @"assignmentId":kApiParams(assignmentId),
                              @"resId":kApiParams((resId)),
                              @"op":@"uploadFile",
                              @"TimeStamp":timeStr,
                              @"Key":md5Str,
                              @"fileName":@""};
   [LGAlert showIndeterminateWithStatus:@"上传图片..."];
    [[YJNetManager defaultManager].setRequest(urlStr).setParameters(params) uploadFileWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i <imgArr.count; i++) {
            UIImage *image = imgArr[i];
             NSData *imgData = [image yj_compressImageOnlength:200];
            [formData appendPartWithFileData:imgData name:@"userHeader" fileName:[NSString stringWithFormat:@"iOS%d%@.png",i+1,timeStr] mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(id  _Nonnull responseObject) {
        NSInteger suceessInt = [responseObject[@"code"] integerValue];
        if (suceessInt == 0) {
          NSArray *imagesUrls = [responseObject objectForKey:@"Data"];
            if (!IsArrEmpty(imagesUrls)) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dic in imagesUrls) {
                    NSString *path = [dic objectForKey:@"httpPath"];
                    NSString *imgUrl = [imgApiUrl stringByAppendingString:path];
                    [array addObject:imgUrl];
                }
                imagesUrls = array;
                [NSUserDefaults yj_setObject:@(YES) forKey:UserDefaults_YJAnswerStatusChanged];
                [LGAlert showSuccessWithStatus:@"上传成功"];
            }else{
                [LGAlert showErrorWithStatus:@"上传失败"];
            }
            if (completion) {
                completion(IsArrEmpty(imagesUrls) ? nil : imagesUrls);
            }
        }else{
            [LGAlert showErrorWithStatus:@"上传失败"];
            if (completion) {
                completion(nil);
            }
        }
    } failure:^(NSError * _Nonnull error) {
         [LGAlert showErrorWithError:error];
         if (completion) {
             completion(nil);
         }
    }];
}
- (void)kq_deleteImgWithImgUrl:(NSString *)imgUrl{
     NSString *imgApiUrl = [NSUserDefaults yj_stringForKey:YJTaskModule_ImgApiUrl_UserDefault_Key];
    NSString *imageName = [imgUrl stringByReplacingOccurrencesOfString:imgApiUrl withString:@""];
    NSString *assignmentId = [NSUserDefaults yj_stringForKey:YJTaskModule_AssignmentID_UserDefault_Key];
    NSString *resId = [NSUserDefaults yj_stringForKey:YJTaskModule_ResID_UserDefault_Key];
    NSString *userId = [NSUserDefaults yj_stringForKey:YJTaskModule_UserID_UserDefault_Key];
    NSDate *second = [NSDate date];
    long secondTimeZone = [second timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%ld",secondTimeZone];
    NSString *str = [NSString stringWithFormat:@"%@%@",timeStr,userId];

    NSString *md5Str = [NSString yj_md5EncryptStr:str].yj_reverse;
    NSString *urlStr = [NSString stringWithFormat:@"%@fileHandler.ashx",imgApiUrl];
       NSDictionary *params =@{@"userId":kApiParams(userId),
                               @"assignmentId":kApiParams(assignmentId),
                               @"resId":kApiParams((resId)),
                               @"op":@"deleteFile",
                               @"TimeStamp":timeStr,
                               @"Key":md5Str,
                               @"fileName":imageName};
    [[YJNetManager defaultManager].setRequest(urlStr).setParameters(params) uploadFileWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull progress) {
    } success:^(id  _Nonnull responseObject) {
        NSInteger suceessInt = [responseObject[@"code"] integerValue];
        if (suceessInt == 0) {
            NSLog(@"删除图片成功");
        }else{
            NSLog(@"删除图片失败");
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"删除图片失败");
    }];
}
- (void)multimedia_uploadImageWithImgArr:(NSArray *)imgArr Completion:(void (^) (NSArray *imgUrlArr)) completion{
    YJUploadModel *uploadModel = [[YJUploadModel alloc] init];
    NSMutableArray *imageDatas = [NSMutableArray array];
    NSMutableArray *fileNames = [NSMutableArray array];
    for (UIImage *image in imgArr) {
        [fileNames addObject:[NSString stringWithFormat:@"%@%li.png",[[NSUUID UUID] UUIDString],imageDatas.count]];
        NSData *imgData = [image yj_compressImageOnlength:200];
        [imageDatas addObject:imgData];
    }
    uploadModel.uploadDatas = imageDatas;;
    uploadModel.name = @"file";
    uploadModel.fileNames = fileNames;
    uploadModel.fileType = @"image/png";
    
    NSString *exerciseApiUrl = [NSUserDefaults yj_stringForKey:YJTaskModule_ApiUrl_UserDefault_Key];
    NSString *url = [exerciseApiUrl stringByAppendingString:@"/UploadResFile.ashx"];
    [LGAlert showIndeterminateWithStatus:@"上传图片..."];
    [[YJNetManager defaultManager].setRequest(url).setRequestType(YJRequestTypeUpload).setUploadModel(uploadModel) startRequestWithProgress:^(NSProgress *progress) {
        NSLog(@"%f",progress.fractionCompleted);
    } success:^(id response) {
        NSLog(@"成功：%@",response);
        if ([[response objectForKey:@"ReturnCode"] integerValue] == 1) {
            NSArray *imagesUrls = [response objectForKey:@"Result"];
            if (!IsArrEmpty(imagesUrls)) {
                [NSUserDefaults yj_setObject:@(YES) forKey:UserDefaults_YJAnswerStatusChanged];
                [LGAlert showSuccessWithStatus:@"上传成功"];
            }else{
                [LGAlert showErrorWithStatus:@"上传失败"];
            }
            if (completion) {
                completion(IsArrEmpty(imagesUrls) ? nil : imagesUrls);
            }
        }else{
            [LGAlert showErrorWithStatus:[response objectForKey:@"Msg"]];
            if (completion) {
                completion(nil);
            }
        }
    } failure:^(NSError *error) {
        [LGAlert showErrorWithError:error];
        if (completion) {
            completion(nil);
        }
    }];
}
- (void)multimedia_deleteImgWithImgUrl:(NSString *)imgUrl{
    if (IsStrEmpty(imgUrl)) {
        return;
    }
    NSString *exerciseApiUrl = [NSUserDefaults yj_stringForKey:YJTaskModule_ApiUrl_UserDefault_Key];
    NSString *urlStr = [exerciseApiUrl stringByAppendingString:@"/WebService.asmx/DelImage"];
    NSDictionary *params = @{@"filePath":imgUrl};
     [[YJNetManager defaultManager].setRequest(urlStr).setRequestType(YJRequestTypeGET).setParameters(params) startRequestWithSuccess:^(id  _Nonnull response) {
         if ([[response objectForKey:@"ReturnCode"] integerValue] == 1 && [[response objectForKey:@"Result"] boolValue]) {
             NSLog(@"删除图片成功");
         }else{
             NSLog(@"删除图片失败");
         }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"删除图片失败");
    }];
}
- (void)selectImagesAction{
    __weak typeof(self) weakSelf = self;
    [LGTPhotoManage manage].ownController = [UIViewController yj_topControllerForController:[UIApplication sharedApplication].delegate.window.rootViewController];

    [LGAlert alertSheetWithTitle:nil message:nil canceTitle:@"取消" buttonTitles:@[@"拍摄照片",@"从本地相册中选取"] buttonBlock:^(NSInteger index) {
        if (index == 0) {
            [weakSelf.photoManager photoFromCamera];
        }else{
            [weakSelf.photoManager photoFromAlbum];
        }
    } cancelBlock:^{
    } atController:self.photoManager.ownController];
}
- (void)deleteCellImgAtIndex:(NSInteger)index{
    if (![[self.imageArr objectAtIndex:index] isKindOfClass:NSString.class]) {
        [self.imageArr removeObjectAtIndex:index];
        if (self.imageArr.count < maxUploadCount && ![self.imageArr.lastObject isKindOfClass:[NSString class]]) {
            [self.imageArr addObject:@""];
        }
        
        
        NSString *imgUrl = [self.smallModel.yj_imgUrlArr yj_objectAtIndex:index];
        [self deleteImgWithImgUrl:imgUrl];
        
        NSMutableArray *arr = self.smallModel.yj_imgUrlArr.mutableCopy;
        [arr removeObjectAtIndex:index];
        self.smallModel.yj_imgUrlArr = arr;
        
        
        [self.collectionView reloadData];
        
        if (self.updateImgBlock) {
            self.updateImgBlock(self.smallModel.yj_imgUrlArr);
        }
    }
}
#pragma mark - LGTPhotoManageDelegate

- (void)LGTPhotoManage:(LGTPhotoManage *)manage cameraDidSelectImage:(UIImage *)selectImage{
    [self YJPhotoManageDidSelectImage:@[selectImage]];
}
- (void)LGTPhotoManage:(LGTPhotoManage *)manage albumDidSelectImage:(NSArray *)selectImages{
    [self YJPhotoManageDidSelectImage:selectImages];
}
- (void)YJPhotoManageDidSelectImage:(NSArray *)selectImages{
    __weak typeof(self) weakSelf = self;
    if (IsArrEmpty(selectImages)) {
        return;
    }
    [self uploadImageWithImgArr:selectImages Completion:^(NSArray *imgUrlArr) {
        if (!IsArrEmpty(imgUrlArr)) {
            if (weakSelf.isMore) {
                for (UIImage *image in selectImages) {
                    [weakSelf.imageArr insertObject:image atIndex:weakSelf.imageArr.count-1];
                }
                NSMutableArray *arr = weakSelf.smallModel.yj_imgUrlArr.mutableCopy;
                [arr addObjectsFromArray:imgUrlArr];
                weakSelf.smallModel.yj_imgUrlArr = arr;
            }else{
                
                NSString *imgUrl = [self.smallModel.yj_imgUrlArr yj_objectAtIndex:weakSelf.currentIndex];
                [self deleteImgWithImgUrl:imgUrl];
                
                [weakSelf.imageArr replaceObjectAtIndex:weakSelf.currentIndex withObject:selectImages.lastObject];
                NSMutableArray *arr = weakSelf.smallModel.yj_imgUrlArr.mutableCopy;
                [arr replaceObjectAtIndex:weakSelf.currentIndex withObject:imgUrlArr.lastObject];
                weakSelf.smallModel.yj_imgUrlArr = arr;
            }
            if (weakSelf.imageArr.count == maxUploadCount+1) {
                [weakSelf.imageArr removeObjectAtIndex:weakSelf.imageArr.count-1];
            }
            [weakSelf.collectionView reloadData];
            
            if (self.updateImgBlock) {
                self.updateImgBlock(self.smallModel.yj_imgUrlArr);
            }
        }
    }];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id image = self.imageArr[indexPath.row];
    if ([image isKindOfClass:[NSString class]]) {
        YJMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YJMoreCell class]) forIndexPath:indexPath];
        return cell;
    }else{
        YJUploadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YJUploadCell class]) forIndexPath:indexPath];
        if ([image isKindOfClass:[YJAnswerWrittingImage class]]) {
            cell.imgUrl = [(YJAnswerWrittingImage *)image imgUrl];
        }else{
            [cell setTaskImage:image];
        }
        __weak typeof(self) weakSelf = self;
        cell.deleteBlock = ^{
            [weakSelf deleteCellImgAtIndex:indexPath.row];
        };
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndex = indexPath.row;
    id image = self.imageArr[indexPath.row];
    if ([image isKindOfClass:[NSString class]]) {
        self.isMore = YES;
        NSInteger count = maxUploadCount - (self.imageArr.count-1);
        self.photoManager.maximumNumberOfSelection = count > 3 ? 3:count;
        [self selectImagesAction];
    }else{
        self.isMore = NO;
        [YJWrittingImageViewer showWithImageUrls:self.smallModel.yj_imgUrlArr atIndex:indexPath.row];
    }
}

#pragma mark Getter
- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}
- (LGTPhotoManage *)photoManager{
    if (!_photoManager) {
        _photoManager = [[LGTPhotoManage alloc] init];
        _photoManager.ownController = [UIViewController yj_topControllerForController:[UIApplication sharedApplication].delegate.window.rootViewController];
        _photoManager.maximumNumberOfSelection = 3;
        _photoManager.delegate = self;
    }
    return _photoManager;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0; // 左右间距
        CGFloat itemW = [self collectionViewItemWidth];
        layout.itemSize = CGSizeMake(itemW, itemW);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[YJMoreCell class] forCellWithReuseIdentifier:NSStringFromClass([YJMoreCell class])];
        [_collectionView registerClass:[YJUploadCell class] forCellWithReuseIdentifier:NSStringFromClass([YJUploadCell class])];
    }
    return _collectionView;
}
@end
