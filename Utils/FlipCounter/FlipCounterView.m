//
//  FlipCounterView.m
//  FlipCounter
//

#import "FlipCounterView.h"

#define FCV_FRAME_WIDTH 53
#define FCV_TOPFRAME_HEIGHT 39
#define FCV_BOTTOMFRAME_HEIGHT 64
#define FCV_FRAMERATE .05
#define FCV_BOTTOM_START_ROW 10

@interface FlipCounterView(Private)

- (void) loadImagePool;
- (void) carry:(int)overage base:(int)base;
- (void) animate;

@end


@implementation FlipCounterView

+ (CGSize) sizeForNumberOfDigits:(int)digitCount
{
    CGFloat w = digitCount * FCV_FRAME_WIDTH;
    CGFloat h = FCV_TOPFRAME_HEIGHT + FCV_BOTTOMFRAME_HEIGHT;
    return CGSizeMake(w, h);
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAccessibilityTraits:UIAccessibilityTraitUpdatesFrequently];
        [self setBackgroundColor:[UIColor clearColor]];
        [self loadImagePool];
        
        rawCounterValue = 0;
        lastNumDigitsToDraw = 0;
        
        digits = [[NSMutableArray alloc] initWithCapacity:10];
        FlipCounterViewDigitSprite* sprite = [[FlipCounterViewDigitSprite alloc] initWithOldValue:0 newValue:0 frameTop:0 frameBottom:0];
        [digits addObject:sprite];
        
        [self animate];
    }
    return self;
}


- (void) loadImagePool
{
    UIImage* sprite = [UIImage imageNamed:@"digits.png"];
    CGImageRef spriteRef = [sprite CGImage];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = FCV_FRAME_WIDTH;
    CGFloat topH = FCV_TOPFRAME_HEIGHT;
    CGFloat bottomH = FCV_BOTTOMFRAME_HEIGHT;
    
    int numCols = 4;
    int numRows = 20;
    
    numTopFrames = 3;
    int totalNumTopFrames = numTopFrames * 10;
    topFrames = [[NSMutableArray alloc] initWithCapacity:totalNumTopFrames];
    
    numBottomFrames = 4;
    int totalNumBottomFrames = numBottomFrames * 10;
    bottomFrames = [[NSMutableArray alloc] initWithCapacity:totalNumBottomFrames];
    
    int bottomRowStart = FCV_BOTTOM_START_ROW;
    for (int row=0; row!=numRows; ++row) {
        x = 0;
        BOOL isTopFrame = (row < bottomRowStart);
        CGFloat h = isTopFrame ? topH : bottomH;
        
        for (int col=0; col!=numCols; ++col) {
            if ((col == 3) && (isTopFrame)) continue; // ignore whitespace
            
            CGRect frameRect = CGRectMake(x, y, w, h);
            CGImageRef image = CGImageCreateWithImageInRect(spriteRef, frameRect);
            UIImage* imagePtr = [[UIImage alloc] initWithCGImage:image];
            
            if (isTopFrame) {
                [topFrames addObject:imagePtr];
            } else {
                [bottomFrames addObject:imagePtr];
            }
            
            CFRelease(image);
            
            x += w;
        }
        
        y += h;
    }
}

- (void)drawRect:(CGRect)rect
{
    if (numDigitsToDraw != lastNumDigitsToDraw) {
        if ([self.delegate respondsToSelector:@selector(flipCounterView:didExpand:)]) {
            CGSize s = CGSizeMake(FCV_FRAME_WIDTH*numDigitsToDraw, FCV_TOPFRAME_HEIGHT+FCV_BOTTOMFRAME_HEIGHT);
            [self.delegate flipCounterView:self didExpand:s];
        }
        lastNumDigitsToDraw = numDigitsToDraw;
    }
    
    for (int i=numDigitsToDraw-1; i!=-1; --i) {
        FlipCounterViewDigitSprite* sprite = [digits objectAtIndex:i];
        
        CGFloat x = (FCV_FRAME_WIDTH * (numDigitsToDraw - i)) - FCV_FRAME_WIDTH;
        
        UIImage* t = [topFrames objectAtIndex:sprite.topIndex];
        [t drawAtPoint:CGPointMake(x, 0)];
        
        UIImage* b = [bottomFrames objectAtIndex:sprite.bottomIndex];
        [b drawAtPoint:CGPointMake(x, FCV_TOPFRAME_HEIGHT)];
    }
}

- (int)counterValue
{
    return rawCounterValue;
}

- (void) setCounterValue:(NSUInteger) value
{
    int newDelta = value - rawCounterValue;

    [self add:newDelta];
}

- (void) carry:(int)overhang base:(int)base
{
    FlipCounterViewDigitSprite* sprite = nil;
    
    NSUInteger digitIndex = base + 1;
    if ([digits count] > digitIndex) {
        sprite = [digits objectAtIndex:digitIndex];
    } else {
        sprite = [[FlipCounterViewDigitSprite alloc] initWithOldValue:0
                                                             newValue:0
                                                             frameTop:0
                                                          frameBottom:0];
        [digits addObject:sprite];
    }
    
    int o = [sprite incr:overhang];
    
    if (o != 0) {
        [self carry:o base:digitIndex];
    }
}

