//
//  APPAppDelegate.h
//  FTT GUI
//
//  Created by Philip Xu on 6/27/14.
//  Copyright (c) 2014 ApplicoInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


// Core Data objects 
@property (readonly, nonatomic, strong) NSManagedObjectContext          *managedObjectContext;
@property (readonly, nonatomic, strong) NSManagedObjectModel            *managedObjectModel;
@property (readonly, nonatomic, strong) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

-(void)saveContext;
-(NSURL* )applicationDocumentsDirectory;
@end
