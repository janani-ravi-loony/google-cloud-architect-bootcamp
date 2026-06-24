
############################################################
# Create bucket
############################################################

# Navigate to:Cloud Storage → Buckets → Create

# Bucket name:loony-test-access-bucket
# Choose where to store your data:Region → us-central1
# Storage class:Standard
# Leave all other settings as default.

# Click Create.

# Upload some data to the bucket


############################################################
# Create VM with no service account
############################################################


# Navigate to:
# Compute Engine → VM instances → Create instance

# Name:loony-vm
# Region:us-central1
# Zone:us-central1-a
# Machine type:E2 → e2-micro

# On the left sidebar click Security.
# Under Identity and API access:
# Service account → select "No service account"

# Click Create.

# SSH into VM
gcloud storage ls

# Try to access our specific photo bucket directly
gcloud storage ls gs://loony-test-access-bucket

# BOTH will not work


############################################################
# See default Compute Engine service account
############################################################

# Navigate to:
# IAM & Admin → Service Accounts

# IClick on the Edit (Pencil icon)
# Show that it has Editor access to the project!

# This is automatically created by Google when the project was made.
# It has very broad permissions and is shared across
# every VM in the project that uses it.

--------------

# Back to the VMs page

# Stop the VM and attach the default Compute Engine service account

# SSH into the VM again


gcloud storage ls gs://loony-test-access-bucket

# Try uploading a test file to the bucket
echo "test backup" > test-backup.txt
gcloud storage cp test-backup.txt gs://loony-test-access-bucket/

# Everything works

gcloud compute instances list

# This works too!

############################################################
# Create the custom service account 
############################################################

# Navigate to:
# IAM & Admin → Service Accounts → + Create service account

# Step 1 — Service account details:
# Service account name : loony-gcs-access-sa
# Service account ID   : loony-gcs-access-sa   (auto-fills)

# Click Create and continue.

# Assign roles:
# Cloud Storage → Storage Admin


--------------

# Back to the VMs page

# Stop the VM and attach the default Compute Engine service account

# SSH into the VM again

gcloud storage ls

gcloud storage ls gs://loony-test-access-bucket

gcloud storage buckets create gs://temp-test-bucket

# All this should work!

gcloud compute instances list

# This should NOT work.
