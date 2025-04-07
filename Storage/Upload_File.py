from azure.storage.blob import BlobServiceClient

# Variables
connection_string = "DefaultEndpointsProtocol=https;AccountName=sampledhaapps01;AccountKey=CVJ6Gv8kwB5nfrtSAymCZmTWdg/Oq78K6ddg8T+XiMbFrZjDFXeVOm/mkivP5oJTwm99MIAbhgVK+AStvl9xHw==;EndpointSuffix=core.windows.net"
container_name = "samplecontainer"

try:
    # Create the BlobServiceClient
    blob_service_client = BlobServiceClient.from_connection_string(connection_string)

    # Attempt to create a container
    container_client = blob_service_client.create_container(container_name)
    print(f"Container '{container_name}' created successfully.")

except Exception as e:
    print(f"Failed to create container: {str(e)}")
