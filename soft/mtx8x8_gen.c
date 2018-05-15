#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_VAL 4096

int main () {
   int i,j, n;
   time_t t;
   
   n = 8;
   
   /* Intializes random number generator */
   srand((unsigned) time(&t));

   /* Print 64*2 random numbers from 0 to MAX_VAL */

    for( i = 0 ; i < n ; i++ ) {
        for(j = 0 ; j < n ; j++ ) {    
            printf("%d ", rand() % MAX_VAL);
        }
        printf("\n");
    }
    for( i = 0 ; i < n ; i++ ) {
        for( j = 0 ; j < n ; j++ ) {    
            printf("%d ", rand() % MAX_VAL);
        }
        printf("\n");
    }
    printf("\n");    
      //rslt register is 32bit, so input data is under 14bit to avoid overflow.[(32-3)/2]
   
   return(0);
}  
