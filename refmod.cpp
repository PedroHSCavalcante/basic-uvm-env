#include <stdio.h>

extern "C" bit [7:0] sqrt(bit [7:0] x){
  int d = 2;
  int s = 4;
  
  if(s>x){
    r = d/2; 
  } 	
  else{
    d = d+2;
    s = s+d+1;
    while(s <= x){
      d = d+2;
      s = s+d+1; 
    }
  }
  r = d/2
  return r;
}
