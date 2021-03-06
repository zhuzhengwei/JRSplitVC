//
//  ViewController.m
//  testGesture
//
//  Created by José Roldán Jiménez on 19/4/15.
//  Copyright (c) 2015 com.roldanjimenez. All rights reserved.
//

#import "JRSplitVC.h"


#import "UIGestureRecognizer+functions.h"

@interface JRSplitVC () <UISplitViewControllerDelegate>
@property (strong, nonatomic) UIGestureRecognizer *longpres;
//@property CGPoint lastLongpress;
//@property CGPoint newLongpress;
//@property CGFloat last_fraction;



@end

@implementation JRSplitVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDelegate:self];
    [self testobserve];
    [self setPresentsWithGesture:YES];
    [self setPreferredPrimaryColumnWidthFraction:0.5];
    [self setMaximumPrimaryColumnWidth:self.view.frame.size.width];
    [self setMinimumPrimaryColumnWidth:0];
    [self setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
    
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.splitViewController showDetailViewController:nc
                                                sender:self];

//    [self setMaximumPrimaryColumnWidth:self.view.frame.size.width];

    _longpres = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                       action:@selector(longPres)];
//    [_longpres setMinimumNumberOfTouches:@0];
    if ([_longpres respondsToSelector:@selector(setMinimumNumberOfTouches:)]) {
        [_longpres setValue:0 forKey:@"numberOfTouchesRequired"];
    }
    [self.view addGestureRecognizer:_longpres];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)longPres
{
    CGFloat f = [_longpres fractionTouch];
    [self setPreferredPrimaryColumnWidthFraction:f];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

}
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size
          withTransitionCoordinator:coordinator];

    [self setMaximumPrimaryColumnWidth:size.width];
    [self setMinimumPrimaryColumnWidth:0];

}

#pragma mark - UISplitViewControllerDelegate
//- (UISplitViewControllerDisplayMode)targetDisplayModeForActionInSplitViewController:(UISplitViewController *)svc
//{
//
//    return UISplitViewControllerDisplayModeAllVisible;
//}

-(void)testobserve{

    //No funciona por el moomento
    [self addObserver:self.splitViewController
           forKeyPath:@"isCollapsed"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueMinusSetMutation
              context:nil];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
     NSLog(@"%@",keyPath);
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
}

//Funciona y está bastante guapo a mi gusto
// ¿no seria mejor idea insertar este método como una categoria?
-(void)insertDisplayModeButtonAnimated:(BOOL)animated
{
    if ([self.viewControllers count]>1) {
        UINavigationController *nc = [self.viewControllers objectAtIndex:[@1 integerValue]];
        if (nc) {
            UIViewController *vc   = [nc topViewController];
            if (vc) {
                [vc.navigationItem setLeftItemsSupplementBackButton:YES];
                [vc.navigationItem setLeftBarButtonItem:[self displayModeButtonItem]
                                               animated:animated];
                
            }
            
        }

    }
}
-(void)extractDisplayModeButtonAnimated:(BOOL)animated{
    if ([self.viewControllers count]>1) {
        UINavigationController *nc = [self.viewControllers objectAtIndex:[@1 integerValue]];
        if (nc) {
            UIViewController *vc   = [nc topViewController];
            if (vc) {
                [vc.navigationItem setLeftBarButtonItem:nil];
                [vc.navigationItem setLeftItemsSupplementBackButton:YES];
                
            }
            
        }
        
    }
    
}

@end
