//
//  PDTeachersTVC.m
//  CoreData
//
//  Created by Lavrin on 5/6/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDTeachersTVC.h"
#import "PDStudent.h"
#import "PDCourse.h"
#import "PDInfoTVC.h"

@interface PDTeachersTVC ()

@end

@implementation PDTeachersTVC
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Lecturers";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
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
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    //    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    //    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[]];
    
//    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"lecturer"];
//    
//    [fetchRequest setPredicate: myPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                         initWithFetchRequest:fetchRequest
                                                         managedObjectContext:self.managedObjectContext
                                                         sectionNameKeyPath:@"field"
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

    PDCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *lecturerFullName = [NSString stringWithFormat:@"%@ %@",
                                  course.lecturer.lastName, course.lecturer.firstName];
    
    cell.textLabel.text = lecturerFullName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                 [course valueForKeyPath:@"lecturer.teachCourses.@count"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PDInfoTVC *infoTVC = [storyboard instantiateViewControllerWithIdentifier:@"PDInfoTVC"];
    [infoTVC loadView];
    infoTVC.sections = 3;
    
    //    PDTableViewCell *myCell = infoTVC.tableView c;
//    self.infoTVC = infoTVC;
    PDCourse *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    PDStudent *student = course.lecturer;
//    self.editedStudent = student;
    NSArray *arrayStudyCourses = [student.courses allObjects];
    NSArray *arrayTeachCourses = [student.teachCourses allObjects];
    
    NSString *titleForStudy = [NSString stringWithFormat:@"%@ Studies Courses:", student.firstName];
    NSString *titleForTeach = [NSString stringWithFormat:@"%@ Teaches Courses:", student.firstName];
    
    infoTVC.contentsLabels = @[@"First Name", @"Last Name", @"Email"];
    infoTVC.contentsFields = @[student.firstName, student.lastName, student.email];
    infoTVC.coursesStudies = arrayStudyCourses;
    infoTVC.coursesTeaches = arrayTeachCourses;
    infoTVC.isStudentsFullList = YES;
    infoTVC.isTeachersFullList = YES;
    infoTVC.titlesForHeaders = @[@"Info", titleForStudy, titleForTeach];
    
    [self.navigationController pushViewController:infoTVC animated:YES];
}

#pragma mark - UITableViewDataSource 

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo name];
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
