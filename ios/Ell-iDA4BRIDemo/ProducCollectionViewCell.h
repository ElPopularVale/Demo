

#import <UIKit/UIKit.h>

@interface ProducCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak) IBOutlet UIImageView *productImageView;
@property(nonatomic, weak) IBOutlet UILabel *productName;
@property(nonatomic, weak) IBOutlet UILabel *productPrice;

@end
