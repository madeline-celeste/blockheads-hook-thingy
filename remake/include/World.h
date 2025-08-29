#import <Foundation/Foundation.h>
#include <Foundation/NSString.h>
#include <Foundation/NSArray.h>

#import "BHNetNode.h"
#import "BHNetConstants.h"
#import "MJMath.h"
#import "Vector.h"
#import "Weather.h"

@class BHNetServerMatch;
@class DatabaseEnvironment;
@class Database;
@class WindowInfo;
@class Tutorial;
@class UIManager;
@class CloudInterface;

struct CustomRules {};
struct CalibrationMatrix {};

@interface World : BHNetNode

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) int worldWidthMacro;
@property (nonatomic, assign) BOOL supportsGyro;
@property (nonatomic, assign) BOOL isObservingMotionEvents;


@property (nonatomic, retain) NSTimer* motionUpdateTimer;
@property (nonatomic, assign) BOOL calibrating;
@property (nonatomic, assign) BOOL hasCalibrated;


@property (nonatomic, assign) vec3 longTermAveragedAcceleration;
@property (nonatomic, assign) CalibrationMatrix calibrationMatrix;
@property (nonatomic, assign) BOOL dragInProgress;



@property (nonatomic, assign) float forcedCalibrationTimer;
@property (nonatomic, assign) float moveLeftRightFraction;
@property (nonatomic, assign) float moveUpDownFraction;
@property (nonatomic, assign) float xSmooth;
@property (nonatomic, assign) BOOL didLoadGame;



@property (nonatomic, assign) int incrementalLoadCount;
@property (nonatomic, assign) int dynamicWorldFailedToLoadWaitCountTimer;
@property (nonatomic, assign) BOOL loadComplete;



@property (nonatomic, assign) intpair startPortalPos;
@property (nonatomic, retain) WindowInfo* windowInfo;
@property (nonatomic, retain) Weather* weather;
@property (nonatomic, assign) CustomRules customRules;
@property (nonatomic, retain) NSMutableDictionary* customRulesDict;
@property (nonatomic, assign) float expertMode;







@property (nonatomic, retain) Tutorial* tutorial;
@property (nonatomic, retain) CloudInterface* cloudInterface;
@property (nonatomic, retain) UIManager* uiManager;
@property (nonatomic, assign) int loadedVersion;

@end