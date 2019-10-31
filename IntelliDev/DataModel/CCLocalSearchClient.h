//
//  CCLocalSearchClient.h
//  IntelliDev
//
//  Created by chenchao on 16/4/27.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnixInterfaceDefine.h"
#import "CCLocalSearchDefine.h"

typedef void (^StopSearchWithDataBlock)(NSArray*);

@interface CCLocalSearchClient : NSObject
{
    int                 m_sockfd;
    struct sockaddr_in  m_sockadd_in;
    
    bool                m_recvTaggle;
    
    NSMutableArray*     m_searchedDevArray;
    
}

- (int)startLocalSearchWithBlock: (StopSearchWithDataBlock) block;
- (void)stopLocalSearch;
@end
