#pragma once

#include <stddef.h>

const char* read_constant_string();
const char* read_internal_string();
void write_internal_string(const char* string);
void write_external_string(char* string, size_t maxLength);
void execute_function(void(*function)(void*), void* context);
void set_time_in_seconds(int seconds);
void write_internal_time_in_seconds();
