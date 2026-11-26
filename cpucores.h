// cpucores.h  -  logical CPU count for QB64PE  (Windows, Linux, macOS)
//
// Put this file in the same folder as MakeX16Movie.bas and add:
//
//    Declare Library "cpucores"
//        Function cpu_cores& ()
//    End Declare
//
// cpu_cores returns the number of logical processors, never less than 1.

#ifndef CPUCORES_H
#define CPUCORES_H

#include <stdint.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

inline int32_t cpu_cores() {
    int32_t n = 0;
#ifdef _WIN32
    SYSTEM_INFO si;
    GetSystemInfo(&si);
    n = (int32_t)si.dwNumberOfProcessors;
#else
    long v = sysconf(_SC_NPROCESSORS_ONLN);
    n = (int32_t)v;
#endif
    if (n < 1) n = 1;
    return n;
}

#endif
