#include "runtime.h"

void main() {
  int n = 0;
  while (n <= 14) {
    char message[] = "Hello ルリカ";
    putc(message[n++]);

    for (int i=0; i<999999; i++) {}
  }
  int j=4;
  j = 123332*j;
  println("\nFinished.\n");
}


