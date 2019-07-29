#include <stdio.h>
#include <math.h>

extern "C" bit [7:0] sqrt(bit [7:0] x){
  return floor(sqrt((x)));
}
