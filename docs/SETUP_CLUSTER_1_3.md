### Basic DragonflyDB Cluster Setup Documentation

## Overview
This document outlines the setup of a basic DragonflyDB cluster using Docker, Docker Compose, and mcrouter. The cluster consists of 3 DragonflyDB instances and 1 mcrouter instance, providing a simple and efficient caching solution for applications with lower traffic demands.

### Recommended Server Specifications

For the Cluster configuration, we recommend using a cloud server instance with the following specifications:

- **Minimum RAM**: 12 GB (This is the minimum requirement to run the cluster effectively.)
- **Maximum RAM Supported**: Each DragonflyDB instance can support up to **768 GB of RAM**, allowing for extensive caching capabilities. With 3 instances configured, the effective storage capacity will be **2.274 TB**.
This configuration is cost-effective and suitable for applications with light to moderate traffic.

### Architecture
- **DragonflyDB Instances**: The cluster contains 3 instances of DragonflyDB, each responsible for storing key-value pairs in memory.
- **Mcrouter Instance**: There is 1 instance of mcrouter, which acts as a routing layer to distribute requests among the DragonflyDB instances. Mcrouter handles sharding and provides a basic level of redundancy.

## Cluster Configuration

### Docker Compose File
The configuration is defined in a `docker-compose.yaml` file, which is used to create and manage the cluster's services located in the `config` folder.

### Key Components:
- **DragonflyDB Instances**: 3 instances of DragonflyDB are configured, each with unique ports to avoid conflicts. They are responsible for storing and retrieving key-value pairs.
- **Mcrouter Instance**: 1 instance of mcrouter is set up to route requests to the DragonflyDB instances. The mcrouter instance is configured with a command line that specifies the routing policy.
- **Networking**: All services are connected to a private Docker network to facilitate communication.

## Getting Started

### 1. Create the Private Network

Before building the containers and images, you must manually create the `kabba_private_network` Exemple:

```bash
docker network create --driver bridge kabba_private_network --subnet=172.16.0.0/16
```

Alternatively, you can personalize your network according to your preferences directly in your docker-compose.yaml file like this:


```yaml

#   STACK NETWORK    ---------------------------------------------------------------#

networks:                                                                           #

    #   Private network for application services    --------------------------------#

    kabba_private_network:
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
Clone the App repository to your local machine:  
```bash
git clone https://github.com/olariuromeo/dragonflydb-cluster.git  
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

---

### 4. Prepare the Environment Variables  
Copy the example environment file and configure it:  
```bash
cp .env.example .env  
```  
Edit the `.env` file to set the required variables for your setup.  

---

To start the cluster, run the following command in the terminal:

```bash
docker compose up -d
```

The `-d` flag runs the containers in detached mode.

## Monitoring
You can monitor the logs of each service using:

```bash
docker compose logs -f
```

## Cleanup

To stop and remove all containers and networks, run:

```bash
docker compose down
```
## Removing Volumes
To remove all the volumes associated with the containers:

```bash
docker compose down -v
```

### Accessing the Services  

