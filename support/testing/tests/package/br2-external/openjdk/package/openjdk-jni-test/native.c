#include "native.h"
#include <stdio.h>
#include <time.h>

// Pure native functions

#define CHAR_BUFFER_SIZE 256
static char buffer[CHAR_BUFFER_SIZE];

const char* read_constant_string()
{
	return "Hello from C";
}
const char* read_internal_string()
{
	return buffer;
}
void write_internal_string(const char* string)
{
	snprintf(buffer, CHAR_BUFFER_SIZE, "%s", string);
}
void write_external_string(char* string, size_t maxLength)
{
	snprintf(string, maxLength, "Set from C");
}
void execute_function(void(*function)(void*), void* context)
{
	function(context);
}
void set_time_in_seconds(int seconds)
{
	time_t timeToSet = seconds;
	stime(&timeToSet);
}
void write_internal_time_in_seconds()
{
	time_t systemTime = time(NULL);
	snprintf(buffer, CHAR_BUFFER_SIZE, "%u", systemTime);
}
