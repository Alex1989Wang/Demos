//
//  stack.c
//  Caculator
//
//  Created by JiangWang on 17/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#include <stdio.h>
#include "stack.h"

static int sp = 0;
static double val[MAXVAL];

void push(double value) {
    if (sp < MAXVAL) {
        val[sp++] = value;
    }
    else {
        printf("error: stack full. Can't push %g\n", value);
    }
}

double pop(void) {
    if(sp > 0) {
        return val[--sp];
    }
    else {
        printf("error: stack empty.");
        return 0.f;
    }
}