- **DragonflyDB Instances**:  
  - Instance 1: [http://127.0.0.1:11212](http://127.0.0.1:11212)
  - Instance 2: [http://127.0.0.1:11213](http://127.0.0.1:11213)
  - Instance 3: [http://127.0.0.1:11214](http://127.0.0.1:11214)

- **McRouter Interface**:  
  - [http://127.0.0.1:11211](http://127.0.0.1:11211)  

## Data Distribution in the DragonflyDB Cluster

### Overview
In the configured DragonflyDB cluster, data distribution is achieved through sharding and managed by mcrouter. Sharding involves dividing the keyspace among multiple DragonflyDB instances to ensure that no single instance becomes a bottleneck. This also improves performance and availability.

### Sharding Mechanism
1. **Hashing Function**: When a key-value pair is stored in DragonflyDB, a hashing function is applied to the key to determine which DragonflyDB instance will hold the value. The hashing function typically converts the key into a numeric value, which is then used to select an instance based on the total number of instances.
   
   For example, if you have 3 DragonflyDB instances, the formula to determine which instance to use could be:
   ```plaintext
   index = hash(key) % number_of_instances
   ```

   Here, `number_of_instances` would be 3. This means that the output of the hash function would be an integer between 0 and 2, corresponding to one of the 3 DragonflyDB instances.

2. **Key Distribution**: Each key is routed to one of the 3 DragonflyDB instances based on the result of the hashing function. This ensures that data is evenly distributed across all instances, allowing for parallel reads and writes, which improves overall performance.

### Role of mcrouter
- **Routing Requests**: Mcrouter acts as a routing layer between the application and the DragonflyDB instances. When an application makes a request to set or get a value, it sends the request to the mcrouter instance. 
- **Internal Logic**: Mcrouter uses the same hashing logic to determine which DragonflyDB instance should handle the request. It abstracts this complexity away from the application, allowing the application to interact with mcrouter as if it were a single DragonflyDB instance.
- **Load Balancing**: By managing the distribution of keys, mcrouter helps balance the load across all DragonflyDB instances. If one instance is overloaded or unavailable, mcrouter can redirect requests to the other instances.

### Fault Tolerance and Availability
- **Redundant Copies**: While this specific configuration does not include data replication, you can implement a strategy for redundancy by using multiple instances to store the same key-value pairs. If one instance fails, data can still be accessed from the other instances.
- **Dynamic Reconfiguration**: If you add or remove DragonflyDB instances, mcrouter can dynamically adjust the routing of requests without requiring changes in the application code.

## Example of Data Flow
1. An application wants to store a value with the key `user:123`.
2. The application sends the request to mcrouter.
3. Mcrouter applies the hashing function to `user:123` and determines that it should be stored in `dragonfly1`.
4. Mcrouter forwards the request to `dragonfly1`, which stores the value.
5. When the application requests the value for `user:123`, it sends a request to mcrouter.
6. Mcrouter hashes the key again, finds that it belongs to `dragonfly1`, and retrieves the value.


This cluster setup can manage up to **5 TB of data** in total across its instances, making it suitable for applications with significant data demands. It is recommended to scale the infrastructure when utilization reaches **60-70%** of capacity to maintain optimal performance.

> [!TIP]
> For suggestions or to propose alternative configurations, you are encouraged to [fork the repository](https://github.com/olariuromeo/dragonflydb-cluster/fork) and submit a pull request with your changes.

## Installation Assistance

If you would like assistance with the installation of this product, please contact **Romulus** at [olariu_romeo@yahoo.it](mailto:olariu_romeo@yahoo.it). I will be happy to help you with the installation process and ensure a smooth setup.

Based on the size and complexity of your project, we will provide you with a tailored pricing quote.

For purchasing the custom installation, please visit the following link: [DragonflyDB Cluster Custom](https://www.coozila.com/plus/view-product/dragonflydb-cluster-custom).

You can also check out my page for more information: [Romulus](https://www.coozila.com/plus/view-persons-profile/romulus).


### After Purchase Notes

After your purchase, please provide the following information via email:

- Server login credentials
- An SSH key for secure access
- Details about the project you wish to integrate

## Additional Documentation

For more details, please refer to the main repository: 

- [Mcrouter](https://github.com/facebook/mcrouter)
- [DragonflyDB](https://github.com/dragonflydb/dragonfly/tree/main/docs)

## Trademarks and Copyright

This software listing is packaged by Romulus. All trademarks mentioned are the property of their respective owners, and their use does not imply any affiliation or endorsement.

### Copyright

Copyright (C) Romulus Licensed under the MIT License.

### Licenses

- **Romulus!**: [MIT License](https://github.com/olariuromeo/dragonflydb-cluster/blob/dev/LICENSE)
- **DragonflyDB**: [DragonflyDB License](https://github.com/dragonflydb/dragonfly/blob/main/LICENSE.md)
- **McRouter**: [McRouter License](https://github.com/facebook/mcrouter/blob/main/LICENSE)
- **Memcached**: [Memcached License](https://github.com/memcached/memcached/blob/master/LICENSE)

### Important Notice Regarding DragonflyDB Usage  

In compliance with the **Dragonfly Business Source License 1.1 (BSL 1.1)**:  
- **Permitted Use:** This project involves installing and configuring DragonflyDB as part of your private caching infrastructure.  
- **Prohibited Use:** You cannot offer DragonflyDB as a hosted or managed service, nor provide any solution that allows third parties (other than your employees or contractors) to access or use DragonflyDB features.  
- This ensures that our service fully respects the licensing terms of DragonflyDB.

## Disclaimer

This product is provided "as is," without any guarantees or warranties regarding its functionality, performance, or reliability. By using this product, you acknowledge that you do so at your own risk. Romulus and its contributors are not liable for any issues, damages, or losses that may arise from the use of this product. We recommend thoroughly testing the product in your own environment before deploying it in a production setting.

Happy coding!
