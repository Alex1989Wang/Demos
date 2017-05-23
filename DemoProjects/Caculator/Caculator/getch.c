//
//  getch.c
//  Caculator
//
//  Created by JiangWang on 17/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#include "getch.h"
#include <stdio.h>

char buf[BUFSIZE];
int bufp = 0;
int getch(void) {
    return (bufp > 0) ?  buf[--bufp] : getchar();
}

void ungetcharacter(int character) {
    if (bufp >= BUFSIZE) {
        printf("ungetcharacter: too many characters \n");
    }
    else {
        buf[bufp++] = character;
    }
}
