#include <pthread.h>
#include <string.h>

#include "util.h"
#include "config.h"
#include "backend.h"

char statusText[MAX_STATUS_LEN];
pthread_mutex_t statusMutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t statusCond = PTHREAD_COND_INITIALIZER;
int updated = 0;

char argsTexts[LEN(args)][MAXLEN] = {{""}};

void update_status_text() {
  pthread_mutex_lock(&statusMutex);

#ifdef WAIT_FOR_STATE
  for (int i = 0; i < LEN(args); i++) {
	if (argsTexts[i][0] == '\0') {
	  pthread_mutex_unlock(&statusMutex);
	  return;
	}
  }
#endif

  statusText[0] = '\0';
  for (int i = 0; i < LEN(args); i++) {
	strncat(statusText, argsTexts[i], sizeof(statusText) - strlen(statusText) - 1);
  }

  updated = 1;
  pthread_cond_signal(&statusCond);
  pthread_mutex_unlock(&statusMutex);
}


void main_loop() {
  for (;;) {
	pthread_mutex_lock(&statusMutex);
	while (!updated) {
	  pthread_cond_wait(&statusCond, &statusMutex);
	}
	updated = 0;

	char local[MAX_STATUS_LEN];
	strncpy(local, statusText, sizeof(local));
	local[sizeof(local)-1] = '\0';

	pthread_mutex_unlock(&statusMutex);

	backend.write_status(local);
  }
}