- (void) add:(int)amount
{
    if (amount == 0) {
        return;
    }
    
    if ((rawCounterValue + amount) < 0) {
        return;
    }
    
    if (isAnimating) {
        addQueue += amount;
    } else {
        rawCounterValue += amount;
        
        FlipCounterViewDigitSprite* digitIndex = [digits objectAtIndex:0];
        
        int overhang = [digitIndex incr:amount];
        
        if (overhang != 0) {
            [self carry:overhang base:0];
        }
        
        [self animate];
    }
}

- (void)subtract:(int)amount
{
    [self add:-amount];
}

- (void) distributedAdd:(int)amount overSeconds:(NSTimeInterval)seconds withNumberOfIterations:(int)numIterations
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        // spread out the adds smoothly over time
        
        int partialAmount = amount / numIterations;
        int leftOver = amount % numIterations;
        
        for (int i=0; i!=numIterations; ++i) {
            [self add:((i == 0) ? leftOver : partialAmount)];
        }
    });
}

- (void) animate
{
    if (isAnimating) {
        return;
    }
    
    isAnimating = YES;
    
//        j=0     j=1     j=2     j=3
//    i=0 frame 1 -       -       -         s=0
//    i=1 frame 2 frame 1 -       -         s=0
//    i=2 frame 3 frame 2 frame 1 -         s=0
//    i=3 frame 4 frame 3 frame 2 frame 1   s=0
//    i=4 frame 5 frame 4 frame 3 frame 2   s=0
//    i=5 frame 6 frame 5 frame 4 frame 3   s=0
//    i=6 -       frame 6 frame 5 frame 4   s=1
//    i=7 -       -       frame 6 frame 5   s=2
//    i=8 -       -       -       frame 6   s=3
//    
//    total time: (9 * .05) seconds == .45 seconds
    
    numDigitsToDraw = [digits count];
    NSArray* sprites = [digits copy];
    NSTimeInterval frameRate = FCV_FRAMERATE;
    int numAnimationFrames = 6 + numDigitsToDraw-1;
    
    int s=0;
    for (int i=0; i!=numAnimationFrames; ++i) {
        for (int j=s; ((j != (i+1)) && (j != numDigitsToDraw) ); ++j) {
            FlipCounterViewDigitSprite* sprite = [sprites objectAtIndex:j];
            
            int from = sprite.oldValue;
            int to = sprite.newValue;
            if (from == to) continue; // skip sprites that have not changed
            
            BOOL complete = [sprite nextFrame:from
                                           to:to
                                 numTopFrames:numTopFrames
                              numBottomFrames:numBottomFrames];
            
            if (complete) {
                sprite.oldValue = to;
                ++s;
            }
        }
        
        [self setNeedsDisplay];
        NSDate* nextFrameTime = [NSDate dateWithTimeIntervalSinceNow:frameRate];
        [[NSRunLoop currentRunLoop] runUntilDate:nextFrameTime];
    }
    
    isAnimating = NO;
    
    if (0 != addQueue) {
        int q = addQueue;
        addQueue = 0;
        [self add:q];
    }
    [self setNeedsDisplay];
}

@end




@implementation FlipCounterViewDigitSprite

@synthesize oldValue=_oldValue;
@synthesize newValue=_newValue;
@synthesize topIndex=_topIndex;
@synthesize bottomIndex=_bottomIndex;

- (id)initWithOldValue:(NSUInteger)o newValue:(NSUInteger)n frameTop:(NSUInteger)ft frameBottom:(NSUInteger)fb
{
    self = [super init];
    if (self) {
        _oldValue = o;
        _newValue = n;
        _topIndex = ft;
        _bottomIndex = fb;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"(o:%d n:%d t:%d b:%d)", _oldValue, _newValue, _topIndex, _bottomIndex];
}

- (int) incr:(int)inc
{
    if (0 == inc) return 0;
    
    int overhang = inc / 10;
    int v = _newValue + (inc % 10);
    if (v > 9) {
        overhang += v / 10;
        v %= 10;
    } else if (v < 0) {
        v += 10;
        --overhang;
    }
    
    _newValue = v;
    return overhang;
}

- (BOOL) nextFrame:(int)from
                to:(int)to
      numTopFrames:(int)numTopFrames
   numBottomFrames:(int)numBottomFrames
{
    ++currentFrame;
    if (currentFrame > 5) {
        currentFrame = 0;
    }
    
    // top pattern: old 1, old 2, new 0
    // bottom pattern: old 1, new 2, new 3, new 0
    
    switch (currentFrame) {
        case 0:
            _topIndex = (from * numTopFrames) + 1;
            break;
        case 1:
            _topIndex = (from * numTopFrames) + 2;
            break;
        case 2:
            _topIndex = (to * numTopFrames) + 0;
            _bottomIndex = (from * numBottomFrames) + 1;
            break;
        case 3:
            _bottomIndex = (to * numBottomFrames) + 2;
            break;
        case 4:
            _bottomIndex = (to * numBottomFrames) + 3;
            break;
        case 5:
            _bottomIndex = (to * numBottomFrames) + 0;
            break;
            
        default:
            break;
    }
    
    return (currentFrame == 5);
}

@end