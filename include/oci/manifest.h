#pragma once
#include "descriptor.h"

struct oci_image_manifest {
    /**
     * schemaVersion: int
     * 
     * This REQUIRED property specifies the image manifest schema version. For this version of the specification, this MUST be 2 to ensure backward compatibility with older versions of Docker. The value of this field will not change. This field MAY be removed in a future version of the specification.
    */
    int schema_version;
    /**
     * mediaType: string
     * 
     * This property SHOULD be used and remain compatible with earlier versions of this specification and with other similar external formats. When used, this field MUST contain the media type application/vnd.oci.image.manifest.v1+json. This field usage differs from the descriptor use of mediaType.
    */
    char *media_type;
    /**
     * artifactType: string
     * This OPTIONAL property contains the type of an artifact when the manifest is used for an artifact. This MUST be set when config.mediaType is set to the scratch value. If defined, the value MUST comply with RFC 6838, including the naming requirements in its section 4.2, and MAY be registered with IANA.
    */
    char *artifact_type;
    /**
     * config: descriptor
     * 
     * This REQUIRED property references a configuration object for a container, by digest. Beyond the descriptor requirements, the value has the following additional restrictions:
     *
     *  mediaType: string
     *  This descriptor property has additional restrictions for config. Implementations MUST support at least the following media types:
     *      application/vnd.oci.image.config.v1+json
     * 
     *  Manifests for container images concerned with portability SHOULD use one of the above media types. Manifests for artifacts concerned with portability SHOULD use config.mediaType as described in Guidelines for Artifact Usage.
     *  If the manifest uses a different media type than the above, it MUST comply with RFC 6838, including the naming requirements in its section 4.2, and MAY be registered with IANA.
     * 
     * To set an effectively NULL or SCRATCH config and maintain portability the following is considered GUIDANCE. While an empty blob (size of 0) may be preferable, practice has shown that not to be ubiquitiously supported. Instead, the blob payload can be the most minimal content that is still valid JSON object: {} (size of 2). The blob digest of {} is sha256:44136fa355b3678a1146ad16f7e8649e94fb4fc21fe77e8310c060f61caaff8a. See the example SCRATCH config below, and ScratchDescriptor of the reference code.
    */
    struct oci_content_descriptor descriptor;
    /**
     * layers: array of objects
     * 
     * Each item in the array MUST be a descriptor. For portability, layers SHOULD have at least one entry.
     * When the config.mediaType is set to application/vnd.oci.image.config.v1+json, the following additional restrictions apply:
     *  The array MUST have the base layer at index 0.
     *  Subsequent layers MUST then follow in stack order (i.e. from layers[0] to layers[len(layers)-1]).
     *  The final filesystem layout MUST match the result of applying the layers to an empty directory.
     *  The ownership, mode, and other attributes of the initial empty directory are unspecified.
     * 
     * For broad portability, if a layer is required to be used, use the SCRATCH layer. See the example SCRATCH layer below, and ScratchDescriptor of the reference code.
     * 
     * Beyond the descriptor requirements, the value has the following additional restrictions:
     *  mediaType: string
     *  This descriptor property has additional restrictions for layers[]. Implementations MUST support at least the following media types:
     *      application/vnd.oci.image.layer.v1.tar
     *      application/vnd.oci.image.layer.v1.tar+gzip
     *      application/vnd.oci.image.layer.nondistributable.v1.tar
     *      application/vnd.oci.image.layer.nondistributable.v1.tar+gzip
     *  Manifests concerned with portability SHOULD use one of the above media types. An encountered mediaType that is unknown to the implementation MUST be ignored.
     * 
     * Entries in this field will frequently use the +gzip types.
     * 
     * If the manifest uses a different media type than the above, it MUST comply with RFC 6838, including the naming requirements in its section 4.2, and MAY be registered with IANA.
     * See Guidelines for Artifact Usage for other uses of the layers.
    */
    struct oci_content_descriptor *layers;
    /**
     * subject: descriptor
     * 
     * This OPTIONAL property specifies a descriptor of another manifest. This value, used by the referrers API, indicates a relationship to the specified manifest.
    */
    struct oci_content_descriptor *subject;
    /**
     * annotations string-string map
     * 
     * This OPTIONAL property contains arbitrary metadata for the image manifest. This OPTIONAL property MUST use the annotation rules.
     * 
     * See Pre-Defined Annotation Keys.
    */
    char **annotations;
};

/** This method will (re)allocate out_buf to the required length. */
void oci_image_manifest_to_json(struct oci_image_manifest *manifest, char *out_buf);