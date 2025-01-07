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
For the Intermediate Cluster configuration, we recommend using a cloud server instance with the following specifications:
- **Minimum Instance Type**: **t3.large** (or equivalent)
- **Minimum RAM**: 8 GB (This is the minimum requirement to run the cluster effectively.)
- **Maximum RAM Supported**: Each DragonflyDB instance can support up to **1 TB of RAM**, allowing for extensive caching capabilities and handling of large datasets. With 5 instances, the cluster can manage a total of **up to 5 TB of data**, making it suitable for applications with significant data requirements.

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
The following configuration files are already set up in the volumes section of your Docker Compose file. You can uncomment the desired configuration file to use it. Only one configuration variant should be active at a time.

```yaml
volumes:
            #
            #   Map config file
            #
            - ./config/intermediate_cluster_3_5_config.json:/etc/mcrouter/mcrouter_config.json

            #
            #   Map failover config file 
            #
            #- ./config/intermediate_cluster_3_5_failover_config.json:/etc/mcrouter/mcrouter_config.json

            #
            #   Map operation selector config file 
            #
            #- ./config/intermediate_cluster_3_5_operation_selector_config.json:/etc/mcrouter/mcrouter_config.json
```

To use a specific configuration:
1. **Choose the desired configuration** by uncommenting the corresponding line.
2. **Comment out the other configurations** to ensure only one is active.
3. **Save the changes** and then run your Docker Compose setup.

### Overriding Default Variables
To override certain variables set in the `docker-compose` file, you can create a `.env` file based on the default template provided. Follow these steps:

1. **Copy the example file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the `.env` file** to modify any variables you wish to override. This allows you to customize specific settings for your environment while keeping the default values intact.

### Configuration Variants

#### 1. Intermediate Cluster Configuration

**File Name:** `intermediate_cluster_3_5_config.json`

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

**Description:** This configuration uses all five DragonflyDB instances within pool A, applying an operation selector for efficient request routing.

**Advantages:**
- **Simplified Routing:** Easy to manage with straightforward operation selection.
- **Balanced Load:** Efficiently distributes requests across all five instances.

**Disadvantages:**
- **No Redundancy:** If all servers in pool A become unavailable, operations will fail.

---

#### 2. Intermediate Cluster Configuration with Failover

**File Name:** `intermediate_cluster_3_5_failover_config.json`

```json
{
  "pools": {
    "A": {
      "servers": [
        "dragonfly1:11211",
        "dragonfly2:11211",
        "dragonfly3:11211"
      ]
    },
    "B": {
      "servers": [
        "dragonfly4:11211",
        "dragonfly5:11211"
      ]
    }
  },
  "route": {
    "type": "FailoverRoute",
    "children": [
      {
        "type": "PoolRoute",
        "name": "poolA",
        "pool": "A"
      },
      {
        "type": "PoolRoute",
        "name": "poolB",
        "pool": "B"
      }
    ]
  }
}
```

**Description:** This configuration allows for failover between pools A and B, ensuring requests can be rerouted if one pool becomes unavailable.

**Advantages:**
- **Increased Redundancy:** Allows rerouting of requests to pool B if pool A is unavailable.
- **Better Availability:** Ensures application functionality even if one pool experiences issues.

**Disadvantages:**
- **Increased Complexity:** Failover mechanisms add complexity to routing.
- **Potential Latency:** Failover may introduce delays during routing.

---

#### 3. Intermediate Cluster Configuration with Operation Selector

**File Name:** `intermediate_cluster_3_5_operation_selector_config.json`

```json
{
  "pools": {
    "A": {
      "servers": [
        "dragonfly1:11211",
        "dragonfly2:11211",
        "dragonfly3:11211"
      ]  
    },
    "B": {
      "servers": [
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

**Description:** This configuration uses an operation selector for both pools A and B, distributing operations efficiently.

**Advantages:**
- **Simplicity:** Easy to configure and understand.
- **Efficient Load Balancing:** Operates effectively with basic load balancing.

**Disadvantages:**
- **No Redundancy:** Operations may fail if all servers in either pool become unavailable.

---

This cluster setup can manage up to **5 TB of data** in total across its instances, making it suitable for applications with significant data demands. It is recommended to scale the infrastructure when utilization reaches **60-70%** of capacity to maintain optimal performance.

> [!TIP]
> For suggestions or to propose alternative configurations, you are encouraged to [fork the repository](https://github.com/coozila/dragonflydb-cluster/fork) and submit a pull request with your changes.
>
> For any inquiries, please contact **Coozila! LABS** at **lab@coozila.com** or visit our official page for updates and more information: [Coozila! LABS](https://www.coozila.com/plus/view-organization-profile/coozila-labs).