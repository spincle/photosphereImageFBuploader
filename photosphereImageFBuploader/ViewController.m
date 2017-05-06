//
//  ViewController.m
//  photosphereImageFBuploader
//
//  Created by Tom Tong on 6/5/2017.
//  Copyright © 2017 Tom Tong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* fbBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    fbBtn.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2);
    [fbBtn setImage:[UIImage imageNamed:@"fb_share.png"] forState:UIControlStateNormal];
    [fbBtn addTarget:self action:@selector(fbButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:fbBtn];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)fbButtonClicked:(UIButton *)button
{
    PhotoMetadataInjector* injector = [[PhotoMetadataInjector alloc] init];
    UIImage* image = [UIImage imageNamed:@"sample.jpg"];
    NSURL* url = [injector addMetaData:image];
    NSData* data = [NSData dataWithContentsOfURL:url];
    UIActivityViewController *controller =  [[UIActivityViewController alloc] initWithActivityItems:@[data] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
