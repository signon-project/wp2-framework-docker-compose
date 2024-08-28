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

export MINIO_ROOT_USER
export MINIO_ROOT_PASSWORD
export MINIO_ORCHESTRATOR_USER
export MINIO_ORCHESTRATOR_PASSWORD
export MINIO_WP3_USER
export MINIO_WP3_PASSWORD
export MINIO_WP4_USER
export MINIO_WP4_PASSWORD
export MINIO_WP5_USER
export MINIO_WP5_PASSWORD
export MINIO_HTTP_TRACE

username=miniopipeline
password=minio22signon
userLicence=readwrite

# -------------------------------------------------------------------------------------
# -------------------------------------------------------------------------------------

inferenceAliasMinio=minio-inference-data
inferenceEndpoint=http://minio-inference:9000/
inferenceBucketName=signon-inference



if mc alias set $inferenceAliasMinio $inferenceEndpoint $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD 2>/dev/null; then
    echo "Minio Inference is up and running."
else
    echo "Minio Inference is down."
    exit 1
fi


buckets=$(mc ls $inferenceAliasMinio)
if [[ $buckets == *"$inferenceBucketName"* ]];
then
    echo "Bucket '$inferenceBucketName' already Exist"
else
    mc mb $inferenceAliasMinio/$inferenceBucketName
fi

users=$(mc admin user list $inferenceAliasMinio)
if [[ $users == *"$username"* ]];
then
    echo "User '$username' already Exist"
else
    mc admin user add $inferenceAliasMinio $username $password
    mc admin policy set $inferenceAliasMinio $userLicence user=$username
fi




contributionAliasMinio=minio-contribution-data
contributionEndpoint=http://minio-contribution:9900/
contributionBucketName=signon-contribution


if mc alias set $contributionAliasMinio $contributionEndpoint $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD 2>/dev/null; then
    echo "Minio Contribution is up and running."
else
    echo "Minio Contribution is down."
    exit 1
fi


buckets=$(mc ls $contributionAliasMinio)
if [[ $buckets == *"$contributionBucketName"* ]];
then
    echo "Bucket '$contributionBucketName' already Exist"
else
    mc mb $contributionAliasMinio/$contributionBucketName
fi


INPUTFILE=users.csv
OLDIFS=$IFS
IFS=','
users=$(mc admin user list $contributionAliasMinio)

if [[ $users == *"$MINIO_ORCHESTRATOR_USER"* ]];
then
    echo "User '$MINIO_ORCHESTRATOR_USER' already Exist"
else
    mc admin user add $contributionAliasMinio $MINIO_ORCHESTRATOR_USER $MINIO_ORCHESTRATOR_PASSWORD
    mc admin policy set $contributionAliasMinio readwrite user=$MINIO_ORCHESTRATOR_USER
fi

[ ! -f $INPUTFILE ] && { echo "$INPUTFILE file not found"; exit 99; }
while read usr pwd lic
do
    if [[ $users == *"$usr"* ]];
    then
        echo "User '$usr' already Exist"
    else
        mc admin user add $contributionAliasMinio $usr $pwd
        mc admin policy set $contributionAliasMinio $lic user=$usr
    fi 
done < $INPUTFILE
IFS=$OLDIFS

mc admin console $contributionAliasMinio $contributionEndpoint

echo ciao