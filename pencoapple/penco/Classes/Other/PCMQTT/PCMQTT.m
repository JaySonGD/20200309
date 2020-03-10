//
//  PCMQTT.m
//  penco
//
//  Created by Jay on 13/7/2019.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import "PCMQTT.h"
#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>
#import <CommonCrypto/CommonHMAC.h>
#import "YHTools.h"
#import "YHCommon.h"
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
NSString *const PCNotificationMQQTT = @"PCNotificationMQQTT";
//MARK: 生产 API
#ifdef YHProduction
#define InstanceId @"post-cn-v6419gki808"
#define Host @"post-cn-v6419gki808.mqtt.aliyuncs.com"
#define AccessKey @"LTAIihBXbDBhYK4O"
#define SecretKey @"wfZqeRbUsuv6poIWGCvb8EnDlDssq6"
#endif

//MARK: 测试环境 PVT
#ifdef YHTest
//测试环境
#define InstanceId @"post-cn-v6417kaqg10"
#define Host @"post-cn-v6417kaqg10.mqtt.aliyuncs.com"
#define AccessKey @"LTAImiLqKVGJkXve"
#define SecretKey @"64SpUXfPAaYvr2gxnXbxBZHMaPuVnw"

#endif
@interface PCMQTT ()<MQTTSessionManagerDelegate>

@property (strong, nonatomic) MQTTSessionManager *manager;
@property (strong, nonatomic) NSDictionary *mqttSettings;
@property (copy, nonatomic) NSString *instanceId;
@property (copy, nonatomic) NSString *rootTopic;
@property (copy, nonatomic) NSString *userTopic;
@property (copy, nonatomic) NSString *accessKey;
@property (copy, nonatomic) NSString *secretKey;
@property (copy, nonatomic) NSString *groupId;
@property (copy, nonatomic) NSString *clientId;
@property (assign, nonatomic) NSInteger qos;

@property (nonatomic, strong) NSMutableDictionary *subscriptions;
@end


@implementation PCMQTT
DEFINE_SINGLETON_FOR_CLASS(PCMQTT);


