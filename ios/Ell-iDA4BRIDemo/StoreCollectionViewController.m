

#import "StoreCollectionViewController.h"
#import "ProducCollectionViewCell.h"
#import "Store.h"
#import "Product.h"
#import "HeaderCollectionReusableView.h"
#import "MannequinViewController.h"
#import <IndoorGuide/IGGuideManager.h>
#import "HttpSender.h"

@interface StoreCollectionViewController ()

    {
  IGGuideManager *guide;
  BOOL isInZone;
}

@property(nonatomic, strong) NSMutableArray *patternImagesArray;
@property(nonatomic, strong) Store *myStore;
@property Product *highlightedProduct;
@end

@implementation StoreCollectionViewController

static NSString *const reuseIdentifier = @"ProductCell";
NSString *lastZoneName;
bool tapped;

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Globe Hope Clothing";

  self.patternImagesArray = [NSMutableArray
      arrayWithArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"jpg"
                                                        inDirectory:nil]];

  self.myStore = [[Store alloc] init];

  guide = [IGGuideManager sharedManager];

  guide.positioningDelegate = self;
  [self loadNDpositioning];

  lastZoneName = @"";
  isInZone = NO;

  [HttpSender sendHttp:@"http://10.1.1.2:8888/highlight/mannequins/Ahto"];
  [HttpSender sendHttp:@"http://10.1.1.2:8888/highlight/mannequins/Vallila"];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  return NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  MannequinViewController *mvc = [segue destinationViewController];
  Product *p;
  NSIndexPath *indexPath;

  if (isInZone) {
    p = self.highlightedProduct;
  } else {
    indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
    p = self.myStore.productArray[indexPath.row];
  }

  Mannequin *m;
  NSUInteger indexOfProduct;
  int i;
  for (i = 0; i < self.myStore.mannequinArray.count; i++) {
    m = self.myStore.mannequinArray[i];
    indexOfProduct = [m.setOfProducts indexOfObject:p];
    if (indexOfProduct != NSNotFound) {
      break;
    }
  }
  NSLog(@"Product is in mannequin %d", i);

  mvc.currentMannequin = m;
  mvc.indexOfProduct = indexOfProduct;
  lastZoneName = m.name;
  isInZone = NO;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:
                 (UICollectionView *)collectionView {

  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

  return [self.myStore.productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ProducCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                forIndexPath:indexPath];

  // Layout for all cells
  cell.layer.cornerRadius = 10.0f;
  cell.productImageView.layer.borderWidth = 10.0f;
  cell.productImageView.layer.borderColor =
      [UIColor colorWithRed:230.0f / 255.0f
                      green:230.0f / 255.0f
                       blue:230.0f / 255.0f
                      alpha:1.0f].CGColor;

  // Get product from store
  Product *myProduct = [self.myStore.productArray objectAtIndex:indexPath.row];

  // Populate cell with product data
  cell.productName.text = myProduct.productName;
  cell.productPrice.text =
      [NSString stringWithFormat:@"€%.2f", myProduct.productPrice];
  cell.productImageView.image = myProduct.productImage;

  // If product is highlighted change cell color
  if (myProduct.isInteresting) {
    cell.layer.borderColor = [UIColor colorWithRed:93.0f / 255.0f
                                             green:157.0f / 255.0f
                                              blue:219.0f / 255.0f
                                             alpha:1.0f].CGColor;
    cell.layer.borderWidth = 5.0f;
  } else {
    cell.layer.borderColor = [UIColor colorWithRed:80.0f / 255.0f
                                             green:146.0f / 255.0f
                                              blue:51.0f / 255.0f
                                             alpha:1.0f].CGColor;
    cell.layer.borderWidth = 1.0f;
  }

  return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted
during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
        return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for
the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView
shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
        return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath
withSender:(id)sender {
        return NO;
}

- (void)collectionView:(UICollectionView *)collectionView
performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath
withSender:(id)sender {

}
*/

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
  UICollectionReusableView *reusableview = nil;

  if (kind == UICollectionElementKindSectionHeader) {
    HeaderCollectionReusableView *headerView =
        [collectionView dequeueReusableSupplementaryViewOfKind:
                            UICollectionElementKindSectionHeader
                                           withReuseIdentifier:@"HeaderView"
                                                  forIndexPath:indexPath];
    NSString *title =
        @"You might be interested in the following highlighted products:";
    headerView.headerTitle.text = title;

    reusableview = headerView;
  }

  return reusableview;
}

