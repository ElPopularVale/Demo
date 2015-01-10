

#import "StartViewController.h"
#import "HttpSender.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [HttpSender sendHttp:@"http://10.1.1.2:8888/commands/init"];
}

@end
