//
//  PDCourse+CoreDataProperties.h
//  CoreData
//
//  Created by Lavrin on 5/6/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PDCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDCourse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSString *field;
@property (nullable, nonatomic, retain) NSSet<PDStudent *> *students;
@property (nullable, nonatomic, retain) PDStudent *lecturer;

@end

@interface PDCourse (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(PDStudent *)value;
- (void)removeStudentsObject:(PDStudent *)value;
- (void)addStudents:(NSSet<PDStudent *> *)values;
- (void)removeStudents:(NSSet<PDStudent *> *)values;

@end

NS_ASSUME_NONNULL_END
