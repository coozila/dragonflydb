I apologize for the confusion. Here’s the updated documentation reflecting the current configuration, focusing on the use of a single variable for the mcrouter configuration and removing any references to multiple configuration files.

### Intermediate DragonflyDB Cluster Setup Documentation

## Overview
This document outlines the setup of an intermediate DragonflyDB cluster using Docker, Docker Compose, and mcrouter. The cluster consists of 5 DragonflyDB instances and 3 mcrouter instances, designed to provide a robust caching solution for production environments.

**DragonflyDB** is a modern, high-performance in-memory database and cache designed as an alternative to Redis and Memcached. It addresses some of the limitations of traditional in-memory solutions by offering better scalability and optimized resource usage.

### Key Features of DragonflyDB

1. **High Performance**
2. **Optimized Resource Usage**
3. **Rich Compatibility**
4. **Ease of Scaling**
5. **Simple Deployment**
6. **Advanced Features**

### Recommended Server Specifications

For the Cluster configuration, we recommend using a cloud server instance with the following specifications:

- **Minimum RAM**: 20 GB (This is the minimum requirement to run the cluster effectively.)
- **Maximum RAM Supported**: Each DragonflyDB instance can support up to **768 GB of RAM**, allowing for extensive caching capabilities. With 5 instances configured, the effective storage capacity will be **3.79 TB**.
This configuration is cost-effective and suitable for applications with light to moderate traffic.

### Architecture
- **DragonflyDB Instances**: The cluster contains 5 instances of DragonflyDB.
- **Mcrouter Instances**: There are 3 instances of mcrouter.

## Cluster Configuration

### Docker Compose File
The configuration is defined in a `docker-compose-cluster-3-5.yaml` file, which is used to create and manage the cluster's services located in the `config` folder.

### Key Components:
- **DragonflyDB Instances**: 5 instances configured with unique ports.
- **Mcrouter Instances**: 3 instances to route requests to the DragonflyDB instances.
- **Networking**: All services are connected to a private Docker network.

### Using Configuration Files
The configuration for mcrouter is now managed through a single variable, allowing for easier management. The volume mapping in the Docker Compose file is as follows:

```yaml
volumes:
  #
  #   Map config file
  #
  - ./config/mcrouter_${MCROUTER_POOL_VARIANT:-1pool}_5dragonfly.json:/etc/mcrouter/mcrouter_config.json
```

To use a specific configuration:
1. **Set the desired pool variant** in the `.env` file by modifying the `MCROUTER_POOL_VARIANT` variable.
2. **Save the changes** and then run your Docker Compose setup.

### Overriding Default Variables
To override certain variables set in the `docker-compose` file, you can create a `.env` file based on the default template provided. Follow these steps:

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the `.env` file** to modify any variables you wish to override. This allows you to customize specific settings for your environment while keeping the default values intact.

### Configuration Variants

The cluster supports multiple pool configurations for routing requests, each designed for specific scalability and redundancy requirements:

1. **Single-Pool Variant**: A simple configuration that combines all instances into a single pool.
   - Example: `MCROUTER_POOL_VARIANT=1pool`

2. **Two-Pool Variant**: Redundancy and balanced utilization between instances.
   - Example: `MCROUTER_POOL_VARIANT=2pool`

3. **Three-Pool Variant**: Maximum performance and scalability.
   - Example: `MCROUTER_POOL_VARIANT=3pool`

4. **Failover Pool**: Ensures high availability by failing over requests to alternative pools.
   - Example: `MCROUTER_POOL_VARIANT=failover_pool`

5. **Load Balancer Pool**: Distributes requests based on server load.
   - Example: `MCROUTER_POOL_VARIANT=loadbalancer_pool`

6. **Shard Pool**: Routes requests to shards based on key segmentation.
   - Example: `MCROUTER_POOL_VARIANT=shard_pool`

7. **Weighted Pool**: Assigns weights to servers for uneven distribution.
   - Example: `MCROUTER_POOL_VARIANT=weighted_pool`

8. **Custom Hash Pool**: Routes requests using a specific hash function.
   - Example: `MCROUTER_POOL_VARIANT=custom_hash_pool`


