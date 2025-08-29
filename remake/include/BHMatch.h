#import <Foundation/Foundation.h>

@interface BHMatch : NSObject

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSString* host;
@property (nonatomic, retain) NSString* port;

@end