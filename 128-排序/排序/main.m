//
//  main.m
//  排序
//
//  Created by Jay on 8/5/2019.
//  Copyright © 2019 AA. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
初始数据序列
32  18   65  48  27  9
第1趟排序之后
18  32  65  48  27  9
第2趟排序之后
18  32  65  48  27  9
第3趟排序之后
18  32  48  65  27  9
第4趟排序之后
18  27  32  48  65  9
第5趟排序之后
9  18  27  32  48  65
 */
void insertSort(){//时间复杂度是 O(n^2)
    int arary[] = {32,18,65,48,27,9};
    int length=sizeof(arary)/sizeof(arary[0]);
    
    for (int i = 1; i < length; i++) {
        int temp = arary[i];
        int j = i - 1;
        
        while (j >= 0 && arary[j] > temp) {
            arary[j+1] = arary[j];
            j--;
        }
        if (j != i -1) {
            arary[j+1] = temp;
        }
    }
    NSLog(@"%s", __func__);
}


void selectSort(){//时间复杂度是 O(n^2)
    int arary[] = {32,18,65,48,27,9};
    int length=sizeof(arary)/sizeof(arary[0]);
    for (int i = 0; i < length; i ++) {
        
        for (int j = i+1; j < length; j ++) {
            
            if (arary[j] < arary[i]) {
                int  temp = arary[j];
                arary[j] = arary[i];
                arary[i] = temp;
            }
        }
    }
    
    NSLog(@"%s", __func__);

}

void bubbleSort(){//时间复杂度是 O(n^2)
    int arary[] = {32,18,65,48,27,9};
    int length=sizeof(arary)/sizeof(arary[0]);
    for (int i = 1; i < length; i ++) {
        
        for (int j = 0; j < i ; j ++) {
            
            if (arary[j] > arary[i]) {
                int  temp = arary[j];
                arary[j] = arary[i];
                arary[i] = temp;
            }
        }
    }
    
    NSLog(@"%s", __func__);

}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        bubbleSort();
    }
    return 0;
}