### Configuration Variants

### Example Configuration for Mcrouter

The following is an example of the mcrouter configuration file that uses the variable for routing:

```json
{
    "pools": {
        "A": {
            "servers": [
                "dragonfly1:11211",
                "dragonfly2:11211",
                "dragonfly3:11211",
                "dragonfly4:11211",
                "dragonfly5:11211"
            ]
        }
    },
    "route": {
        "type": "OperationSelectorRoute",
        "operation_policies": {
            "add": "AllFastestRoute|Pool|A",
            "delete": "AllFastestRoute|Pool|A",
            "get": "AllFastestRoute|Pool|A",
            "set": "AllFastestRoute|Pool|A"
        }
    }
}
```

## Getting Started

### 1. Create the Private Network

Before building the containers and images, you must manually create the `stack_private_network` Exemple:

```bash
docker network create --driver bridge stack_private_network --subnet=172.16.0.0/16
```

Alternatively, you can personalize your network according to your preferences directly in your docker-compose.yaml file like this:


```yaml

#   STACK NETWORK    ---------------------------------------------------------------#

networks:                                                                           #

    #   Private network for application services    --------------------------------#

    stack_private_network:
        driver: bridge 
        driver_opts:
            com.docker.network.enable_ipv6: "false"
        ipam:
            driver: default
            config:
                - subnet: 172.16.238.0/24
                  gateway: 172.16.238.1


# ----------------------------------------------------------------------------------#

```

