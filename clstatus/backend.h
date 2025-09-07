#pragma once

typedef struct {
	void (*init)(void);
	void (*deinit)(void);
	void (*write_status)(const char *status);
} StatusBackend;


extern StatusBackend backend;
