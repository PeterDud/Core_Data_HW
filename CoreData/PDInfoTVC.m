//
//  PDInfoTVC.m
//  CoreData
//
//  Created by Lavrin on 5/2/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDInfoTVC.h"
#import "PDTableViewCell.h"
#import "PDStudent.h"
#import "PDDataManager.h"
#import "PDStudentTableViewController.h"
#import "PDCoursesTVC.h"
#import "PDProfileTVC.h"

@interface PDInfoTVC ()

@property (assign, nonatomic) BOOL isStudentsList;
@property (strong, nonatomic) PDCoursesTVC *studentsList;

@end

@implementation PDInfoTVC
@synthesize fetchedResultsController = _fetchedResultsController;

//- (NSManagedObjectContext *) managedObjectContext {
//    
//    if (!_managedObjectContext) {
//        _managedObjectContext = [[PDDataManager sharedManager] managedObjectContext];
//    }
//    return _managedObjectContext;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.isStudentsList = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PDTableViewCell * cell =[self.tableView.visibleCells objectAtIndex:0];
    
    if (self.isStudentsFullList == NO) {
        
        [cell.firstNameField becomeFirstResponder];
    }

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchedResultsControllerDelegate and related methods

- (NSFetchedResultsController *) fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PDStudent"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    //    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    //    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[]];
    
    if (self.myPredicate) {
        [fetchRequest setPredicate:self.myPredicate];
    }
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


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isStudentsFullList) {
        return 3;
    }
    
    if (self.sections) {
        return self.sections;
    }
    
    NSLog(@"numberOfSectionsInTableView %lu", [[self.fetchedResultsController sections] count]+1);
    
    return [[self.fetchedResultsController sections] count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    NSLog(@"%lu", [sectionInfo numberOfObjects]);
//    return [sectionInfo numberOfObjects];

    if (self.isStudentsFullList) {
        if (section == 0) {
            return [self.contentsLabels count];
        } else if (section == 1) {
            return [self.coursesStudies count];
        } else if (section == 2) {
            return [self.coursesTeaches count];
        }
    }
    
    if (section == 0) {
        
        return [_contentsLabels count];
    } else if (section == 1) {
        id <NSFetchedResultsSectionInfo> sectionInfo=
        [self.fetchedResultsController sections][section-1];
        NSLog(@"%lu", [sectionInfo numberOfObjects]);
        return [sectionInfo numberOfObjects] + 1;
    }
    
    return 0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.titlesForHeaders objectAtIndex: section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Cell1";
    NSString *identifierStudent = @"Cell2";
    NSString *identifierLecturer = @"CellLecturer";
    
    PDTableViewCell *cell = nil;
    
    PDStudent *student = nil;
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1
                                                       inSection:indexPath.section - 1];
        
        student = [self.fetchedResultsController objectAtIndexPath: newIndexPath];
    }
    
    if (indexPath.section == 0) {
        
        if (self.isTeachersFullList) {
           
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStudent];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:identifierStudent];
            }
            cell.textLabel.text = self.contentsLabels[indexPath.row];
            cell.detailTextLabel.text = self.contentsFields[indexPath.row];
            
            return cell;
        }
        
        if (indexPath.row == 3) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:identifierLecturer];
            
            PDStudent *lecturer = self.editedCourse.lecturer;
            
            NSString *nameString = [NSString
                                    stringWithFormat:@"%@ %@", lecturer.firstName, lecturer.lastName];
            
            cell.lecturerLabel.text = @"Lecturer";
            cell.nameLebal.text = nameString;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([nameString containsString:@"null"]) {
                cell.nameLebal.text = @"Select Lecturer";
            }
            
            return cell;
        }

        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        cell.myLabel.text = self.contentsLabels[indexPath.row];
        cell.firstNameField.text = self.contentsFields[indexPath.row];
        
    
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStudent];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:identifierStudent];
        }
        if (self.isStudentsFullList) {
            
            if ([self.coursesStudies count] > 0) {
                PDCourse *course = self.coursesStudies[indexPath.row];
                cell.textLabel.text = course.name;
                
                return cell;
            }
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Select To Add Students";
            cell.detailTextLabel.text = nil;
            return cell;
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        cell.detailTextLabel.text = student.email;
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStudent];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:identifierStudent];
        }
        
        
        if ([self.coursesTeaches count]> 0) {
            PDCourse *course = self.coursesTeaches[indexPath.row];
            cell.textLabel.text = course.name;
            
            return cell;
        }
        

    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        
        [self saveEnteredInfo];
        
        PDCoursesTVC *studentsList = [[PDCoursesTVC alloc] init];
        
        studentsList.isStudentsList = YES;
        studentsList.isTeachersList = YES;

        studentsList.editedCourse = self.editedCourse;
        studentsList.editedController = self.editedController;
        UINavigationController *navContr = [[UINavigationController alloc]
                                            initWithRootViewController:studentsList];
        
        [self presentViewController: navContr
                           animated:YES
                         completion:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                       target: self
                                       action:@selector(doneListClicked:)];
        
        studentsList.navigationItem.rightBarButtonItem = doneButton;
        
        self.studentsList = studentsList;
    }
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        PDCoursesTVC *studentsList = [[PDCoursesTVC alloc] init];
        
        studentsList.isStudentsList = YES;
        studentsList.editedCourse = self.editedCourse;
        studentsList.editedController = self.editedController;
        UINavigationController *navContr = [[UINavigationController alloc]
                                            initWithRootViewController:studentsList];

