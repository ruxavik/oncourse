//
//  OCCourseListingsViewController.m
//  OnCourse
//
//  Created by East Agile on 11/29/12.
//  Copyright (c) 2012 phatle. All rights reserved.
//

#import "OCCourseListingsViewController.h"
#import "OCCourseListingView.h"
#import "OCLectureListingsViewController.h"
#import "OCAppDelegate.h"
#import "OCUtility.h"
#import "OCCourseraCrawler.h"
#import "NSManagedObject+Adapter.h"

@interface OCCourseListingsViewController ()

@property (nonatomic, strong) OCCourseListingView *courseListingView;
@property (nonatomic, strong) OCLectureListingsViewController *lectureListingsViewController;

@end

@implementation OCCourseListingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.courseListingView = [[OCCourseListingView alloc] initWithFrame:self.view.frame];
    self.view = self.courseListingView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCourseListing
{
    self.courseListingView.listAllCourse = [NSManagedObject findEntities:@"Course" withPredicateString:nil andArguments:nil withSortDescriptionKey:nil];
    [self.courseListingView reloadData];
}

- (void)presentLectureViewController
{
    self.lectureListingsViewController = [OCLectureListingsViewController new];
    [self.navigationController pushViewController:self.lectureListingsViewController animated:YES];
}

@end
