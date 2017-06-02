//
//  PDStudentTableVCTableViewController.m
//  CoreData
//
//  Created by Lavrin on 5/2/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDStudentTableViewController.h"
#import "PDStudent.h"
#import "PDDataManager.h"
#import "PDInfoTVC.h"
#import "PDTableViewCell.h"

@interface PDStudentTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) PDInfoTVC *infoTVC;
@property (strong, nonatomic) PDStudent *editedStudent;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;


@end

@implementation PDStudentTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[PDDataManager sharedManager] deleteAllObjects];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Students";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target: self
                                  action:@selector(addStudentAction:)];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                   target:self action:@selector(editClicked:)];
    
    self.navigationItem.leftBarButtonItem = addButton;
    self.navigationItem.rightBarButtonItem = editButton;
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
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                     initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
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
    
    PDStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"configureCell %@", student.lastName);
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
    cell.detailTextLabel.text = student.email;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    PDTableViewCell *myCell = [[PDTableViewCell alloc]
//                               initWithStyle:UITableViewCellStyleValue1
//                               reuseIdentifier:@"cell1"];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PDInfoTVC *infoTVC = [storyboard instantiateViewControllerWithIdentifier:@"PDInfoTVC"];
    [infoTVC loadView];
    infoTVC.sections = 3;
    
//    PDTableViewCell *myCell = infoTVC.tableView c;
    self.infoTVC = infoTVC;
    
    PDStudent *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.editedStudent = student;
    NSArray *arrayStudyCourses = [student.courses allObjects];
    NSArray *arrayTeachCourses = [student.teachCourses allObjects];

    NSString *titleForStudy = [NSString stringWithFormat:@"%@ Studies Courses:", student.firstName];
    NSString *titleForTeach = [NSString stringWithFormat:@"%@ Teaches Courses:", student.firstName];

    infoTVC.contentsLabels = @[@"First Name", @"Last Name", @"Email"];
    infoTVC.contentsFields = @[student.firstName, student.lastName, student.email];
    infoTVC.coursesStudies = arrayStudyCourses;
    infoTVC.coursesTeaches = arrayTeachCourses;
    infoTVC.isStudentsFullList = YES;
    infoTVC.titlesForHeaders = @[@"Info", titleForStudy, titleForTeach];
    
//    NSLog(@"%@", student.firstName);
//    myCell.firstNameField.text = student.firstName;
//    infoTVC.lastNameField.text = student.lastName;
//    infoTVC.emailField.text = student.email;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                   target: self
                                   action:@selector(editDoneClicked:)];
    
    infoTVC.navigationItem.rightBarButtonItem = doneButton;

    

    [self.navigationController pushViewController:infoTVC animated:YES];
}

#pragma mark - Actions

- (void) addStudentAction: (UIBarButtonItem *) sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PDInfoTVC *infoTVC = [storyboard instantiateViewControllerWithIdentifier:@"PDInfoTVC"];
    infoTVC.modalPresentationStyle = UIModalPresentationFullScreen;
    infoTVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    infoTVC.sections = 1;
    infoTVC.contentsLabels = @[@"First Name", @"Last Name", @"Email"];
    self.infoTVC = infoTVC;
    
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

- (void) doneClicked: (UIBarButtonItem *) sender {
    
    NSManagedObjectContext *context = [[PDDataManager sharedManager] managedObjectContext];

    PDStudent *student = [NSEntityDescription insertNewObjectForEntityForName:@"PDStudent"
                                                       inManagedObjectContext:context];

    PDTableViewCell *cellFirstName = [self.infoTVC.tableView.visibleCells objectAtIndex: 0];
    PDTableViewCell *cellLastName  = [self.infoTVC.tableView.visibleCells objectAtIndex: 1];
    PDTableViewCell *cellEmail     = [self.infoTVC.tableView.visibleCells objectAtIndex: 2];

    student.firstName = cellFirstName.firstNameField.text;
    student.lastName = cellLastName.firstNameField.text;
    student.email = cellEmail.firstNameField.text;
    
    NSError *error = nil;

    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"%@", [error localizedDescription]);
    }
    [self.infoTVC dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) editDoneClicked: (UIBarButtonItem *) sender {

    PDTableViewCell *cellFirstName    = [self.infoTVC.tableView.visibleCells objectAtIndex: 0];
    PDTableViewCell *cellLastName     = [self.infoTVC.tableView.visibleCells objectAtIndex: 1];
    PDTableViewCell *cellEmail        = [self.infoTVC.tableView.visibleCells objectAtIndex: 2];

    PDStudent *student = self.editedStudent;
    
    student.firstName  = cellFirstName.firstNameField.text;
    student.lastName = cellLastName.firstNameField.text;
    student.email = cellEmail.firstNameField.text;
    
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"%@", [error localizedDescription]);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 0;
//}
//


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
