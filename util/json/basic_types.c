#include <util/json/basic_types.h>

#include <stdlib.h>
#include <string.h>

#include <util/strsafe.h>
#include <util/strutil.h>

void map_to_json(char **map, char **out_buf) {
    clrstr(out_buf);

    strcat_s(out_buf, "{");

    for(int i = 0; map[i] != NULL; i++) {
        strcat_s(out_buf, "\"");
        strcat_s(out_buf, map[i]);

        if(i % 2 == 0)
            strcat_s(out_buf, ":");
        else
            strcat_s(out_buf, ",");
    }
    *((*out_buf) + (strlen(*out_buf) - 1)) = 0; // remove trailing comma
    
    strcat_s(out_buf, "}");
}

void array_to_json(char **array, char **out_buf) {
    clrstr(out_buf);

    strcat_s(out_buf, "[");
    for(char *item = *array; item != NULL; item++) {
        strcat_s(out_buf, "\"");
        strcat_s(out_buf, item);
        strcat_s(out_buf, "\",");
    }
    *((*out_buf) + (strlen(*out_buf) - 1)) = 0; // remove trailing comma
    strcat_s(out_buf, "]");
}