

#import <UIKit/UIKit.h>


#define FQQOnLine ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FQQOnlineKey"] boolValue])
#define FQQShow ([[[NSUserDefaults standardUserDefaults] objectForKey:@"FQQShowKey"] boolValue])
#define FQQIsGDT ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isqq"] boolValue])

#define ISAdmobBanner ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isAdmobBanner"] boolValue])

#define AAAppDownloadURL @"http://itunes.apple.com/us/app/id1478627918"
#define AAAppReviewURL @"itms-apps://itunes.apple.com/app/id1478627918?action=write-review"

#define AABundleIdentifier @"com.gjw.video"



#define FQQHud(msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(msg) message:nil delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil, nil];\
[alert show];\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
    [alert dismissWithClickedButtonIndex:0 animated:YES];\
});\

#define FQQAlert(msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(msg) message:nil delegate:nil cancelButtonTitle:@"知道" otherButtonTitles:nil, nil];\
[alert show];\



@interface FQQRequest : NSObject

+ (instancetype)share;

+ (void)regAppKey:(NSString *)appKey
     baseURL:(NSString *)base64URL;

- (void)requestDataPath:(NSString *)path
          parameter:(id)parameters
            success:(void(^)(id respones))success
              error:(void(^)(NSError *error))failure;

- (void)appRegister:(void(^)(void))success
              error:(void(^)(NSError *error))failure;

- (BOOL)isSafe;
@end
