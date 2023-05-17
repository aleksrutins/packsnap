#include <oci/descriptor.h>
#include <string.h>
#include <util/strsafe.h>

void oci_content_descriptor_to_json(struct oci_content_descriptor *desc, char *out_buf) {
    if(out_buf != NULL) free(out_buf);
    out_buf = malloc(1 * sizeof(char));
    out_buf[0] = 0;
    strcat_s(out_buf, "{ \"mediaType\": \"");
    strcat_s(out_buf, desc->media_type);
    strcat_s(out_buf, "\", \"digest\": \"");
    strcat_s(out_buf, desc->digest);
    strcat_s(out_buf, "\"");

    strcat_s(out_buf, "}");
}