> [!TIP]
> For better performance, using the host network mode is often the best choice, depending on the structure of the application in which you want to integrate the cluster. This mode can reduce latency and improve speed, but keep in mind that it may expose your services directly to the host network.
> 
> Additionally, Docker is not the most efficient for managing disk I/O. It is advisable to manage volumes on an alternative path or directly by the system, or to use another file system. This may require customization to achieve the best performance.
> 
> Depending on your specific configuration and preferences, you should choose the solution that best fits your needs. Assessing the trade-offs between ease of use, performance, and security is essential. In some cases, using the default Docker settings may be sufficient, while in others, adapting the network and volume configuration may bring significant benefits in terms of speed and operational efficiency.
> 
> Ultimately, the choice of network mode and volume management strategy should align with your application's requirements and the environment in which it will be deployed.
> 
> For more exemples see [Docker Engine Network](https://docs.docker.com/engine/network/)


### 2. Clone the Repository  
Clone the Coozila! Apps repository to your local machine:  
```bash
git clone https://github.com/coozila/dragonflydb-cluster.git  
cd dragonflydb-cluster
```  

> [!TIP]
>  Before proceeding, ensure you are on the correct branch and using the appropriate version of the application.  

- **Stable Version (Recommended)**: For stability and reliability, use version `1.0.1`, the latest published stable version.  
- **Development Version**: If you prefer the latest features and updates, you can switch to the `dev` branch. However, please note:  
  - The `dev` branch is continuously updated.  
  - It may contain experimental features or changes that have not yet been fully tested.  
  - Use this version with caution, and ensure you test thoroughly in a non-production environment before deployment.  

---

### 3. Checkout the Desired Version
- To use the first version:  
  ```bash
  git checkout 1.0.0
  ```  
- To use the latest stable version:  
  ```bash
  git checkout 1.0.1  
  ```  
- To use the development version:  
  ```bash
  git checkout dev  
  ```  

#### 4. Starting the Cluster
To start the cluster:

```bash
docker compose -f docker-compose-cluster-3-5.yaml up -d
```
#### 5. Restarting the Cluster
To restart the cluster:

```bash
docker compose -f docker-compose-cluster-3-5.yaml restart
```

#### 6. Stopping the Cluster
To stop the running cluster, use:

```bash
docker compose -f docker-compose-cluster-3-5.yaml down
```

#### 7. Removing Volumes
To remove all the volumes associated with the containers:

```bash
docker compose -f docker-compose-cluster-3-5.yaml down -v
```

### 6. Accessing the Services  

- **DragonflyDB Instances**:  
  - Instance 1: [http://127.0.0.1:11214](http://127.0.0.1:11214)
  - Instance 2: [http://127.0.0.1:11215](http://127.0.0.1:11215)
  - Instance 3: [http://127.0.0.1:11216](http://127.0.0.1:11216)
  - Instance 4: [http://127.0.0.1:11217](http://127.0.0.1:11217)
  - Instance 4: [http://127.0.0.1:11218](http://127.0.0.1:11218)

- **McRouter Interface**:
  - [http://127.0.0.1:11211](http://127.0.0.1:11211)
  - [http://127.0.0.1:11212](http://127.0.0.1:11212)
  - [http://127.0.0.1:11213](http://127.0.0.1:11213)

---


This cluster setup can manage up to **5 TB of data** in total across its instances, making it suitable for applications with significant data demands. It is recommended to scale the infrastructure when utilization reaches **60-70%** of capacity to maintain optimal performance.

> [!TIP]
> For suggestions or to propose alternative configurations, you are encouraged to [fork the repository](https://github.com/coozila/dragonflydb-cluster/fork) and submit a pull request with your changes.
>
> For any inquiries, please contact **Coozila! LABS** at **lab@coozila.com** or visit our official page for updates and more information: [Coozila! LABS](https://www.coozila.com/plus/view-organization-profile/coozila-labs).

## Installation Assistance

If you would like assistance with the installation of this product, please contact **Coozila! Labs** at [labs@coozila.com](mailto:lab@coozila.com). Our team is ready to help you with the installation process and ensure a smooth setup.

Based on the size and complexity of your project, we will provide you with a tailored pricing quote.

For purchasing the installation, please visit the following link: [Coozila Docker Package App for Memcached](https://www.coozila.com/plus/view-product/coozila-docker-package-app-for-memcached).

You can also check out the official Coozila! Labs page for more information: [Coozila! Labs](https://www.coozila.com/plus/view-organization-profile/coozila-labs).

For any inquiries, feel free to reach out through our contact page: [Contact Coozila!](https://www.coozila.com/plus/contact).

### After Purchase Notes

After your purchase, please provide the following information via email:

- Server login credentials
- An SSH key for secure access
- Details about the project you wish to integrate

## Additional Documentation

For more details, please refer to the main repository: 

- [Coozila! Apps](https://github.com/coozila/apps).
- [Mcrouter](https://github.com/facebook/mcrouter)
- [DragonflyDB](https://github.com/dragonflydb/dragonfly/tree/main/docs)

## Trademarks and Copyright

This software listing is packaged by Coozila!. All trademarks mentioned are the property of their respective owners, and their use does not imply any affiliation or endorsement.

### Copyright

Copyright (C) 2009 - 2025 Coozila! Licensed under the MIT License.

### Licenses

- **Coozila!**: [MIT License](https://github.com/coozila/dragonflydb-cluster/blob/dev/LICENSE)
- **DragonflyDB**: [DragonflyDB License](https://github.com/dragonflydb/dragonfly/blob/main/LICENSE.md)
- **McRouter**: [McRouter License](https://github.com/facebook/mcrouter/blob/main/LICENSE)
- **Memcached**: [Memcached License](https://github.com/memcached/memcached/blob/master/LICENSE)

### Important Notice Regarding DragonflyDB Usage  

In compliance with the **Dragonfly Business Source License 1.1 (BSL 1.1)**:  
- **Permitted Use:** This project involves installing and configuring DragonflyDB as part of your private caching infrastructure.  
- **Prohibited Use:** You cannot offer DragonflyDB as a hosted or managed service, nor provide any solution that allows third parties (other than your employees or contractors) to access or use DragonflyDB features.  
- This ensures that our service fully respects the licensing terms of DragonflyDB.

## Disclaimer

This product is provided "as is," without any guarantees or warranties regarding its functionality, performance, or reliability. By using this product, you acknowledge that you do so at your own risk. Coozila! and its contributors are not liable for any issues, damages, or losses that may arise from the use of this product. We recommend thoroughly testing the product in your own environment before deploying it in a production setting.
