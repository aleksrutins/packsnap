#include <oci/descriptor.h>
#include <string.h>
#include <util/strsafe.h>
#include <util/strutil.h>
#include <util/json/basic_types.h>
#include <stdlib.h>

void oci_content_descriptor_to_json(struct oci_content_descriptor *desc, char **out_buf) {
    char *itoa_buf;

    clrstr(out_buf);

    strcat_s(out_buf, "{ \"mediaType\": \"");
    strcat_s(out_buf, desc->media_type);
    strcat_s(out_buf, "\"");

    strcat_s(out_buf, ", \"digest\": \"");
    strcat_s(out_buf, desc->digest);
    strcat_s(out_buf, "\"");

    itoa_buf = i64toa(desc->size);
    strcat_s(out_buf, ", \"size\": \"");
    strcat_s(out_buf, itoa_buf);
    strcat_s(out_buf, "\"");
    free(itoa_buf);

    if(desc->urls != NULL) {
        char *urls_buf;
        array_to_json(desc->urls, &urls_buf);
        strcat_s(out_buf, ", \"urls\": ");
        strcat_s(out_buf, urls_buf);
        free(urls_buf);
    }

    char *annotations_buf;
    map_to_json(desc->annotations, &annotations_buf);
    strcat_s(out_buf, ", \"annotations\": ");
    strcat_s(out_buf, annotations_buf);
    free(annotations_buf);

    if(desc->data != NULL) {
        strcat_s(out_buf, ", \"data\": \"");
        strcat_s(out_buf, desc->data);
        strcat_s(out_buf, "\"");
    }

    if(desc->artifact_type != NULL) {
        strcat_s(out_buf, ", \"artifactType\": \"");
        strcat_s(out_buf, desc->artifact_type);
        strcat_s(out_buf, "\"");
    }

    strcat_s(out_buf, "}");
}