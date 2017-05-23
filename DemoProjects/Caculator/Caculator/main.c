//
//  main.c
//  Caculator
//
//  Created by JiangWang on 17/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "calc.h"

#define MAXOP (100)

int main(int argc, const char * argv[]) {
    int type;
    double oprand2;
    char s[MAXOP];

    while((type = getop(s)) != EOF) {
	switch (type) {
	    case NUMBER: {
			     push(atof(s));
			     break;
			 }
            
        case '+': {
            push(pop() + pop());
            break;
		      }
        case '-': {
            oprand2 = pop();
            push(pop() - oprand2);
            break;
		      }
        case '*': {
            push(pop() * pop());
            break;
		      }
        case '/': {
            oprand2 = pop();
            if (oprand2 != 0.0) {
                push(pop() / oprand2);
            }
            else {
                printf("error: zero divisor");
            }
            break;
		      }
        case '\n': {
            printf("\t%.8g\n", pop());
            break;
        }
        default: {
            printf("error: unknow command.");
            break;
        }
    }
    }
}




