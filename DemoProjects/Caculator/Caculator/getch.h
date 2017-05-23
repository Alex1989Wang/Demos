//
//  getch.h
//  Caculator
//
//  Created by JiangWang on 17/05/2017.
//  Copyright © 2017 JiangWang. All rights reserved.
//

#ifndef getch_h
#define getch_h

#define BUFSIZE (100)

extern int bufp;
extern char buf[];

int getch(void);
void ungetcharacter(int);

#endif /* getch_h */