//        [self.navigationController pushViewController:studentsList animated:YES];
        
        [self presentViewController: navContr
                           animated:YES
                         completion:nil];

        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                       target: self
                                       action:@selector(doneListClicked:)];
        
        studentsList.navigationItem.rightBarButtonItem = doneButton;

//        [self.navigationController pushViewController:studentsList animated:YES];
        
        self.studentsList = studentsList;
        
    } else if (indexPath.section == 1 && indexPath.row > 0) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PDProfileTVC *profileTVC = [storyboard instantiateViewControllerWithIdentifier:@"PDProfileTVC"];
        [profileTVC loadView];
        
//        self.infoTVC = infoTVC;
        
        NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1
                                                           inSection:indexPath.section - 1];
        
        PDStudent *student = [self.fetchedResultsController objectAtIndexPath:updatedIndexPath];

        profileTVC.contentsLabels = @[@"First Name", @"Last Name", @"Email"];
        profileTVC.contentsDetailLabels = @[student.firstName, student.lastName, student.email];
        
        [self.navigationController pushViewController:profileTVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {

        return 30;
    }
}

#pragma mark - UITableViewDataSource


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1
                                                       inSection:indexPath.section - 1];
        NSLog(@"indexPath %lu %lu", indexPath.section, indexPath.row);
        NSLog(@"updatedIndexPath %lu %lu", updatedIndexPath.section, updatedIndexPath.row);

        PDStudent *student = [self.fetchedResultsController
                              objectAtIndexPath:updatedIndexPath];
        
        [self.editedCourse removeStudentsObject:student];
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        [context deleteObject:[self.fetchedResultsController
//                               objectAtIndexPath:updatedIndexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark Custom Methods

- (NSArray *) getAllStudents {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"PDStudent"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    

    NSError* requestError = nil;
    NSArray* studentsArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (PDStudent *student in studentsArray) {
        
        NSString *string = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
        [array addObject: string];
    }
    
    
    return array;
}

- (void) saveEnteredInfo {

    PDCourse *course = self.editedCourse;
    
    PDTableViewCell *cellFirstName = [self.tableView.visibleCells objectAtIndex: 0];
    PDTableViewCell *cellLastName  = [self.tableView.visibleCells objectAtIndex: 1];
    PDTableViewCell *cellEmail     = [self.tableView.visibleCells objectAtIndex: 2];
    
    course.name = cellFirstName.firstNameField.text;
    course.subject = cellLastName.firstNameField.text;
    course.field = cellEmail.firstNameField.text;
    
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"%@", [error localizedDescription]);
    }
}


#pragma mark - Actions 

- (void) doneListClicked: (UIBarButtonItem *) sender {
    
    NSMutableArray *arrayCourse = [NSMutableArray arrayWithArray:self.contentsFields];
    
    arrayCourse[0] = self.editedCourse.name;
    arrayCourse[1] = self.editedCourse.subject;
    arrayCourse[2] = self.editedCourse.field;
    
    self.contentsFields = arrayCourse;
    
//    PDTableViewCell *cellFirstName = [self.tableView.visibleCells objectAtIndex: 0];
//    PDTableViewCell *cellLastName  = [self.tableView.visibleCells objectAtIndex: 1];
//    PDTableViewCell *cellEmail     = [self.tableView.visibleCells objectAtIndex: 2];
//
//    cellFirstName.firstNameField.text = self.editedCourse.name;
//    
//    NSLog(@"%@", self.editedCourse.name);
//    [self.tableView reloadData];
    
//    self.editedCourse.lecturer = 
    
    [self.studentsList dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSLog(@"sectionIndex %lu", sectionIndex);
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex+1] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex+1] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    NSLog(@"indexPath.section, indexPath.row %lu, %lu", indexPath.section, indexPath.row);
    
    NSIndexPath *updatedNewIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row + 1
                                                          inSection:newIndexPath.section + 1];
    NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                          inSection:indexPath.section + 1];

    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[updatedNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[updatedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:updatedIndexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:updatedIndexPath toIndexPath:updatedNewIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}







@end
