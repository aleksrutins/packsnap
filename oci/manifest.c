#include <oci/manifest.h>

#include <stdlib.h>

#include <oci/descriptor.h>
#include <util/strutil.h>
#include <util/strsafe.h>
#include <util/json/builder.h>
#include <util/json/basic_types.h>

void oci_image_manifest_to_json(struct oci_image_manifest *manifest, char **out_buf) {
    clrstr(out_buf);

    json_start_object(out_buf)
    json_build_property_toa(out_buf, schemaVersion, manifest->schema_version, i)
    json_build_property_str(out_buf, mediaType, manifest->media_type)
    if(manifest->artifact_type != NULL) json_build_property_str(out_buf, artifactType, manifest->artifact_type)
    json_build_property_convert(out_buf, descriptor, manifest->descriptor, oci_content_descriptor)
    
    
}