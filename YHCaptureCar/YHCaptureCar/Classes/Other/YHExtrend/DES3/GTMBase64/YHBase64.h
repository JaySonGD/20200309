//
//  YHBase64.h
//  YHCaptureCar
//
//  Created by Zhu Wensheng on 2018/4/2.
//  Copyright © 2018年 YH. All rights reserved.
//

//base64.h
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <UIKit/UIKit.h>
extern size_t EstimateBas64EncodedDataSize(size_t inDataSize);
extern size_t EstimateBas64DecodedDataSize(size_t inDataSize);

extern bool Base64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize, BOOL wrapped);
extern bool Base64DecodeData(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize);
