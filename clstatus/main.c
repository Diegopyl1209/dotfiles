#include <pthread.h>
#include <stdlib.h>

#include "backend.h"
#include "util.h"
#include "config.h"


int main() {
  backend.init();

  for (int i = 0; i < LEN(args); i++) {
    pthread_t argThread;
    struct ThreadArg *targs = malloc(sizeof(struct ThreadArg));
    *targs = (struct ThreadArg){.index = i,
                                .fmt = args[i].fmt,
                                .args = args[i].args,
                                .refresh = args[i].refresh};
    pthread_create(&argThread, NULL, args[i].function, targs);
  }

  main_loop();

  backend.deinit();

  return 0;
}
