

#import <UIKit/UIKit.h>

#define VPOnLine 1

@interface AARequest : NSObject

+ (instancetype)request;

+ (void)initAppKey:(NSString *)appKey
     base64BaseURL:(NSString *)base64URL;

- (void)getJson:(NSString *)url
      parameter:(id)parameters
        success:(void(^)(id respones))success
          error:(void(^)(NSError *error))failure;

@end
