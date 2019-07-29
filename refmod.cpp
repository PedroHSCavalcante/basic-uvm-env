#include <stdio.h>
#include <math.h>

extern "C" double sqrt(double x){
  return floor(sqrt((x)));
}
