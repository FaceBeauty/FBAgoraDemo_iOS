//
//  FBEffectManager.m
//  APIExample
//
//  Created by Eddie on 2023/6/7.
//  Copyright © 2023 Agora Corp. All rights reserved.
//

#import "FBEffectManager.h"
#import "FBAppId.h"
#import "BundleUtil.h"
#if __has_include(<FaceBeauty/FaceBeauty.h>)
//todo --- facebeauty start0 ---
#import <FaceBeauty/FaceBeauty.h>
//todo --- facebeauty end ---
#endif

static FBEffectManager *shareManager = NULL;

#if __has_include(<FaceBeauty/FaceBeauty.h>)
@interface FBEffectManager ()<FaceBeautyDelegate>
#else
@interface FBEffectManager ()
#endif

@property (nonatomic, assign) BOOL isRenderInit;

@end

@implementation FBEffectManager

- (void)onInitFailure {
    
}

- (void)onInitSuccess {
#if __has_include(<FaceBeauty/FaceBeauty.h>)
    
    /* ========== 《 美颜 》======== */
    //美白
    [[FaceBeauty shareInstance] setBeauty:0 value:40];
    //磨皮
    [[FaceBeauty shareInstance] setBeauty:1 value:100];
    //红润
    [[FaceBeauty shareInstance] setBeauty:2 value:30];
    //清晰
    [[FaceBeauty shareInstance] setBeauty:3 value:20];
    //亮度
    [[FaceBeauty shareInstance] setBeauty:4 value:0];
    //去黑眼圈
    [[FaceBeauty shareInstance] setBeauty:5 value:0];
    //去法令纹
    [[FaceBeauty shareInstance] setBeauty:6 value:0];

    /* ========== 《 美型 》======== */
    //大眼
    [[FaceBeauty shareInstance] setReshape:10 value:45];
    //V脸
    [[FaceBeauty shareInstance] setReshape:21 value:50];
    //瘦鼻
    [[FaceBeauty shareInstance] setReshape:31 value:50];
     
    /* ========== 《 滤镜 》======== */
//    [[FaceBeauty shareInstance] setFilter:FBFilterBeauty name:@"自然3"];
    
    [self setSticker:@"fb_sticker_effect_mao"];
#endif
    
}

+ (FBEffectManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FBEffectManager alloc] init];
    });

    return shareManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
#if __has_include(<FaceBeauty/FaceBeauty.h>)
        //todo --- facebeauty start1 ---
        [[FaceBeauty shareInstance] initFaceBeauty:@"YOUR_APP_ID" withDelegate:self];
        //todo --- facebeauty end ---
#endif
    }
    return self;
}


- (void)setSticker: (NSString *)stickerName {
#if __has_include(<FaceBeauty/FaceBeauty.h>)
    [[FaceBeauty shareInstance] setARItem:0 name:stickerName];
#endif
}

- (void)setRelease {
#if __has_include(<FaceBeauty/FaceBeauty.h>)
    //todo --- facebeauty start3 ---
    [[FaceBeauty shareInstance] releaseBufferRenderer];
    //todo --- facebeauty end ---
#endif
}

#pragma mark - VideoFilterDelegate

- (CVPixelBufferRef)processFrame:(CVPixelBufferRef)frame {
#if __has_include(<FaceBeauty/FaceBeauty.h>)
    //todo --- facebeauty start2 ---
    CVPixelBufferLockBaseAddress(frame, 0);
    FBFormatEnum format;
    switch (CVPixelBufferGetPixelFormatType(frame)) {
        case kCVPixelFormatType_32BGRA:
            format = FBFormatBGRA;
            break;
        case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
            format = FBFormatNV12;
            break;
        case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:
            format = FBFormatNV12;
            break;
        default:
            NSLog(@"错误的视频帧格式！");
            format = FBFormatBGRA;
            break;
    }
    int imageWidth = 0;
    int imageHeight = 0;
    if (format == FBFormatBGRA) {
        imageWidth = (int)CVPixelBufferGetBytesPerRow(frame) / 4;
        imageHeight = (int)CVPixelBufferGetHeight(frame);
    } else {
//        imageWidth = (int)CVPixelBufferGetWidthOfPlane(inputPixelBuffer , 0);
        //如果出现花屏，修改imageWidth的获取方式
        imageWidth = (int)CVPixelBufferGetBytesPerRowOfPlane(frame , 0);
        imageHeight = (int)CVPixelBufferGetHeightOfPlane(frame , 0);
    }
    unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(frame, 0);
    
    CVPixelBufferUnlockBaseAddress(frame, 0);
    
    if (!_isRenderInit) {
        [[FaceBeauty shareInstance] releaseBufferRenderer];
        _isRenderInit = [[FaceBeauty shareInstance] initBufferRenderer:format width:imageWidth height:imageHeight rotation:FBRotationClockwise0 isMirror:YES maxFaces:5];
    }
    [[FaceBeauty shareInstance] processBuffer:baseAddress];
    //todo --- facebeauty end ---
#endif
    return frame;
}

 

@end
