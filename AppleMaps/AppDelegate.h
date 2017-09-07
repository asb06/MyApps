//
//  AppDelegate.h
//  AppleMaps
//
//  Created by kishore kumar nagalla on 04/09/17.
//  Copyright © 2017 Pyramid SoftSol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


// line added in appdelegate

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

