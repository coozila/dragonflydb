# DragonflyDB Cluster Quick Start  

Welcome to the **DragonflyDB Cluster Docs**! Follow these steps to quickly set up and run the application.  

## Prerequisites

Before you begin, ensure you have the following installed on your system:

- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

### 1. Create the Private Network

Before building the containers and images, you must manually create the `kabballa_private_network` Exemple:

```bash
docker network create --driver bridge kabballa_private_network --subnet=172.16.0.0/16
```

Alternatively, you can personalize your network according to your preferences directly in your docker-compose.yaml file like this:


```yaml

#   STACK NETWORK    ---------------------------------------------------------------#

networks:                                                                           #

    #   Private network for application services    --------------------------------#

    kabballa_private_network:
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

### 5. Launch the Application  
Start the application using Docker Compose:  
```bash
docker compose up -d  
```  

---

### 6. Accessing the Services  

- **DragonflyDB Instances**:  
  - Instance 1: [http://127.0.0.1:11212](http://127.0.0.1:11212)  
  - Instance 2: [http://127.0.0.1:11213](http://127.0.0.1:11213)  
  - Instance 3: [http://127.0.0.1:11214](http://127.0.0.1:11214)  

- **McRouter Interface**:  
  - [http://127.0.0.1:11211](http://127.0.0.1:11211)  

---

### 7. Cleanup  
To stop and remove all containers and networks:  
```bash
docker compose down  
```  
To stop and remove all containers, networks, and volumes:  
```bash
docker compose down -v  
```  

### Cluster Variants

We provide 3 variants of the DragonflyDB cluster:

1. **Basic Cluster with 3 DragonflyDB Instances and 1 Mcrouter Instance**:
- Documentation: [Basic Cluster Documentation](SETUP_CLUSTER_1_3.md)

2. **Intermediate Cluster with 5 DragonflyDB Instances and 3 Mcrouter Instances**:
- [3 Routers, 5 Nodes](SETUP_CLUSTER_3_5.md)  

2. **Advance Cluster with 6 DragonflyDB Instances 3 Master & 3 Slave and 3 Mcrouter Instances**:
- [3 Routers, 3 Masters, 3 Slaves](SETUP_CLUSTER_3_3_3.md)  


**Important Note**: If you opt for the `dev` branch, please understand that:  
- Features in this branch may be subject to change without notice.  
- Some functionalities may not work as expected or could impact performance.  
- Always test the `dev` branch in a controlled environment before deploying it in production.  

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
