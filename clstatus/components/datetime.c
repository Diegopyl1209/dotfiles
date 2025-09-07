#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#include "../util.h"
#include "../config.h"

void *datetime(void *args) {
  struct ThreadArg targs = FORMAT_ARGS(args);
  static time_t rawtime;

  while (1) {
	time( &rawtime );
	struct tm *info = localtime(&rawtime);

	strftime(argsTexts[targs.index], MAXLEN, targs.fmt, info);

	update_status_text();
	sleep(DATE_INTERVAL_SECS);
  }

  free(args);
  return 0;
}
