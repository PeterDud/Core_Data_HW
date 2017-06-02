//
//  PDStudent+CoreDataProperties.h
//  CoreData
//
//  Created by Lavrin on 5/6/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PDStudent.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDStudent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<PDCourse *> *courses;
@property (nullable, nonatomic, retain) NSSet<PDCourse *> *teachCourses;

@end

@interface PDStudent (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(PDCourse *)value;
- (void)removeCoursesObject:(PDCourse *)value;
- (void)addCourses:(NSSet<PDCourse *> *)values;
- (void)removeCourses:(NSSet<PDCourse *> *)values;

- (void)addTeachCoursesObject:(PDCourse *)value;
- (void)removeTeachCoursesObject:(PDCourse *)value;
- (void)addTeachCourses:(NSSet<PDCourse *> *)values;
- (void)removeTeachCourses:(NSSet<PDCourse *> *)values;

@end

NS_ASSUME_NONNULL_END
