

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "Product.h"
#import "Mannequin.h"

@interface MannequinViewController
    : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property(nonatomic, strong) IBOutlet iCarousel *carousel;
@property(weak, nonatomic) Mannequin *currentMannequin;
@property NSUInteger indexOfProduct;

@end
