/*
REQUIRED_ARGS: -HC -c -o-
PERMUTE_ARGS:
TEST_OUTPUT:
---
// Automatically generated by Digital Mars D Compiler

#pragma once

#include <assert.h>
#include <math.h>
#include <stddef.h>
#include <stdint.h>

#ifdef CUSTOM_D_ARRAY_TYPE
#define _d_dynamicArray CUSTOM_D_ARRAY_TYPE
#else
/// Represents a D [] array
template<typename T>
struct _d_dynamicArray final
{
    size_t length;
    T *ptr;

    _d_dynamicArray() : length(0), ptr(NULL) { }

    _d_dynamicArray(size_t length_in, T *ptr_in)
        : length(length_in), ptr(ptr_in) { }

    T& operator[](const size_t idx) {
        assert(idx < length);
        return ptr[idx];
    }

    const T& operator[](const size_t idx) const {
        assert(idx < length);
        return ptr[idx];
    }
};
#endif

struct S final
{
    union
    {
        int32_t x;
        char c[4$?:32=u|64=LLU$];
    };
    struct
    {
        int32_t y;
        double z;
        void bar();
    };
    struct
    {
        int32_t outerPrivate;
    };
    struct
    {
        int32_t innerPrivate;
        int32_t innerBar;
    };
    S() :
        y(),
        z(),
        outerPrivate(),
        innerPrivate(),
        innerBar()
    {
    }
    S(int32_t y, double z = NAN, int32_t outerPrivate = 0, int32_t innerPrivate = 0, int32_t innerBar = 0) :
        y(y),
        z(z),
        outerPrivate(outerPrivate),
        innerPrivate(innerPrivate),
        innerBar(innerBar)
        {}
};

extern void foo();
---
*/

extern (C++) struct S
{
    union
    {
        int x;
        char[4] c;
    }

    struct
    {
        int y;
        double z;
        extern(C) void foo() {}
        extern(C++) void bar() {}
    }

    // Private not emitted because AnonDeclaration has no protection
    private struct
    {
        int outerPrivate;
    }

    public struct {
        // Private cannot be exported to C++
        private int innerPrivate;
        int innerBar;
    }
}

extern (D)
{
    extern(C++) void foo() {}
}