//
//  GCDAsyncSocket+CateGCDAsyncSocket.m
//
//  Created by worktree on 17/03/2018.
//  Copyright © 2018 worktree. All rights reserved.
//

#import "GCDAsyncSocket+CateGCDAsyncSocket.h"

#import <netinet/tcp.h>
#import <netinet/in.h>

//define
#define LogVerbose(frmt, ...)   {}
#define SOCKET_NULL -1


@implementation GCDAsyncSocket (CateGCDAsyncSocket)

#pragma mark - overwrite
- (int)createSocket:(int)family connectInterface:(NSData *)connectInterface errPtr:(NSError **)errPtr
{
    int socketFD = socket(family, SOCK_STREAM, 0);
    
    if (socketFD == SOCKET_NULL)
    {
        if (errPtr)
            *errPtr = [self performSelector:@selector(errnoErrorWithReason:) withObject:@"Error in socket() function"];
        //[self errnoErrorWithReason:@"Error in socket() function"];
        
        return socketFD;
    }
    
    //method signature,descripte
    NSMethodSignature *signature=[[self class] instanceMethodSignatureForSelector:@selector(bindSocket:toInterface:error:)];
    
    //wrapp method
    NSInvocation *invo=[NSInvocation invocationWithMethodSignature:signature];
    
    //config method target
    [invo setTarget:self];
    
    //config invocation method
    [invo setSelector:@selector(bindSocket:toInterface:error:)];
    
    //config param
    BOOL invoResult=NO;
    [invo setArgument:&socketFD atIndex:2];
    [invo setArgument:&connectInterface atIndex:3];
    [invo setArgument:errPtr atIndex:4];
    
    //invoke
    [invo invoke];
    [invo getReturnValue:&invoResult];
    
    if (!invoResult)
    {//[self bindSocket:socketFD toInterface:connectInterface error:errPtr]
//        [self closeSocket:socketFD];
        [self performSelector:@selector(closeSocket:) withObject:@(socketFD)];
        
        return SOCKET_NULL;
    }
    
    // Prevent SIGPIPE signals
    
    int nosigpipe = 1;
    int rs=setsockopt(socketFD, SOL_SOCKET, SO_NOSIGPIPE, &nosigpipe, sizeof(nosigpipe));
    
    //enable tcp keepalive
    int onKeepalive = 1;
    rs=setsockopt(socketFD, SOL_SOCKET, SO_KEEPALIVE, &onKeepalive, sizeof(onKeepalive));
    NSLog(@"rs:%d",rs);
    
    //config keep idle
    int keepIdle = 3*60;//5 minutes
    rs=setsockopt(socketFD, IPPROTO_TCP, TCP_KEEPALIVE, &keepIdle, sizeof(keepIdle));
    NSLog(@"rs:%d",rs);
    
    //config keep interval
//    int keepInterval = 75;
//    rs=setsockopt(socketFD, IPPROTO_TCP, TCP_KEEPINTVL, &keepInterval, sizeof(keepInterval));
    
    NSLog(@"rs:%d",rs);
    
    return socketFD;
}

@end
