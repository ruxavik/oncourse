//
//  OCCourse.h
//  OnCourse
//
//  Created by East Agile on 10/31/12.
//  Copyright (c) 2012 oncourse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCCourse : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *metaInfo;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, assign) int progress;

@end