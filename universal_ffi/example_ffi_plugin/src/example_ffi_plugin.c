#include "example_ffi_plugin.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/// hello world
EXPORT char* hello(const char* text)
{
  char* buffer = (char*)malloc(strlen(text) + 8);
  sprintf(buffer, "Hello %s!", text);
  return buffer;
}

/// freeMemory
EXPORT void freeMemory(char* buffer)
{
  if (buffer) {
    free(buffer);
  }
}

/// size of an int
EXPORT int intSize()
{
  return (int)sizeof(int);
}

/// size of a bool
EXPORT int boolSize()
{
  return (int)sizeof(_Bool);
}

/// size of a pointer
EXPORT int pointerSize()
{
  return (int)sizeof(void*);
}
