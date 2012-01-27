//
//  FlipCounterView.h
//  FlipCounter
//

#import <UIKit/UIKit.h>

@class FlipCounterViewDigitSprite;
@protocol FlipCounterViewDelegate;

@interface FlipCounterView : UIView
{
    @private
    NSMutableArray* topFrames;
    NSMutableArray* bottomFrames;
    int numTopFrames;
    int numBottomFrames;
    
    NSMutableArray* digits;
    
    BOOL isAnimating;
    int numDigitsToDraw;
    int lastNumDigitsToDraw;
    
    int rawCounterValue;
    int addQueue;
}

+ (CGSize) sizeForNumberOfDigits:(int)digitCount;

@property (readwrite,nonatomic,unsafe_unretained) id<FlipCounterViewDelegate> delegate;

- (void) add:(int)amount;
- (void) subtract:(int)amount;

- (void) setCounterValue:(NSUInteger) value; // bladekim. 2012.1.26

- (void) distributedAdd:(int)amount overSeconds:(NSTimeInterval)seconds withNumberOfIterations:(int)numIterations;
- (int) counterValue;

@end



@interface FlipCounterViewDigitSprite : NSObject
{
    @private
    int currentFrame;
}

- (id)initWithOldValue:(NSUInteger)o
              newValue:(NSUInteger)n
              frameTop:(NSUInteger)ft
           frameBottom:(NSUInteger)fb;

@property (readwrite,nonatomic,assign) NSUInteger topIndex;
@property (readwrite,nonatomic,assign) NSUInteger bottomIndex;
@property (readwrite,nonatomic,assign) NSUInteger oldValue;
@property (readwrite,nonatomic,assign) NSUInteger newValue;

- (int) incr:(int)inc;

- (BOOL) nextFrame:(int)from
                to:(int)to
      numTopFrames:(int)numTopFrames
   numBottomFrames:(int)numBottomFrames;

@end


@protocol FlipCounterViewDelegate <NSObject>

@optional

- (void) flipCounterView:(FlipCounterView*)flipCounterView didExpand:(CGSize)newSize;

@end