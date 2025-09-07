#pragma once

#include "config.h"

#define LEN(array) (sizeof(array) / sizeof(array[0]))
#define FORMAT_ARGS(args) (*(struct ThreadArg *)args)

extern char argsTexts[LEN(args)][MAXLEN];

void update_status_text();
void main_loop();

struct ThreadArg {
  int index;
  const char *fmt;
  const char *args;
  int refresh;
};
