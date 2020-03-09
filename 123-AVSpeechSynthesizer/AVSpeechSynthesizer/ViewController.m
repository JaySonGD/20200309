//
//  ViewController.m
//  AVSpeechSynthesizer
//
//  Created by Jay on 24/4/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"【环球丝网报道实习记者侯佳欣】11日，维基解密创始人阿桑奇畀英国警察拉，喺阿桑奇畀拖出戹瓜多尔大使馆嘅时候，佢大喊住，“英国一定要抵抗? You will also need to set the Prefix Header build setting of one or more of your targets to reference this file"];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-HK"];
    utterance.rate = 0.5;
    utterance.pitchMultiplier = 1.0;
    utterance.postUtteranceDelay = 0.5;
    [synthesizer speakUtterance:utterance];
}

@end
