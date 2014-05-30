#                                               -*- Autoconf -*-
# `autoreconf -i` to generate missing files; `autoreconf` if do not need to create missing files

AC_PREREQ([2.69])
AC_INIT([wx], [0.1.1], [git.simpkins@gmail.com])
AM_INIT_AUTOMAKE([1.10 no-define foreign silent-rules parallel-tests])
AM_CFLAGS=-g -Wall -03
AC_CONFIG_SRCDIR([wx.c])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC
AC_PROG_CC_C99

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([inttypes.h stdlib.h string.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_TYPE_INT16_T
AC_TYPE_INT32_T
AC_TYPE_INT8_T
AC_TYPE_SIZE_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_TYPE_UINT8_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_CHECK_FUNCS([memset])

AC_CONFIG_FILES([Makefile])

AC_OUTPUT

# User Configure Completion Message
echo \
"------------------------------------------------------------

${PACKAGE_NAME} v.${PACKAGE_VERSION}

Configuration:

-- Compiler: '${CC} ${CFLAGS} ${CPPFLAGS}'

Type 'make && sudo make install' to build and install ${PACKAGE_NAME}

--------------------------------------------------------------
"
