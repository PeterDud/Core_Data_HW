//
//  PDCoursesTVC.h
//  CoreData
//
//  Created by Lavrin on 5/4/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDCoreDataVC.h"
#import "PDCourse.h"
#import "PDInfoTVC.h"

@class PDInfoTVC;

@interface PDCoursesTVC : PDCoreDataVC <NSFetchedResultsControllerDelegate>

@property (assign, nonatomic) BOOL isStudentsList;
@property (assign, nonatomic) BOOL isTeachersList;
@property (strong, nonatomic) PDCourse *editedCourse;
@property (strong, nonatomic) PDInfoTVC *editedController;

@end
