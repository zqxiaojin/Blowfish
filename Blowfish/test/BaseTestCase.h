//
//  BaseTestCase.h
//  Blowfish
//
//  Created by Jin on 9/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//


@protocol TestCaseReporter <NSObject>

- (void)caseFinish;

@end

@protocol BaseTestCase <NSObject>


@property (nonatomic,assign)id<TestCaseReporter> reporter;

- (void)run:(NSArray*)array;

@end
