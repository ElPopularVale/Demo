

#import "MannequinViewController.h"
#import "HttpSender.h"

@interface MannequinViewController ()

@property(weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *productDescriptionLabel;
@property(weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property(weak, nonatomic) IBOutlet UILabel *inStockLabel;
@property(weak, nonatomic) IBOutlet UIImageView *inStockBullet;
@property(weak, nonatomic) IBOutlet UIButton *tryItNowButton;
@property(weak, nonatomic) IBOutlet UISegmentedControl *sizeButtons;
@property(weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property Product *currentProduct;

@end

@implementation MannequinViewController

NSInteger lastIndex;

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  return NO;
}

- (void)awakeFromNib {
}

- (void)dealloc {
  _carousel.delegate = nil;
  _carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.carousel.type = iCarouselTypeCoverFlow;
  self.carousel.bounceDistance = 0.3f;
  self.carousel.currentItemIndex = self.indexOfProduct;
  lastIndex = self.carousel.currentItemIndex;

  [[self.tryItNowButton layer] setBorderWidth:1.0f];
  [[self.tryItNowButton layer] setMasksToBounds:YES];
  [[self.tryItNowButton layer]
      setBorderColor:[UIColor colorWithRed:80.0f / 255.0f
                                     green:146.0f / 255.0f
                                      blue:51.0f / 255.0f
                                     alpha:1.0f].CGColor];
  [[self.tryItNowButton layer] setCornerRadius:8.0f];
  [self.tryItNowButton setTintColor:[UIColor colorWithRed:80.0f / 255.0f
                                                    green:146.0f / 255.0f
                                                     blue:51.0f / 255.0f
                                                    alpha:1.0f]];
  self.productDescriptionLabel.text = @"";
  self.productNameLabel.text = @"";
  self.productPriceLabel.text = @"";

  Product *p = [self.currentMannequin.setOfProducts
      objectAtIndex:self.carousel.currentItemIndex];
  [self updateViewData:p];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
            (UIInterfaceOrientation)interfaceOrientation {
  return NO;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
  return self.currentMannequin.setOfProducts.count;
}

- (UIView *)carousel:(iCarousel *)carousel
    viewForItemAtIndex:(NSInteger)index
           reusingView:(UIView *)view {
  view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 300.0f)];
  Product *p = [self.currentMannequin.setOfProducts objectAtIndex:index];
  ((UIImageView *)view).image = p.productImage;
  view.contentMode = UIViewContentModeScaleAspectFit;

  view.layer.borderWidth = 2.0f;
  view.layer.borderColor = [UIColor colorWithRed:80.0f / 255.0f
                                           green:146.0f / 255.0f
                                            blue:51.0f / 255.0f
                                           alpha:1.0f].CGColor;
  view.layer.cornerRadius = 10.0f;
  view.layer.masksToBounds = YES;

  return view;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
  NSLog(@"Image %ld is selected.", (long)index);
}

- (CGFloat)carousel:(iCarousel *)carousel
     valueForOption:(iCarouselOption)option
        withDefault:(CGFloat)value {
  switch (option) {
  case iCarouselOptionSpacing: {
    return value * 0.4;
  }
  default: { return value; }
  }
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
  NSInteger index = carousel.currentItemIndex;
  self.currentProduct =
      [self.currentMannequin.setOfProducts objectAtIndex:index];
  if (index != lastIndex) {
    [self updateViewData:self.currentProduct];
  }
  lastIndex = index;
}

- (IBAction)sizeChanged:(id)sender {
  NSLog(@"Size button pressed: %ld",
        (long)self.sizeButtons.selectedSegmentIndex);
  switch (self.sizeButtons.selectedSegmentIndex) {
  case 0:
    self.currentProduct.productSize = @"L";
    break;
  case 1:
    self.currentProduct.productSize = @"M";
    break;
  case 2:
    self.currentProduct.productSize = @"S";
    break;
  default:
    break;
  }
}

- (IBAction)tryItNowPressed:(id)sender {
  [HttpSender
      sendHttp:[NSString stringWithFormat:
                             @"http://10.1.1.2:8888/highlight/shelves/%@-%@",
                             self.currentProduct.productName,
                             self.currentProduct.productSize]];
}

- (void)updateViewData:(Product *)p {

  NSLog(@"Current product: %@", p.productName);

  [UIView animateWithDuration:0.4
      animations:^{
          self.productDescriptionLabel.alpha = 0.0f;
          self.productNameLabel.alpha = 0.0f;
          self.productPriceLabel.alpha = 0.0f;
          self.inStockLabel.alpha = 0.0f;
          self.inStockBullet.alpha = 0.0f;
          self.tryItNowButton.alpha = 0.0f;
          self.sizeButtons.alpha = 0.0f;
          self.sizeLabel.alpha = 0.f;
      }
      completion:^(BOOL finished) {
          self.productDescriptionLabel.text = p.productDescription;
          self.productNameLabel.text = p.productName;
          self.productPriceLabel.text =
              [NSString stringWithFormat:@"€%.2f", p.productPrice];

          if ([self.currentProduct.productSize isEqualToString:@"L"]) {
            self.sizeButtons.selectedSegmentIndex = 0;
          } else if ([self.currentProduct.productSize isEqualToString:@"M"]) {
            self.sizeButtons.selectedSegmentIndex = 1;
          } else if ([self.currentProduct.productSize isEqualToString:@"S"]) {
            self.sizeButtons.selectedSegmentIndex = 3;
          }

          if (p.isInStock) {
            self.inStockLabel.text = @"In Stock";
            self.inStockBullet.image = [UIImage imageNamed:@"green_bullet.jpg"];
            [self.tryItNowButton setHidden:NO];
            [self.sizeButtons setHidden:NO];
            [self.sizeLabel setHidden:NO];
          } else {
            self.inStockLabel.text = @"Not Available";
            self.inStockLabel.textColor = [UIColor grayColor];
            self.inStockBullet.image = [UIImage imageNamed:@"gray_bullet.jpg"];
            [self.tryItNowButton setHidden:YES];
            [self.sizeButtons setHidden:YES];
            [self.sizeLabel setHidden:YES];
          }

          [UIView animateWithDuration:0.4
              animations:^{
                  self.productDescriptionLabel.alpha = 1.0f;
                  self.productNameLabel.alpha = 1.0f;
                  self.productPriceLabel.alpha = 1.0f;
                  self.inStockLabel.alpha = 1.0f;
                  self.inStockBullet.alpha = 1.0f;
                  self.tryItNowButton.alpha = 1.0f;
                  self.sizeButtons.alpha = 1.0f;
                  self.sizeLabel.alpha = 1.f;
              }
              completion:^(BOOL finished) { NSLog(@"finished transition"); }];
      }];
}

@end