- (instancetype)init
{
    self = [super init];
    if (self) {
        //从配置文件导入相关属性
        //NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
        //NSURL *mqttPlistUrl = [bundleURL URLByAppendingPathComponent:@"mqtt.plist"];
        //self.mqttSettings = [NSDictionary dictionaryWithContentsOfURL:mqttPlistUrl];
        self.mqttSettings = @{
                              @"qos" :@(0),
                              @"groupId" : @"GID-RULER",
                              @"secretKey" : SecretKey,
                              @"accessKey" : AccessKey,
                              @"host" : Host,
                              @"port" : @(1883),
                              @"tls" : @(NO),
                              @"rootTopic" : @"ruler/user",
                              @"instanceId": InstanceId
                              };
        //实例 ID，购买后从控制台获取
        self.instanceId = self.mqttSettings[@"instanceId"];
        self.rootTopic = self.mqttSettings[@"rootTopic"];
        self.accessKey = self.mqttSettings[@"accessKey"];
        self.secretKey = self.mqttSettings[@"secretKey"];
        self.groupId = self.mqttSettings[@"groupId"];
        self.qos =[self.mqttSettings[@"qos"] integerValue];
        //cientId的生成必须遵循GroupID@@@前缀，且需要保证全局唯一
        self.clientId=[NSString stringWithFormat:@"%@@@@%@",self.groupId,[YHTools getUniqueDeviceIdentifierAsString]];
        
        self.autoConnect = YES;
        self.subscriptions = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)subscribe:(NSString*)topic{
    self.userTopic = [NSString stringWithFormat:@"%@/%@", self.rootTopic, topic];
    [self.subscriptions addEntriesFromDictionary:self.manager.subscriptions];
    
    [self.subscriptions setValue:[NSNumber numberWithInteger:self.qos] forKey:[NSString stringWithFormat:@"%@", self.rootTopic]];
    [self.subscriptions setValue:[NSNumber numberWithInteger:self.qos] forKey:[NSString stringWithFormat:@"%@", self.userTopic]];
    
    self.manager.subscriptions = self.subscriptions;
    
    [self reConnected];
}

-(void)unsubscribe:(NSString*)topic{
    [self.subscriptions removeObjectForKey:[NSString stringWithFormat:@"%@", self.rootTopic]];
    [self.subscriptions removeObjectForKey:[NSString stringWithFormat:@"%@", self.userTopic]];
    self.manager.subscriptions = self.subscriptions;
}

-(void)exit{
    if(self.autoConnect) return;
    [self.manager disconnect];
    [self.manager removeObserver:self forKeyPath:@"state"];
    self.manager.delegate = nil;
    self.manager = nil;
}

- (UInt16)sendMessage:(NSDictionary *)msg{
    
  return [self.manager sendData:[NSJSONSerialization dataWithJSONObject:msg options:NSJSONWritingPrettyPrinted error:NULL]
                     topic:self.userTopic//此处设置多级子topic
                       qos:self.qos
                    retain:YES];
}



- (void)reConnected{
    
    if (!self.manager) {
        self.manager = [[MQTTSessionManager alloc] init];
        self.manager.delegate = self;
        self.manager.subscriptions = self.subscriptions;//[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:self.qos] forKey:[NSString stringWithFormat:@"%@", self.rootTopic]];
        //password的计算方式是，使用secretkey对clientId做hmac签名算法，具体实现参考macSignWithText方法
        NSString *passWord = [[self class] macSignWithText:self.clientId secretKey:self.secretKey];
        NSString *userName = [NSString stringWithFormat:@"Signature|%@|%@",self.accessKey,self.instanceId];;
        //此处从配置文件导入的Host即为MQTT的接入点，该接入点获取方式请参考资源申请章节文档，在控制台上申请MQTT实例，每个实例会分配一个接入点域名
        [self.manager connectTo:self.mqttSettings[@"host"]
                           port:[self.mqttSettings[@"port"] intValue]
                            tls:[self.mqttSettings[@"tls"] boolValue]
                      keepalive:60  //心跳间隔不得大于120s
                          clean:true
                           auth:true
                           user:userName
                           pass:passWord
                           will:false
                      willTopic:nil
                        willMsg:nil
                        willQos:0
                 willRetainFlag:FALSE
                   withClientId:self.clientId];
        
        /*
         * MQTTCLient: observe the MQTTSessionManager's state to display the connection status
         */
        
        [self.manager addObserver:self
                       forKeyPath:@"state"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:nil];
        
    } else if(self.manager.state != MQTTSessionManagerStateConnected){
        [self.manager connectToLast];
    }
    

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch (self.manager.state) {
        case MQTTSessionManagerStateClosed:
            YHLog(@"%s--------已经关闭", __func__);
//            self.status.text = @"closed";
//            self.disconnect.enabled = false;
//            self.connect.enabled = false;
            break;
        case MQTTSessionManagerStateClosing:
            YHLog(@"%s--------关闭中", __func__);
//            self.status.text = @"closing";
//            self.disconnect.enabled = false;
//            self.connect.enabled = false;
            break;
        case MQTTSessionManagerStateConnected:
            YHLog(@"%s--------已连接：%@", __func__,self.clientId);
//            self.status.text = [NSString stringWithFormat:@"connected as %@",
//                                self.clientId];
//            self.disconnect.enabled = true;
//            self.connect.enabled = false;
            break;
        case MQTTSessionManagerStateConnecting:
            YHLog(@"%s--------连接中", __func__);
//            self.status.text = @"connecting";
//            self.disconnect.enabled = false;
//            self.connect.enabled = false;
            break;
        case MQTTSessionManagerStateError:
            YHLog(@"%s--------连接失败", __func__);
//            self.status.text = @"error";
//            self.disconnect.enabled = false;
//            self.connect.enabled = false;
            break;
        case MQTTSessionManagerStateStarting:
        default:
//            self.status.text = @"not connected";
//            self.disconnect.enabled = false;
//            self.connect.enabled = true;
            YHLog(@"%s--------没有连接", __func__);
            if(self.autoConnect) [self.manager connectToLast];
            break;
    }
}

- (void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained {
    /*
     * MQTTClient: process received message
     */
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    YHLog(@"%s--------%@", __func__,[NSString stringWithFormat:@"RecvMsg from Topic: %@\nBody: %@", topic, dataString]);
    
    NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PCNotificationMQQTT object:Nil userInfo:obj];


}



+ (NSString *)macSignWithText:(NSString *)text secretKey:(NSString *)secretKey
{
    NSData *saltData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA1, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    NSString *base64Hash = [hash base64EncodedStringWithOptions:0];
    
    return base64Hash;
}

@end
