#include <pulse/pulseaudio.h>
#include <stdio.h>


#include "../util.h"

static void sink_cb(pa_context *c, const pa_sink_info *i, int eol, void *args) {
  struct ThreadArg targs = FORMAT_ARGS(args);
  if (eol > 0)
	return;
  if (i) {
	pa_volume_t vol = pa_cvolume_avg(&i->volume);
	int percent = (int)((vol * 100) / PA_VOLUME_NORM) + 1;

	sprintf(argsTexts[targs.index], targs.fmt, percent);
	update_status_text();
  }
}

static void subscribe_cb(pa_context *c, pa_subscription_event_type_t t, uint32_t idx, void *args) {
  pa_operation *o = pa_context_get_sink_info_by_index(c, idx, sink_cb, args);
  if (o)
	pa_operation_unref(o);
}

static void context_state_cb(pa_context *c, void *args) {
  if (pa_context_get_state(c) == PA_CONTEXT_READY) {
	pa_operation *o = pa_context_get_sink_info_list(c, sink_cb, args);
	if (o)
	  pa_operation_unref(o);
	pa_context_set_subscribe_callback(c, subscribe_cb, args);
	o = pa_context_subscribe(c, PA_SUBSCRIPTION_MASK_SINK, NULL, NULL);
	if (o)
	  pa_operation_unref(o);
  }
}


void *volume(void *args) {
  pa_mainloop *ml = pa_mainloop_new();
  pa_context *ctx = pa_context_new(pa_mainloop_get_api(ml), "VolumeWatcher");

  pa_context_set_state_callback(ctx, context_state_cb, args);
  pa_context_connect(ctx, NULL, 0, NULL);

  pa_mainloop_run(ml, NULL);

  pa_context_disconnect(ctx);
  pa_context_unref(ctx);
  pa_mainloop_free(ml);

  free(args);

  return 0;
}
