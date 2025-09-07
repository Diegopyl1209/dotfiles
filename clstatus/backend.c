#include <stdio.h>

#include "backend.h"

#ifdef X11
#include <X11/Xlib.h>
#include <stdlib.h>

Display *display = NULL;

void x11_init(void) {
  display = XOpenDisplay(NULL);
  if (!display) {
	fprintf(stderr, "XOpenDisplay failed\n");
	exit(1);
  }
}

void x11_deinit(void) {
  if (display) {
	XCloseDisplay(display);
	display = NULL;
  }
}

void x11_write(const char *status) {
  if (!display) return;
  Window root = DefaultRootWindow(display);
  XStoreName(display, root, status);
  XFlush(display);
}

StatusBackend backend = { x11_init, x11_deinit, x11_write };
#endif

#ifndef X11
void wayland_init(void) {}
void wayland_deinit(void) {}
void wayland_write(const char *status) {
  printf("%s\n", status);
  fflush(stdout);
}

StatusBackend backend = { wayland_init, wayland_deinit, wayland_write };
#endif
