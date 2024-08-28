# Copyright 2021-2023 FINCONS GROUP AG within the Horizon 2020
# European project SignON under grant agreement no. 101017255.

# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 

#     http://www.apache.org/licenses/LICENSE-2.0 

# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License.

#!/bin/bash

adminUsername=minioadmin
adminPassword=minioadmin
username=miniopipeline
password=minio22signon
userLicence=readwrite


# -------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------


inferenceAliasMinio=minio-inference-data
inferenceEndpoint=http://minio-inference:9000/
inferenceBucketName=signon-inference

# Check Alias has been created otherwise exit 1
if mc alias set $inferenceAliasMinio $inferenceEndpoint $adminUsername $adminPassword 2>/dev/null; then
    echo "Minio Inference is up and running."
else
    echo "Minio Inference is down."
    exit 1
fi

# Create Inference Bucket
buckets=$(mc ls $inferenceAliasMinio)
if [[ $buckets == *"$inferenceBucketName"* ]];
then
    echo "Bucket '$inferenceBucketName' already Exist"
else
    mc mb $inferenceAliasMinio/$inferenceBucketName
fi

# Create Inference Users
users=$(mc admin user list $inferenceAliasMinio)
if [[ $users == *"$username"* ]];
then
    echo "User '$username' already Exist"
else
    mc admin user add $inferenceAliasMinio $username $password
    mc admin policy set $inferenceAliasMinio $userLicence user=$username
fi


# -------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------


contributionAliasMinio=minio-contribution-data
contributionEndpoint=http://minio-contribution:9900/
contributionBucketName=signon-contribution

# Check Alias has been created otherwise exit 1
if mc alias set $contributionAliasMinio $contributionEndpoint $adminUsername $adminPassword 2>/dev/null; then
    echo "Minio Contribution is up and running."
else
    echo "Minio Contribution is down."
    exit 1
fi

# Create Contribution Bucket
buckets=$(mc ls $contributionAliasMinio)
if [[ $buckets == *"$contributionBucketName"* ]];
then
    echo "Bucket '$contributionBucketName' already Exist"
else
    mc mb $contributionAliasMinio/$contributionBucketName
fi

# Create Contribution Users
users=$(mc admin user list $contributionAliasMinio)
if [[ $users == *"$username"* ]];
then
    echo "User '$username' already Exist"
else
    mc admin user add $contributionAliasMinio $username $password
    mc admin policy set $contributionAliasMinio $userLicence user=$username
fi

mc admin console minio-contribution-data