- (void)loadNDpositioning {
  [guide stopUpdates];

  ////Uncomment to access NDD file from Web
  // NSString *mapCode = @"5331-elli-2";
  // NSString *extension = @".ndd";
  // NSString *mapDataLocation = [NSString
  //    stringWithFormat:@"http://192.168.1.200:8080/%@%@", mapCode, extension];
  // NSURL *dataUrl = [NSURL URLWithString:mapDataLocation];
  //[guide setNDDUrl:dataUrl];

  NSString *pathToNDD =
      [[NSBundle mainBundle] pathForResource:@"5331-elli-2" ofType:@"ndd"];
  [guide setNDDPath:pathToNDD];

  //  guide.useAccelerometer = YES;
  //  guide.useCompass = YES;
  //  guide.useDeviceMotion = YES;

  [guide startUpdates];

  //  NSLog(@"Updates started");
  //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
  //                                                  message:@"Updates started
  //                                                  "
  //                                                 delegate:nil
  //                                        cancelButtonTitle:@"OK"
  //                                        otherButtonTitles:nil];
  //  [alert show];
}

- (void)guideManager:(IGGuideManager *)manager
        didEnterZone:(uint32_t)zone_id
                name:(NSString *)name {
  NSLog(@"Entered zone %@", name);
  NSString *lastMannequinName;

  if ([name isEqualToString:@"shelf"]) {
//    [HttpSender sendHttp:@"http://10.1.1.2:8888/highlight/mannequins/Ahto"];
    lastMannequinName = @"Ahto";
    self.highlightedProduct = self.myStore.highlightedProductsArray[0];
  } else if ([name isEqualToString:@"sofaside"]) {
//    [HttpSender sendHttp:@"http://10.1.1.2:8888/highlight/mannequins/Vallila"];
    lastMannequinName = @"Vallila";
    self.highlightedProduct = self.myStore.highlightedProductsArray[1];
  } else if ([name isEqualToString:@"otherside"]) {
//    [HttpSender sendHttp:@"http://10.1.1.2:8888/highlight/mannequins/Rokka"];
    lastMannequinName = @"Rokka";
    self.highlightedProduct = self.myStore.highlightedProductsArray[2];
  }

  isInZone = YES;

  if (lastZoneName != lastMannequinName) {
    [self performSegueWithIdentifier:@"toMannequinView" sender:self];
  }

  lastZoneName = lastMannequinName;

  //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
  //                                                    message:[NSString
  //                                                    stringWithFormat:@"Entered
  //                                                    zone %@", name]
  //                                                   delegate:nil
  //                                          cancelButtonTitle:@"OK"
  //                                          otherButtonTitles:nil];
  //    [alert show];
}

- (void)guideManager:(IGGuideManager *)manager
         didExitZone:(uint32_t)zone_id
                name:(NSString *)name {
  NSLog(@"Exited zone %@", name);

  NSString *lastMannequinName;

  if ([name isEqualToString:@"shelf"]) {
//    [HttpSender sendHttp:@"http://10.1.1.2:8888/lowlight/mannequins/Ahto"];
    lastMannequinName = @"Ahto";

  } else if ([name isEqualToString:@"sofaside"]) {
//    [HttpSender sendHttp:@"http://10.1.1.2:8888/lowlight/mannequins/Vallila"];
    lastMannequinName = @"Vallila";

  } else if ([name isEqualToString:@"otherside"]) {
//    [HttpSender sendHttp:@"http://10.1.1.2:8888/lowlight/mannequins/Rokka"];
    lastMannequinName = @"Rokka";
  }

  //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
  //                                                    message:[NSString
  //                                                    stringWithFormat:@"Exited
  //                                                    zone %@", name]
  //                                                   delegate:nil
  //                                          cancelButtonTitle:@"OK"
  //                                          otherButtonTitles:nil];
  //    [alert show];

  if (lastZoneName == lastMannequinName) {
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
}

@end
