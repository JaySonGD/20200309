//
//  main.m
//  penco
//
//  Created by Zhu Wensheng on 2019/6/17.
//  Copyright © 2019 toceansoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PCSurplusGoods.h"
/***************************阻止动态调试****************************/

#import <dlfcn.h>

#import <sys/types.h>

typedef int (*ptrace_ptr_t)(int _request,pid_t _pid,caddr_t _addr,int _data);

#if !defined(PT_DENY_ATTACH)

#define PT_DENY_ATTACH 31

#endif



void disable_gdb(){
    
    void* handle = dlopen(0, RTLD_GLOBAL|RTLD_NOW);
    
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    
    ptrace_ptr(PT_DENY_ATTACH,0,0,0);
    
    dlclose(handle);
    
}

int main(int argc, char * argv[]) {
#if !(DEBUG)
    
    disable_gdb();
    
#endif
    @autoreleasepool {
        return UIApplicationMain(argc, argv, NSStringFromClass([PCSurplusGoods class]), NSStringFromClass([AppDelegate class]));
    }
}
