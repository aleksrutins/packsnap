#include <util/array.h>

void _array_push__internal_(struct array *arr, void *item) {
    if(arr->items == NULL) 
    arr->items = realloc(arr->items, ((++arr->length) + 1) * arr->item_size);
    *(arr->items + arr->length - 1) = *item;
}