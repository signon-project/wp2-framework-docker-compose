# SignON Framework Docker Compose
The SignON Framework Docker Compose aim is to keep updated all the different files used in the process of building the Images and the Containers for the components for [SignON Project](https://signon-project.eu/) an EU H2020 research and innovation funded project.
## Initialisation 
In order to start the framework-docker-compose you need to download from the following folder ([link](https://drive.google.com/drive/folders/1rI0EiiczJWTll73E22sYBp3BrLiq_NXe?usp=sharing)) the compatible model needed for the multiple components used.
Before starting everything, it's important to check configuration files in the `minio` folder, parameters defined here will be used by the `minio-config.sh` script to create an initial configuration of the Object Storage.
After modifying the configuration in the `minio` folder, it's important to make some changes in the `signon-wpx-dispatcher/config.yml` and `signon-orchestrator/config.yml` file as this file need configuration parameters for `rabbitmq`, `minio` and others.
After the above steps is possible to start the whole environment using the command `docker compose up`. In order to stop everything and delete the running docker containers the command `docker compose down` has to be used.


## Parameters Setting
- ```signon-wpx-dispatcher/config.yml```
    - ```rabbitmq```
        - ```host```: Where is loaded the Rabbitmq image
        - ```rpc-exchange```: Channel for RabbitMQ communications
        - ```rpc-queue```: Queue for the messages in RabbitMQ
    - ```minio```
        - ```username```: Minio client to access the storage
        - ```password```: Minio client to access the storage
        - ```endpoint```: URL to make calls to the storage
        - ```downloadDirectoryPath```: Where to download the files from the storage

- ```signon-orchestrator/config.yml```
    - ```server```
        - ```address```: Where the Orchestrator is loaded
        - ```port```:  Port for access the Orchestrator
    - ```orchestrator```
        - ```username```: Username to Access RabbitMQ Client
        - ```password```: Password to Access RabbitMQ Client
        - ```virtualhost```: Virtual Host for orchestrator
        - ```hostname```: Container name for the Orchestrator
        - ```port```: Port for access RabbitMQ
    - ```rabbitmq```
        - ```rpc-exchange```: Channe; for RabbitMQ communications
        - ```rpc-queue```: Queue for the messages in rabbitMQ
        - ```rpc-routing-key```: Key for communication Channel in RabbitMQ
    - ```minio```
        - ```bucket-name```: Where the files in Minio are stored
        - ```adminUsername```: Admin Username to access the storage
        - ```adminPassword```: Admin Password to access the storage
        - ```endpoint```:

- ```minio/minio-config.sh```
    - ```aliasMinio```: Mapping Name for the Minio connection
    - ```bucketName```: Specific Folder in Minio where the files are stored
    - ```adminUsername```: Admin Password to access Minio storage
    - ```adminPassword```: Admin Username to Access Minio storage
    - ```username```: Username for the Pipeline simulator user
    - ```password```: Password for the Pipeline simulator user
    - ```userLicence```: Type of actions permitted to the pipeline simulator user
    - ```endpoint```: URL to make calls to the storage

- ```minio/.env```
    - ```MINIO_ROOT_USER```: Alphanumeric Minio Admin Username
    - ```MINIO_ROOT_PASSWORD```: Alphanumeric Minio Admin Password

## Additional information

#### Other details
- IDE: Visual Studio Code

### Branches description
- master: main branch with tagged releases
- dev: branch for development

### Known issues
No known issues.

## Authors
This project was developed by [FINCONS GROUP AG](https://www.finconsgroup.com/) within the Horizon 2020 European project SignON under grant agreement no. [101017255](https://doi.org/10.3030/101017255).  
For any further information, please send an email to [signon-dev@finconsgroup.com](mailto:signon-dev@finconsgroup.com).

## License
This project is released under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0.html).
