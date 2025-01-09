### Basic DragonflyDB Cluster Setup Documentation

## Overview
This document outlines the setup of a basic DragonflyDB cluster using Docker, Docker Compose, and mcrouter. The cluster consists of 3 DragonflyDB instances and 1 mcrouter instance, providing a simple and efficient caching solution for applications with lower traffic demands.

### Recommended Server Specifications
For the Basic Cluster configuration, we recommend using a cloud server instance with the following specifications:
- **Instance Type**: **t3.micro** (or equivalent)
- **CPU**: 1 vCPU
- **RAM**: 2 GB

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

## Running the Cluster
To start the cluster, run the following command in the terminal:

```bash
docker-compose -f docker-compose.yaml up -d
```

The `-d` flag runs the containers in detached mode.

## Monitoring
You can monitor the logs of each service using:

```bash
docker-compose -f docker-compose.yaml logs -f
```

## Cleanup

To stop and remove all containers and networks, run:

```bash
docker-compose -f docker-compose.yaml down
```

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