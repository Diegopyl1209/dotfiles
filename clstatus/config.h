#pragma once

#include "./components/components.h"

struct arg {
  void* (*function)(void*);
  const char *fmt;
  const char *args;
  const int refresh; // only used in run_command
};


#define MAXLEN 128 // max len per module
#define MAX_STATUS_LEN 1024
#define DATE_INTERVAL_SECS 60
#define WAIT_FOR_STATE // if defined the program will wait until all process update at least one time

static const struct arg args[] = {
  //{run_command, "%s", "echo aaa", 5},
  {volume, "^c#68755a^  ^c#a7a7a7^ %d%% |"},
  {datetime, "^c#5b6976^   ^c#a7a7a7^%A, %b %d,%l:%M %p^c#a7a7a7^ "}
};
