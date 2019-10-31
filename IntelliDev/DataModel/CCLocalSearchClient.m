//
//  CCLocalSearchClient.m
//  IntelliDev
//
//  Created by chenchao on 16/4/27.
//  Copyright © 2016年 chenchao. All rights reserved.
//

#import "CCLocalSearchClient.h"

@interface CCLocalSearchClient ()

@property (nonatomic,copy)StopSearchWithDataBlock a_block;

@end



@implementation CCLocalSearchClient

- (id)init
{
    if(self=[super init]){
        
        m_sockfd=-1;
        m_recvTaggle=true;
        
        m_searchedDevArray=[[NSMutableArray alloc] initWithCapacity:30];
    }
    return self;
}

- (void)dealloc
{
    if(m_searchedDevArray!=nil){
        [m_searchedDevArray release];
    }
    [super dealloc];
}

- (int)startLocalSearchWithBlock:(StopSearchWithDataBlock)block
{
    self.a_block=block;
    
    m_recvTaggle=true;
    
    m_sockfd=socket(AF_INET, SOCK_DGRAM, 0);
    
    if(m_sockfd==-1)
    {
        perror("socket: error\n");
        return -1;
    }
    
    int broadCast=1;
    setsockopt(m_sockfd, SOL_SOCKET, SO_BROADCAST, &broadCast, sizeof(int));
    
    m_sockadd_in.sin_family=AF_INET;
    m_sockadd_in.sin_addr.s_addr=INADDR_BROADCAST;
    m_sockadd_in.sin_port=htons(SOCK_SEND_PORT);
    
    [NSThread detachNewThreadSelector:@selector(startSearchingThread) toTarget:self withObject:nil];
    
    printf("CCLocalSearch:::: init socket success!!!! %d\n",m_sockfd);
    
    return 0;
}
- (void)stopLocalSearch
{
    m_recvTaggle=false;
    close(m_sockfd);
    m_sockfd=-1;

}

- (void)startSearchingThread
{
    [self sendSearchBroadCast];
    
    if(m_searchedDevArray!=nil){
        [m_searchedDevArray removeAllObjects];
    }
    

    while(m_recvTaggle==true){
        usleep(1*1000);
        [self processRecvData];
    }
    
    //回调函数，自动更新到UI.
    self.a_block(m_searchedDevArray);
    
}

- (bool)sendSearchBroadCast
{
   printf("Send Broadcast.......\n");
    
    CC_searchBrodcastHeader header;
    memset(&header,0,sizeof(header));
    
    int headerLength=sizeof(header);
    
    header.protocolHeader[0]='C';
    header.protocolHeader[1]='C';
    header.protocolHeader[2]='T';
    header.protocolHeader[3]='B';
    
    
    header.controlMask=CONTROLLCODE_SEARCH_BROADCAST_REQUEST;
    
    CC_searchCommandContent content;
    memset(&content, 0, sizeof(content));
    
    int contentLength=sizeof(content);
    
    header.contentLength=contentLength;
    
    int packageLength=headerLength+contentLength;
    
    char sendBuffer[27]={0};
    memcpy(sendBuffer,&header,headerLength);
    memcpy(sendBuffer+headerLength, &content, contentLength);

    
    if([self writeSocket: sendBuffer Length: packageLength]){
        return true;
    }
    
    return false;
    
    
}

- (void)processRecvData
{
    CC_searchCommandContentReply contentReply;
    memset (&contentReply,0,sizeof(contentReply));
    
    if([self readSocket:(char*)&contentReply Length:sizeof(contentReply)])
    {
        if(contentReply.header.controlMask==CONTROLLCODE_SEARCH_BROADCAST_REPLY)
        {
            struct in_addr temp_in_addr;
            memset(&temp_in_addr, 0, sizeof(temp_in_addr));
            
            memcpy(&temp_in_addr, &contentReply.IP, sizeof(contentReply.IP));
            
            NSString* tempIPString=[NSString stringWithCString:inet_ntoa(temp_in_addr) encoding:NSUTF8StringEncoding];
            NSString* tempPortString=[NSString stringWithFormat:@"%d",Big2Little16(contentReply.port)];
            
            NSLog(@"RECV:::::IPADDR: %@ Port: %@",tempIPString,tempPortString);
            
            //防止添加相同的设备到Array里面..
            
            bool addedDevice=false;
            
            if(m_searchedDevArray.count>0)
            {
                for(int i=0; i<m_searchedDevArray.count; i++){
                    NSString* sameIPString=[[m_searchedDevArray objectAtIndex:i] objectForKey:@"key_ip"];
                    if([tempIPString compare:sameIPString]==NSOrderedSame)
                    {
                        addedDevice=true;
                        break;
                    }
                }
                if(!addedDevice)
                {
                    [m_searchedDevArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:tempIPString,@"key_ip",
                                                   tempPortString,@"key_port",nil]];
                }
            }
            else if(m_searchedDevArray.count==0)
            {
                [m_searchedDevArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:tempIPString,@"key_ip",
                                               tempPortString,@"key_port",nil]];
            }
            

        }
    }
    
}
- (bool)writeSocket: (char*)pBuff Length: (int)length
{
    int sendLen=0;
    int nRet=0;
    
    while(sendLen<length)
    {
        nRet=sendto(m_sockfd,pBuff,length-sendLen,0,(struct sockaddr*)&m_sockadd_in,sizeof(m_sockadd_in));
        
        if(nRet==-1){
            perror("sendto error:\n");
            return false;
        }
        
        sendLen+=nRet;
        pBuff+=nRet;
    }
    
    return true;
}

- (bool)readSocket: (char*)pBuff Length: (int)length
{
    int readLen=0;
    int nRet=0;
    
    while(readLen<length)
    {
        struct sockaddr_in addrRemote;
        int nLen=sizeof(addrRemote);
        
        nRet=recvfrom(m_sockfd,pBuff,length-readLen,0,(struct sockaddr*)&addrRemote,(socklen_t*)&nLen);
   
        if(nRet==-1){
            perror("recvfrom error: \n");
            return false;
        }

        
        readLen+=nRet;
        pBuff+=nRet;
    }
    
    return true;
    
}

@end
