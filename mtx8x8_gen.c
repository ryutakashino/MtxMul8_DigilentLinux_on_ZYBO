#include <stdio.h>
#include <stdlib.h>

int main () {
   int i,j, n;
   time_t t;
   
   n = 8;
   
   /* Intializes random number generator */
   srand((unsigned) time(&t));

   /* Print 32 random numbers from 0 to 49 */

    for( i = 0 ; i < n ; i++ ) {
        for(j = 0 ; j < n ; j++ ) {    
            printf("%d\n", rand() % 50);
        }
    }
    for( i = 0 ; i < n ; i++ ) {
        for( j = 0 ; j < n ; j++ ) {    
            printf("%d\n", rand() % 50);
        }
    }
    printf("\n");    
      //rslt register is 32bit, so input data is under 14bit to avoid overflow.[(32-3)/2]
   
   return(0);
}  