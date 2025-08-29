#import <Foundation/Foundation.h>

@class CPCache;
@class World;

@class GLfloat;

struct Clouds {};
struct Cloud {};
struct CloudTextures {};
struct CPTexture2D {};
struct NoiseFunction {};
struct MJMultiSounds {};

@class WindowInfo;
@class Shader;
@class MJSound;
@class MJMultiSound;
@class FNImageData;
@interface Weather : NSObject;

@property(nonatomic, retain) CPCache* cache;
@property(nonatomic, retain) World* world;
@property(nonatomic, retain) GLfloat* snowPoints;
@property(nonatomic, retain) GLfloat* rainPoints;
@property(nonatomic, retain) GLfloat* cloudPoints;
@property(nonatomic, assign) Clouds clouds;
@property(nonatomic, assign) int cloudQuadCount;
@property(nonatomic, assign) CloudTextures* cloudTextures;
@property(nonatomic, assign) NoiseFunction* cloudNoiseFunction;
@property(nonatomic, assign) BOOL cloudsLoadedAsHD;
@property(nonatomic, assign) float timeElapsed;
@property(nonatomic, assign) float timeElapsedCloud;
@property(nonatomic, assign) float* randomNumbers;
@property(nonatomic, assign) int snowRandomNumberIndex;
@property(nonatomic, assign) int rainRandomNumberIndex;
@property(nonatomic, assign) int recalcRandomIndex;
@property(nonatomic, assign) uint rainXOffset;
@property(nonatomic, assign) uint rainYOffset;
@property(nonatomic, assign) uint rainZOffset;
@property(nonatomic, assign) WindowInfo* windowInfo;
@property(nonatomic, assign) Shader* snowShader;
@property(nonatomic, assign) Shader* rainShader;
@property(nonatomic, assign) Shader* cloudShader;
@property(nonatomic, assign) MJSound* lightRainSound;
@property(nonatomic, assign) MJSound* heavyRainSound;
@property(nonatomic, assign) MJSound* undergroundSound;
@property(nonatomic, assign) MJSound* windSound;
@property(nonatomic, assign) MJMultiSounds birdsSound;
@property(nonatomic, assign) MJMultiSounds cricketSound;
@property(nonatomic, assign) float desiredOceanSoundLevel;
@property(nonatomic, assign) float desiredBirdSoundLevel;
@property(nonatomic, assign) BOOL soundPaused;
@property(nonatomic, assign) float randomBirdTimer;
@property(nonatomic, assign) float lastSetUndergroundMix;
@property(nonatomic, assign) int lastCloudCalcualtionRoundedTranslation;
@property(nonatomic, assign) float cloudWindOffset;
@property(nonatomic, assign) BOOL cloudGoingRight;
@property(nonatomic, assign) float cloudDirectionChangeTimer;
@property(nonatomic, assign) float windMovement;
@property(nonatomic, assign) FNImageData* cloudColorForegroundImageData;
@property(nonatomic, assign) FNImageData* cloudColorForegroundCloudyImageData;
@property(nonatomic, assign) FNImageData* cloudColorBackgroundImageData;
@property(nonatomic, assign) FNImageData* cloudColorBackgroundCloudyImageData;

struct vec4;
struct vec2;
struct GLKMatrix4;

- (vec4)cloudColorForWeatherFraction:(float)weatherFraction timeOfDayFraction:(float)timeOfDayFraction isBackground:(BOOL)isBackground;
- (void)dealloc;
- (id)initWithCache:(CPCache*)cache_ world:(World*)world_ worldTime:(float)worldTime;
- (void)loadCricketSounds;
- (void)renderCloudWithMatrix:(GLKMatrix4)matrix translation:(vec2)translation dt:(float)dt weatherFraction:(float)weatherFraction futureWeatherFraction:(float)futureWeatherFraction timeOfDayFraction:(float)timeOfDayFraction;
- (void)renderWithMatrix:(GLKMatrix4)matrix pinchScale:(float)pinchScale withDayColor:(vec4)dayColor rainFraction:(float)rainFraction snowFraction:(float)snowFraction snowLevel:(float)snowLevel;
- (void)setSoundPaused:(BOOL)soundPaused_;
- (void)setWindMovement:(float)windMovement;
- (void)update:(float)dt rainFraction:(float)rainFraction snowFraction:(float)snowFraction;
//- (void)updateBirdSoundWithBirdFraction
- (void)updateCloudsForLoadOrHDTexturesChange;
- (void)updateCloudsWithTranslation:(float)roundedTranslation;
// - (void)updateRainSoundWithRainFraction
- (float)windStrength;

@end