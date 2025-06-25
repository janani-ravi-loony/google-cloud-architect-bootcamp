#################################
# Cloud Functions
#################################

# These APIs are already enabled on my account

# From the navigation menu go to "APIs & Services" -> Dashboard -> Enable API & Services

# In search write "Cloud Function" and enable the Cloud Function API 

# In search write "Cloud Build" and enable the Cloud Build API

# From the side navigation go to "Cloud Functions" and click on it


########################################################
########################################################
### Triggering Cloud Functions with Storage Events

# Create a bucket

# Click on the hamburger menu and go to "Storage" -> "Bucket" -> "Create Bucket"

name: loony-cf-src-bucket

# Expand the options and quickly explain

# Keep everything as it is and click on "Create"


# Create the destination bucket

name: loony-cf-dest-bucket

# Keep everything as it is and click on "Create"

# Keep the buckets open in one tab

---------------

# Go back to cloud functions > Create Function

function name : resize-image
Region : we will use the default one
Trigger : Cloud storage
Event type : google.cloud.storage.object.v1.finalized
Bucket : loony-cf-src-bucket

# Choose the Python 3.12 runtime and change the main.py to the following:

# Click on Create

# Now change the main.py to the following:

# main.py
import functions_framework
from google.cloud import storage
from PIL import Image, ImageOps
import io

storage_client = storage.Client()
dest_bucket_name = "loony-cf-dest-bucket" 

@functions_framework.cloud_event
def resize_image(cloud_event):
    """
    This function is triggered by a Cloud Storage event.
    It downloads the newly uploaded image, resizes it, 
    and uploads the resized version to a destination bucket.
    """
    data = cloud_event.data
    
    bucket_name = data["bucket"]
    file_name = data["name"]
    
    print(f"Bucket: {bucket_name}")
    print(f"File: {file_name}")

    # Download the file from the source bucket
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    file_contents = blob.download_as_bytes()
    print(f"Downloaded file: {file_name}")

    # Open the image using Pillow, converting to RGB to handle different formats
    image = Image.open(io.BytesIO(file_contents)).convert("RGB")

    # Apply resizing
    resized_image = image.resize((256, 256))

    # Save the resized image to an in-memory buffer in PNG format
    buffer = io.BytesIO()
    resized_image.save(buffer, format="PNG")
    buffer.seek(0)

    # Prepare to upload to the destination bucket
    dest_bucket = storage_client.bucket(dest_bucket_name)
    # Create a new file name for the resized image
    # Note: We append .png because we are saving in PNG format
    new_file_name = f"resized_{file_name.split('.')[0]}.png"
    dest_blob = dest_bucket.blob(new_file_name)

    # Upload the buffer's content to the new blob, specifying the content type
    dest_blob.upload_from_file(buffer, content_type="image/png")
    
    print(f"Uploaded resized image as '{new_file_name}' to destination bucket: {dest_bucket_name}")


entry_point: resize_image

# requirements.txt
functions-framework==3.*
google-cloud-storage
Pillow

# In Cloud Function "Deploy" the function

-------------------
# Go to Cloud Storage Buckets

# https://unsplash.com/photos/an-aerial-view-of-a-city-with-tall-buildings-D4Og4wYSArQ

# Upload buildings.jpg to the bucket

# Note the size of the image

# Click through and show the image

# Go to the destination bucket

-----------------

# Try one more

# https://unsplash.com/photos/a-close-up-of-a-flower-on-a-tree-branch-q2_FIOXIPq8

# Now upload "flowers.jpg" to the bucket (Observe it is a huge image)

# In Cloud Function "Logs" and observe the recent logs

# Show resized_flowers.jpg

