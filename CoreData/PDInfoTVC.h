//
//  PDInfoTVC.h
//  CoreData
//
//  Created by Lavrin on 5/2/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCourse.h"
#import "PDCoursesTVC.h"

@interface PDInfoTVC : PDCoreDataVC <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

//@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
//@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
//@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) NSArray *contentsLabels;
@property (strong, nonatomic) NSArray *contentsFields;
@property (strong, nonatomic) NSArray *students;
@property (assign, nonatomic) int sections;
@property (strong, nonatomic) NSArray *titlesForHeaders;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) PDCourse *editedCourse;
@property (strong, nonatomic) PDInfoTVC *editedController;
@property (strong, nonatomic) NSPredicate *myPredicate;
@property (strong, nonatomic) NSArray *coursesStudies;
@property (strong, nonatomic) NSArray *coursesTeaches;
@property (assign, nonatomic) BOOL isStudentsFullList;
@property (assign, nonatomic) BOOL isTeachersFullList;
@property (strong, nonatomic) PDInfoTVC *infoTVC;

@end
