//
//  PDCoursesTVC.m
//  CoreData
//
//  Created by Lavrin on 5/4/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDCoursesTVC.h"
#import "PDInfoTVC.h"
#import "PDTableViewCell.h"
#import "PDDataManager.h"
#import "PDCourse.h"
#import "PDStudent.h"
#import "PDStudent+CoreDataProperties.h"

@interface PDCoursesTVC ()

@property (strong, nonatomic) PDInfoTVC *infoTVC;
@property (strong, nonatomic) PDCourse *selectedCourse;
@property (strong, nonatomic) NSIndexPath *myIndexPath;
@property (strong, nonatomic) PDCourse *course;
@end


@implementation PDCoursesTVC
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Courses";

    if (self.isStudentsList == NO) {
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target: self
                                      action:@selector(addCourseAction:)];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                       target:self action:@selector(editClicked:)];
        
        self.navigationItem.leftBarButtonItem = addButton;
        self.navigationItem.rightBarButtonItem = editButton;
    }
}


#pragma mark - NSFetchedResultsControllerDelegate and related methods

- (NSFetchedResultsController *) fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PDCourse"
                                              inManagedObjectContext:self.managedObjectContext];
    
    if (self.isStudentsList) {
        entity = [NSEntityDescription entityForName:@"PDStudent"
                                                  inManagedObjectContext:self.managedObjectContext];
    }
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    //    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    //    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext
                                                             sectionNameKeyPath:nil
                                                             cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


#pragma mark - UITableViewDelegate and related methods

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isStudentsList) {
        
        PDStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];

        if (!self.editedCourse) {
            return;
        }
        
        NSArray *array = [self getAllStudentsWithPredicate:self.editedCourse];
        
        NSSet *set = [NSSet setWithArray:array];
        
        if ([set containsObject:student]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return;
    }
    
//    if (self.isTeachersList) {
//        
//        NSArray *array = [self getAllStudentsWithPredicate:self.editedCourse];
//        
//        NSSet *set = [NSSet setWithArray:array];
//        
//        PDStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        
//        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
//        
//        if ([set containsObject:student]) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        } else {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        
//        return;
//
//    }
    
    PDCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"configureCell %@", course.name);
    
    cell.textLabel.text = course.name;
    cell.detailTextLabel.text = course.lecturer.lastName;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isStudentsList) {
        
        PDStudent *selectedStudent = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (!self.isTeachersList) {
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [self.editedCourse addStudentsObject:selectedStudent];
                
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self.editedCourse removeStudentsObject:selectedStudent];
            }
        } else {
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                
                [self.editedCourse setLecturer:selectedStudent];
                
                for (UITableViewCell *cell in self.tableView.visibleCells) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self.editedCourse setLecturer:nil];
            }
        }
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PDInfoTVC *infoTVC = [storyboard instantiateViewControllerWithIdentifier:@"PDInfoTVC"];
    [infoTVC loadView];
    
    self.infoTVC = infoTVC;
    
    PDCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.editedCourse = course;
    
    infoTVC.contentsLabels = @[@"Name", @"Subject", @"Field", @"Lecturer"];
    infoTVC.contentsFields = @[course.name, course.subject, course.field];
    infoTVC.titlesForHeaders = @[@"Course", @"Students"];
    infoTVC.editedCourse = course;
//    NSArray* studentsArray = [self getAllStudentsWithPredicate: course];
    NSPredicate* pred = [NSPredicate predicateWithFormat:
                         @"courses contains %@", course];
    infoTVC.myPredicate = pred;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                   target: self
                                   action:@selector(editDoneClicked:)];
    
    infoTVC.navigationItem.rightBarButtonItem = doneButton;
    
    [self.navigationController pushViewController:infoTVC animated:YES];
    
    self.myIndexPath = indexPath;

    self.selectedCourse = course;
}

#pragma mark - Actions

- (void) addCourseAction: (UIBarButtonItem *) sender {
    
    NSManagedObjectContext *context = [[PDDataManager sharedManager] managedObjectContext];
    PDCourse *course = [NSEntityDescription insertNewObjectForEntityForName:@"PDCourse"
                                                     inManagedObjectContext:context];
    self.editedCourse = course;
    
//    self.course = course;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PDInfoTVC *infoTVC = [storyboard instantiateViewControllerWithIdentifier:@"PDInfoTVC"];
    infoTVC.modalPresentationStyle = UIModalPresentationFullScreen;
    infoTVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    infoTVC.myPredicate = [NSPredicate predicateWithFormat:@"courses contains %@", course];
    infoTVC.contentsLabels = @[@"Name", @"Subject", @"Field", @"Lecturer"];
    infoTVC.editedCourse = course;
    
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:infoTVC];
    
    [self presentViewController: navController
                       animated:YES
                     completion:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                   target: self
                                   action:@selector(doneClicked:)];
    
    infoTVC.navigationItem.rightBarButtonItem = doneButton;
    
    self.infoTVC = infoTVC;
    //    [self.navigationController pushViewController:infoTVC animated:YES];
    //
    //    [infoTVC dismissViewControllerAnimated:YES completion:nil];
    //
}

