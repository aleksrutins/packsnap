#pragma once

#include <util/strutil.h>
#include <util/json/basic_types.h>

#define json_start_object(out_buf) strcat_s(out_buf, "{");

#define json_build_property_str(out_buf, name, value) { \
    strcat_s(out_buf, "\"" #name "\": \""); \
    strcat_s(out_buf, desc->media_type); \
    strcat_s(out_buf, "\","); \
}

#define json_build_property_toa(out_buf, name, value, t) { \
    char *toa_buf = t##toa(value); \
    strcat_s(out_buf, ", \"" #name "\": \""); \
    strcat_s(out_buf, toa_buf); \
    strcat_s(out_buf, "\""); \
    free(toa_buf); \
}

#define json_build_property_convert(out_buf, name, value, t) { \
    char *buf; \
    t##_to_json(value, &buf); \
    strcat_s(out_buf, "\"" #name "\": "); \
    strcat_s(out_buf, buf); \
    strcat_s(out_buf, ","); \
}

#define json_build_property_array(out_buf, name, value) json_build_property_convert(out_buf, name, value, array);

#define json_build_property_map(out_buf, name, value) json_build_property_convert(out_buf, name, value, map);

#define json_end_object(out_buf) { \
    *((*out_buf) + (strlen(*out_buf) - 1)) = 0; \
    strcat_s(out_buf, "}"); \
}