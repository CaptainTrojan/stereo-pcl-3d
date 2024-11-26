import os
import sys
from google.cloud import storage

def download_blob(bucket_name, source_blob_name, destination_file_name):
    """Downloads a blob from the bucket."""
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(source_blob_name)
    blob.download_to_filename(destination_file_name)

    print(f"Blob {source_blob_name} downloaded to {destination_file_name}.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python download_from_gcs.py <gcs_path> <local_destination>")
        sys.exit(1)

    gcs_path = sys.argv[1]
    local_destination = sys.argv[2]

    # Parse the GCS path
    if not gcs_path.startswith("gs://"):
        print("Error: GCS path must start with 'gs://'")
        sys.exit(1)

    gcs_path = gcs_path[5:]
    bucket_name, source_blob_name = gcs_path.split("/", 1)

    # Download the file
    download_blob(bucket_name, source_blob_name, local_destination)