- (void) editClicked: (UIBarButtonItem *) sender {
    
    BOOL isAnimating = self.tableView.editing;
    
    UIBarButtonSystemItem item;
    
    if (isAnimating == NO) {
        [self.tableView setEditing:YES animated:YES];
        item = UIBarButtonSystemItemDone;
    } else {
        [self.tableView setEditing:NO animated:YES];
        item = UIBarButtonSystemItemEdit;
    }
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: item
                                  target:self
                                  action:@selector(editClicked:)];
    
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void) doneClicked: (UIBarButtonItem *) sender {
    
//    NSManagedObjectContext *context = [[PDDataManager sharedManager] managedObjectContext];
//    
//    PDCourse *course = [NSEntityDescription insertNewObjectForEntityForName:@"PDCourse"
//                                                       inManagedObjectContext:context];
    PDCourse *course = self.editedCourse;
    
    PDTableViewCell *cellName         = [self.infoTVC.tableView.visibleCells objectAtIndex: 0];
    PDTableViewCell *cellSubject      = [self.infoTVC.tableView.visibleCells objectAtIndex: 1];
    PDTableViewCell *cellField        = [self.infoTVC.tableView.visibleCells objectAtIndex: 2];
    PDTableViewCell *cellLecturer     = [self.infoTVC.tableView.visibleCells objectAtIndex: 3];

    NSRange rangeOfSpace = [cellLecturer.nameLebal.text rangeOfString:@" "];
    NSString *lastName = [cellLecturer.nameLebal.text substringFromIndex:
                                                rangeOfSpace.location + rangeOfSpace.length];
    
    course.name = cellName.firstNameField.text;
    course.subject = cellSubject.firstNameField.text;
    course.field = cellField.firstNameField.text;
    course.lecturer.lastName = lastName;

    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"%@", [error localizedDescription]);
    }
    [self.infoTVC dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) editDoneClicked: (UIBarButtonItem *) sender {
    
    PDTableViewCell *cellName = [self.infoTVC.tableView.visibleCells objectAtIndex: 0];
    PDTableViewCell *cellSubject  = [self.infoTVC.tableView.visibleCells objectAtIndex: 1];
    PDTableViewCell *cellField     = [self.infoTVC.tableView.visibleCells objectAtIndex: 2];
    PDTableViewCell *cellLecturer     = [self.infoTVC.tableView.visibleCells objectAtIndex: 3];

    PDCourse *course = self.editedCourse;
    
    NSRange rangeOfSpace = [cellLecturer.nameLebal.text rangeOfString:@" "];
    NSString *lastName = [cellLecturer.nameLebal.text substringFromIndex:
                          rangeOfSpace.location + rangeOfSpace.length];
    
    course.name  = cellName.firstNameField.text;
    course.subject = cellSubject.firstNameField.text;
    course.field = cellField.firstNameField.text;
    course.lecturer.lastName = lastName;

    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"%@", [error localizedDescription]);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doneListClicked: (UIBarButtonItem *) sender {
        
//    PDInfoTVC *infoTVC = [storyboard instantiateViewControllerWithIdentifier:@"PDInfoTVC"];
//    [infoTVC loadView];
//    
//    self.infoTVC = infoTVC;
//    
//    PDCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    self.editedCourse = course;
    
    _editedController.contentsLabels = @[@"Name", @"Subject", @"Field", @"Lecturer"];
    _editedController.contentsFields = @[_editedCourse.name, _editedCourse.subject, _editedCourse.field, _editedCourse.lecturer];
    _editedController.sections = 2;
    _editedController.titlesForHeaders = @[@"Course", @"Students"];
    NSArray* studentsArray = [self getAllStudentsWithPredicate: _editedCourse];
    
    _editedController.students = studentsArray;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                   target: self
                                   action:@selector(editDoneClicked:)];
    
    _editedController.navigationItem.rightBarButtonItem = doneButton;
    
    [self.navigationController popToViewController:_editedController animated:YES];
    
//    self.myIndexPath = indexPath;
//    
//    self.selectedCourse = course;

    
//    self.isStudentsList = NO;
//    [self tableView:self.tableView didSelectRowAtIndexPath:self.myIndexPath];
}

#pragma mark Custom Methods 

- (NSArray *) getAllStudentsWithPredicate: (PDCourse *) predicate {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"PDStudent"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:
                                                  @"courses contains %@", predicate];

    if (self.isTeachersList == YES) {
        
        pred = [NSPredicate predicateWithFormat:@"teachCourses contains %@", predicate];
    }
    
    [request setPredicate:pred];
    
    NSError* requestError = nil;
    NSArray* studentsArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];

    return studentsArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
