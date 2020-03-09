

#import <UIKit/UIKit.h>

#define VPOnLine 1

@interface AARequest : NSObject

+ (instancetype)request;

+ (void)initAppKey:(NSString *)appKey
     base64BaseURL:(NSString *)base64URL;

- (void)getJson:(NSString *)url
            par:(id)parameters
             ok:(void(^)(id respones))success
          error:(void(^)(NSError *error))failure;


- (void)appInitOk:(void(^)(void))success
            error:(void(^)(NSError *error))failure;
@end
