#include <oci/descriptor.h>
#include <string.h>
#include <util/strsafe.h>
#include <util/json/builder.h>
#include <util/json/basic_types.h>
#include <stdlib.h>

void oci_content_descriptor_to_json(struct oci_content_descriptor *desc, char **out_buf) {
    char *itoa_buf;

    clrstr(out_buf);

    json_build_property_str(out_buf, mediaType, desc->media_type)

    json_build_property_str(out_buf, digest, desc->digest)

    json_build_property_toa(out_buf, size, desc->size, i64)

    if(desc->urls != NULL)
        json_build_property_array(out_buf, urls, desc->urls)

    json_build_property_map(out_buf, annotations, desc->annotations)

    if(desc->data != NULL) {
        json_build_property_str(out_buf, data, desc->data)
    }

    if(desc->artifact_type != NULL) {
        json_build_property_str(out_buf, artifactType, desc->artifact_type)
    }

    json_end_object(out_buf)
}