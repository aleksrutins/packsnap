#pragma once

#include <stdlib.h>

struct array {
    size_t item_size;
    size_t length;
    void *items;
};

#define array_new(t) (array { .item_size = sizeof(t), .length = 0, .items = NULL })
void _array_push__internal_(struct array *arr, void *item);
#define array_push(arr, item) _array_push__internal_(arr, &item)