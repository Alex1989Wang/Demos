//
//  misc.c
//  Caculator
//
//  Created by JiangWang on 17/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#include <stdio.h>
#include <ctype.h>
#include "getch.h"
#include "misc.h"

int getop(char s[]) {
    int i, temp;
    while ((temp = getch()) == ' ' || 
	    temp == '\t') {
	//ignore blank space
    }
	//not a number
    if (!isdigit(temp) && temp != '.') {
	return temp; 
    }

    //complet number
    s[0] = temp; //first digit;
    i = 0;
    if (isdigit(temp)) {
	while(isdigit(s[++i] = temp = getch()));
    }

    if (temp == '.') {
	while(isdigit(s[++i] = temp = getch()));
    }
    s[i] = '\0';
    if (temp != EOF) {
        ungetcharacter(temp);
    }
    return NUMBER;
}
