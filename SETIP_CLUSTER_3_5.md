### Intermediate DragonflyDB Cluster Setup Documentation

## Overview
This document outlines the setup of an intermediate DragonflyDB cluster using Docker, Docker Compose, and mcrouter. The cluster consists of 5 DragonflyDB instances and 3 mcrouter instances, designed to provide a robust caching solution for production environments.

**DragonflyDB** is a modern, high-performance in-memory database and cache designed as an alternative to Redis and Memcached. It addresses some of the limitations of traditional in-memory solutions by offering better scalability and optimized resource usage. 

### Key Features of DragonflyDB

1. **High Performance**:
   - DragonflyDB is built to handle a massive number of operations per second, significantly outperforming Redis and Memcached in many benchmarks.
   - It leverages modern multi-threading and hardware to maximize efficiency.

2. **Optimized Resource Usage**:
   - It is designed to reduce memory fragmentation and optimize CPU usage, making it cost-effective for large-scale deployments.
   - Supports efficient memory management for high-density workloads.

3. **Rich Compatibility**:
   - Fully compatible with Redis protocols, allowing users to migrate existing applications seamlessly.
   - Provides support for Memcached APIs, making it versatile for various use cases.

4. **Ease of Scaling**:
   - Built with scalability in mind, DragonflyDB can handle large datasets and distributed workloads efficiently.
   - Its architecture supports modern hardware innovations like NVMe storage and high-speed networking.

5. **Simple Deployment**:
   - Lightweight and easy to deploy on cloud platforms, containers, or bare-metal servers.
   - Provides pre-built binaries and Docker images for quick setup.

6. **Advanced Features**:
   - Includes built-in support for advanced data structures like strings, hashes, sets, and sorted sets, similar to Redis.
   - Offers enhanced mechanisms for data eviction, persistence, and snapshotting.

### Recommended Server Specifications
For the Intermediate Cluster configuration, we recommend using a cloud server instance with the following specifications:
- **Instance Type**: **t3.large** (or equivalent)
- **CPU**: 2 vCPUs
- **RAM**: 8 GB

This configuration strikes a balance between cost and performance, making it suitable for applications that experience moderate to high traffic.

### Architecture
- **DragonflyDB Instances**: The cluster contains 5 instances of DragonflyDB, each responsible for storing key-value pairs in memory.
- **Mcrouter Instances**: There are 3 instances of mcrouter, which act as a routing layer to distribute requests among the DragonflyDB instances. Mcrouter handles sharding and provides redundancy.

## Cluster Configuration

### Docker Compose File
The configuration is defined in a `docker-compose-cluster-3-5.yaml` file, which is used to create and manage the cluster's services located in the `config` folder.

### Key Components:
- **DragonflyDB Instances**: 5 instances of DragonflyDB are configured, each with unique ports to avoid conflicts. They are responsible for storing and retrieving key-value pairs.
- **Mcrouter Instances**: 3 instances of mcrouter are set up to route requests to the DragonflyDB instances. Each mcrouter instance is configured with a command line that specifies the routing policy.
- **Networking**: All services are connected to a private Docker network to facilitate communication.

## Running the Cluster
To start the cluster, run the following command in the terminal:

```bash
docker-compose -f docker-compose-cluster-3-5.yaml up -d
```

The `-d` flag runs the containers in detached mode.

## Monitoring
You can monitor the logs of each service using:

```bash
docker-compose -f docker-compose-cluster-3-5.yaml logs -f
```

## Cleanup

To stop and remove all containers and networks, run:

```bash
docker-compose -f docker-compose-cluster-3-5.yaml down
```

## Data Distribution in the DragonflyDB Cluster

### Overview
In the configured DragonflyDB cluster, data distribution is achieved through sharding and managed by mcrouter. Sharding involves dividing the keyspace among multiple DragonflyDB instances to ensure that no single instance becomes a bottleneck. This also improves performance and availability.

### Sharding Mechanism
1. **Hashing Function**: When a key-value pair is stored in DragonflyDB, a hashing function is applied to the key to determine which DragonflyDB instance will hold the value. The hashing function typically converts the key into a numeric value, which is then used to select an instance based on the total number of instances.
   
   For example, if you have 5 DragonflyDB instances, the formula to determine which instance to use could be:
   ```plaintext
   index = hash(key) % number_of_instances
   ```

   Here, `number_of_instances` would be 5. This means that the output of the hash function would be an integer between 0 and 4, corresponding to one of the 5 DragonflyDB instances.

2. **Key Distribution**: Each key is routed to one of the 5 DragonflyDB instances based on the result of the hashing function. This ensures that data is evenly distributed across all instances, allowing for parallel reads and writes, which improves overall performance.

### Role of mcrouter
- **Routing Requests**: Mcrouter acts as a routing layer between the application and the DragonflyDB instances. When an application makes a request to set or get a value, it sends the request to one of the mcrouter instances. 
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

## Conclusion
In summary, this setup provides a robust caching solution using DragonflyDB, with mcrouter handling the routing and sharding. The architecture is designed for scalability and fault tolerance, ensuring that your application can efficiently handle caching needs.

### Cluster Variants

We provide 2 variants of the DragonflyDB cluster:

1. **Basic Cluster with 3 DragonflyDB Instances and 1 Mcrouter Instance**:
   - Configuration file: [docker-compose.yaml](docker-compose.yaml)
   - Documentation: [Basic Cluster Documentation](SETUP_CLUSTER_1_3.md)

2. **Intermediate Cluster with 5 DragonflyDB Instances and 3 Mcrouter Instances**:
   - Configuration file: [docker-compose-cluster-3-5.yaml](docker-compose-cluster-3-5.yaml)
   - Documentation: [Cluster 3-5 Documentation](SETUP_CLUSTER_3_5.md)