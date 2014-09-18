//
//  main.cpp
//  Blowfish
//
//  Created by Jin on 9/17/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#include "TestRunner.h"

int main(int /*argc*/, const char ** /*argv[]*/)
{

    TestRunner* tr = [TestRunner new];
    [tr run];
    [tr release];
    return 0;
}

