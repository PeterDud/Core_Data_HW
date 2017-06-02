//
//  PDDataManager.h
//  CoreData
//
//  Created by Lavrin on 5/2/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext, NSManagedObjectModel, NSPersistentStoreCoordinator, PDStudent;

@interface PDDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (PDDataManager *) sharedManager;

- (PDStudent *) addRandomStudent;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) deleteAllObjects;

@end
