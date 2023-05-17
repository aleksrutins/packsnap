#pragma once
#include <stdint.h>

struct oci_content_descriptor {
    /**
     * mediaType: string
     * 
     * This REQUIRED property contains the media type of the referenced content. Values MUST comply with RFC 6838, including the naming requirements in its section 4.2.
     * The OCI image specification defines several of its own MIME types for resources defined in the specification.
    */
    char *media_type;
    /**
     * digest: string
     * 
     * This REQUIRED property is the digest of the targeted content, conforming to the requirements outlined in Digests. Retrieved content SHOULD be verified against this digest when consumed via untrusted sources.
    */
    char *digest;
    /**
     * size: int64
     * 
     * This REQUIRED property specifies the size, in bytes, of the raw content. This property exists so that a client will have an expected size for the content before processing. If the length of the retrieved content does not match the specified length, the content SHOULD NOT be trusted.
    */
    int64_t size;
    /**
     * urls: array of strings
     * 
     * This OPTIONAL property specifies a list of URIs from which this object MAY be downloaded. Each entry MUST conform to RFC 3986. Entries SHOULD use the http and https schemes, as defined in RFC 7230.
    */
    char **urls;
    /**
     * annotations: string-string map
     * 
     * This OPTIONAL property contains arbitrary metadata for this descriptor. This OPTIONAL property MUST use the annotation rules.
    */
    char **annotations;
    /**
     * data: string
     * 
     * This OPTIONAL property contains an embedded representation of the referenced content. Values MUST conform to the Base 64 encoding, as defined in RFC 4648. The decoded data MUST be identical to the referenced content and SHOULD be verified against the digest and size fields by content consumers. See Embedded Content for when this is appropriate.
    */
    char *data;
    /**
     * artifactType string
     * 
     * This OPTIONAL property contains the type of an artifact when the descriptor points to an artifact. This is the value of the config descriptor mediaType when the descriptor references an image manifest. If defined, the value MUST comply with RFC 6838, including the naming requirements in its section 4.2, and MAY be registered with IANA.
    */
    char *artifactType;
};

/** This method will (re)allocate out_buf to the required length. */
void oci_content_descriptor_to_json(struct oci_content_descriptor *desc, char *out_buf);