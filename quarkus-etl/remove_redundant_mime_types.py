import json
import re

def clean_openapi_spec(openapi_spec):
    # Traverse the OpenAPI spec and remove all non-application/json content types
    if "paths" in openapi_spec:
        for path, path_item in openapi_spec["paths"].items():
            for method, method_item in path_item.items():
                # Clean requestBody if exists
                if "requestBody" in method_item and "content" in method_item["requestBody"]:
                    method_item["requestBody"]["content"] = {
                        key: value
                        for key, value in method_item["requestBody"]["content"].items()
                        if "application/json" in key
                    }

                # Clean responses if exists
                if "responses" in method_item:
                    for status_code, response in method_item["responses"].items():
                        if "content" in response:
                            response["content"] = {
                                key: value
                                for key, value in response["content"].items()
                                if "application/json" in key
                            }

    return openapi_spec


if __name__ == "__main__":
    input_file = "/src/main/openapi/source-api.json"
    with open(input_file, "r") as f:
        openapi_spec = json.load(f)
    cleaned_spec = clean_openapi_spec(openapi_spec)
    with open("/Users/lennartdamen/Documents/code/junkyard/quarkus-etl/src/main/openapi/source-api-cleaned.json", "w") as f:
        json.dump(cleaned_spec, f, indent=2)
