#ifdef WIN32
#define pipe(fds) _pipe(fds, 4096, _O_BINARY)
#endif
