//
//  AppDelegate.m
//  beckV2
//
//  Created by yj on 15/5/15.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "AppDelegate.h"
#import "Position.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "AlipayObj.h"
#import "CoreNewFeatureVC.h"
#import "CALayer+Transition.h"
#import "WechatObj.h"
#import "MobClick.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
@interface AppDelegate ()<WXApiDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *clmanager;
@end

@implementation AppDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"hello");
    //打印出精度和纬度
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
//    NSLog(@"输出当前的精度和纬度");
    NSLog(@"精度：%f 纬度：%f",coordinate.latitude,coordinate.longitude);
    CLGeocoder *code=[[CLGeocoder alloc] init];
    [code reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark*mark=placemarks[0];
        NSLog(@"%@%@%@",mark.country,mark.subLocality,mark.thoroughfare);
        [self getAB];
    }];

}


-(void)getAB{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL , nil);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
    });
//    __block BOOL accessGranted = NO;
//    if (ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//        
//    }) != NULL) {
//        
//        // we're on iOS 6
//        NSLog(@"on iOS 6 or later, trying to grant access permission");
//        
//        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//            accessGranted = granted;
//            dispatch_semaphore_signal(sema);
//        });
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_release(sema);
//    }
//    else { // we're on iOS 5 or older
//        
//        NSLog(@"on iOS 5 or older, it is OK");
//        accessGranted = YES;
//    }
//    
//    if (accessGranted) {
//        
//        NSLog(@"we got the access right");
//    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[SQLManager sharedSingle] openDB];
    [WeiboSDK registerApp:kSinaAppKey];
    [WeiboSDK enableDebugMode:YES];
    [MobClick startWithAppkey:@"559159f867e58e93a2004063" reportPolicy:BATCH   channelId:nil];
    [WXApi registerApp:kWXAPP_ID withDescription:@"beck"];
    
    
    NSString * titleid=[[Global sharedSingle] getUserWithkey:@"titleid"];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"fontValue"]==0) {
        [[NSUserDefaults standardUserDefaults] setInteger:15 forKey:@"fontValue"];
    }
    if (titleid==nil) {
        NSArray *tts=[[SQLManager sharedSingle] getTitles];
        Position *select=[tts lastObject];
        for (Position*pt in tts) {
            if (pt.is_vaild.intValue) {
                select=pt;
            }
        }

        Position*p=select;
        
        [[Global sharedSingle] setUserValue:p.titleId Key:@"titleid"];
        [[Global sharedSingle] setUserValue:p.titleName Key:@"titleName"];
    }
    if([CoreNewFeatureVC canShowNewFeature]){
        
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:@"f1"]];
        
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:@"f2"]];
        
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:@"f3"]];
        NewFeatureModel *m4 = [NewFeatureModel model:[UIImage imageNamed:@"f4"]];

        self.window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3,m4] enterBlock:^{
            [self enter];
        }];
    }else{
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *vc=[sb instantiateInitialViewController];
        self.window.rootViewController = vc;
    }
    
    self.clmanager= [[CLLocationManager alloc] init];
    self.clmanager.delegate=self;
    
    if ([self.clmanager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.clmanager requestWhenInUseAuthorization];
    }
    [self.clmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.clmanager.distanceFilter = 10;
    [self.clmanager startUpdatingLocation];
    return YES;
}

-(void)enter{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc=[sb instantiateInitialViewController];
    self.window.rootViewController = vc;
    [self.window.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRamdom curve:TransitionCurveLinear duration:1.0f];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
             [AlipayObj sharedSingle].block(resultDic);
             
         }];
        return YES;
    }

    if ([TencentOAuth CanHandleOpenURL:url]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([sourceApplication isEqualToString:@"com.sina.weibo"]){
       return [WeiboSDK handleOpenURL:url delegate:self.loginVC];
    }
    else  {
        return [ WXApi handleOpenURL:url delegate:[WechatObj sharedSingle]];
    }

    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [ WXApi handleOpenURL:url delegate:[WechatObj sharedSingle]];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.yihaodian.onethestore.TestCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Beck.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
