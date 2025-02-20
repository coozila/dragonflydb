# DragonflyDB Cluster Master-Slave Setup Documentation

## Overview

This document outlines the setup of a DragonflyDB master-slave cluster using Docker, Docker Compose, and mcrouter. The cluster consists of 3 DragonflyDB master instances, 3 DragonflyDB slave instances, and 3 mcrouter instances, designed to provide redundancy and a robust caching solution for production environments. Multiple pool configurations are available for routing, including standard and advanced options.

### Key Features of DragonflyDB

- **High Performance**
- **Optimized Resource Usage**
- **Rich Compatibility**
- **Ease of Scaling**
- **Simple Deployment**
- **Advanced Features**

### Recommended Server Specifications

For the Master-Slave Cluster configuration, we recommend using a cloud server instance with the following specifications:

- **Minimum RAM**: 24 GB (This is the minimum requirement to run the cluster effectively.)
- **Maximum RAM Supported**: Each DragonflyDB instance can support up to **768 GB of RAM**, allowing for extensive caching capabilities. With 6 instances configured, if using 3 instances in a mirrored setup (replication), the effective storage capacity will be **2.274 TB**, as the data is duplicated across the mirrored instances.

### Architecture

- **DragonflyDB Master Instances**: 3 instances that handle write operations and coordinate data replication to their respective slaves.
- **DragonflyDB Slave Instances**: 3 instances that replicate data from the masters and handle read operations.
- **Mcrouter Instances**: 3 instances to manage routing requests to the appropriate DragonflyDB instances.

### Pool Configurations

The cluster supports multiple pool configurations for routing requests, each designed for specific scalability and redundancy requirements:

1. **Single-Pool Variant**: A simple configuration with less logical separation.
2. **Two-Pool Variant**: Redundancy and balanced utilization between master and slave, optimal for moderate scalability.
3. **Three-Pool Variant**: Maximum performance, scalability, and localized redundancy.
4. **Failover Pool**: Ensures high availability by failing over requests to alternative pools in case of server failure.
5. **Load Balancer Pool**: Distributes requests based on server load for optimized performance.
6. **Shard Pool**: Routes requests to shards based on key segmentation for distributed caching.
7. **Weighted Pool**: Assigns weights to servers for uneven distribution based on server capacity.
8. **Custom Hash Pool**: Routes requests using a specific hash function for specialized workloads.

The desired pool configuration can be selected by editing the `.env` file under mcrouter service pool. Uncomment the line corresponding to the desired pool configuration and comment out the others. By default, the three-pool configuration is enabled:

```
#   POOL VARIANT    ----------------------------------------------------------------#

#   1. Single-Pool Variant:
#   A simple configuration with less logical separation.
#   Exemple: MCROUTER_POOL_VARIANT=1pool
#MCROUTER_POOL_VARIANT=1pool

#   2. Two-Pool Variant:
#   Redundancy and balanced utilization between master and slave, optimal for moderate scalability.
#   Exemple: MCROUTER_POOL_VARIANT=1pool
#MCROUTER_POOL_VARIANT=1pool

#   3. Three-Pool Variant:
#   Maximum performance, scalability, and localized redundancy.
#   Exemple: MCROUTER_POOL_VARIANT=3pool
MCROUTER_POOL_VARIANT=3pool

#   4. Failover Pool:
#   Ensures high availability by failing over requests to alternative pools in case of server failure.
#   Exemple: MCROUTER_POOL_VARIANT=failover_pool
#MCROUTER_POOL_VARIANT=failover_pool

#   5. Load Balancer Pool:
#   Distributes requests based on server load for optimized performance.
#   Exemple: MCROUTER_POOL_VARIANT=loadbalancer_pool
#MCROUTER_POOL_VARIANT=loadbalancer_pool

#   6. Shard Pool:
#   Routes requests to shards based on key segmentation for distributed caching.
#   Exemple: MCROUTER_POOL_VARIANT=shard_pool
#MCROUTER_POOL_VARIANT=shard_pool

#   7. Weighted Pool:
#   Assigns weights to servers for uneven distribution based on server capacity.
#   Exemple: MCROUTER_POOL_VARIANT=weighted_pool
#MCROUTER_POOL_VARIANT=weighted_pool

#   8. Custom Hash Pool:
#   Routes requests using a specific hash function for specialized workloads.
#   Exemple: MCROUTER_POOL_VARIANT=custom_hash_pool
# MCROUTER_POOL_VARIANT=custom_hash_pool

# ----------------------------------------------------------------------------------#

```

## Cluster Configuration

### Docker Compose File
The configuration is defined in a `docker-compose.yaml` file in the folder 3x3x3-master-slave folder, which is used to create and manage the cluster's services.

### Configuration Files

#### **DragonflyDB Master Configuration File**: (Name: `dragonfly_master1_config.json`, `dragonfly_master2_config.json`, `dragonfly_master3_config.json`)

Each configuration file will have a similar structure but will have the master identification adjusted per instance:

```json
{
  "slot_ranges": [
    {
      "start": 0,
      "end": 8191
    }
  ],
  "master": {
    "id": "master1_id_placeholder",
    "ip": "dragonfly_master1",
    "port": 11211
  },
  "replicas": [
    {
      "id": "replica1_id_placeholder",
      "ip": "dragonfly_slave1",
      "port": 11211
    }
  ]
}

```

Repeat the structure for `dragonfly_master2_config.json` and `dragonfly_master3_config.json`, using the appropriate identifiers and IPs.

#### **DragonflyDB Slave Configuration File**: (Name: `dragonfly_slave_config.json`)

```json
{
  "slot_ranges": [
    {
      "start": 8192,
      "end": 16383
    }
  ],
  "master": {
    "id": "master1_id_placeholder",
    "ip": "dragonfly_master1",
    "port": 11211
  },
  "replicas": []
}
```

You'll create three instances of this file for each slave as well:

- `dragonfly_slave1_config.json`: Master pointing to `dragonfly_master1`
- `dragonfly_slave2_config.json`: Master pointing to `dragonfly_master2`
- `dragonfly_slave3_config.json`: Master pointing to `dragonfly_master3`

#### **Mcrouter Configuration File**: (Name: `mcrouter_${POOL_VARIANT}_3master_3slave.json`)


### Pool Configurations

The cluster supports multiple pool configurations for routing requests, each designed for specific scalability and redundancy requirements:

#### 1. **Single-Pool Variant**
   - **Description**: A simple configuration that combines all master and slave instances into a single pool.
   - **Technical Characteristics**: 
     - All instances are accessed through one pool.
     - Suitable for lightweight applications with minimal complexity.
   - **Advantages**:
     - Easy to set up and manage.
     - Reduces configuration overhead.
   - **Disadvantages**:
     - Lack of logical separation can lead to performance bottlenecks.
     - Limited flexibility in managing load distribution.

##### Exemple:

- **Single-Pool Variant**: A simple configuration with less logical separation.
   ```json
   {
     "pools": {
       "unified_pool": {
         "servers": [
           "dragonfly_master1:11211",
           "dragonfly_master2:11211",
           "dragonfly_master3:11211",
           "dragonfly_slave1:11211",
           "dragonfly_slave2:11211",
           "dragonfly_slave3:11211"
         ]
       }
     },
     "route": {
       "type": "OperationSelectorRoute",
       "operation_policies": {
         "add": {
           "type": "PoolRoute",
           "pool": "unified_pool"
         },
         "delete": {
           "type": "PoolRoute",
           "pool": "unified_pool"
         },
         "set": {
           "type": "PoolRoute",
           "pool": "unified_pool"
         },
         "get": {
           "type": "HashRoute",
           "children": [
             { "type": "PoolRoute", "pool": "unified_pool" }
           ]
         }
       }
     }
   }
   ```

#### 2. **Two-Pool Variant**
   - **Description**: This configuration separates masters and slaves into two distinct pools.
   - **Technical Characteristics**: 
     - One pool for all master instances and another for all slave instances.
   - **Advantages**:
     - Better load balancing with separate read and write operations.
     - Improved redundancy as slaves can take over read operations.
   - **Disadvantages**:
     - Increased complexity compared to a single pool.
     - Requires careful management of read/write distribution.

##### Exemple:

- **Two-Pool Variant**: Redundancy and balanced utilization between master and slave, optimal for moderate scalability.
   ```json
   {
     "pools": {
       "master_pool": {
         "servers": [
           "dragonfly_master1:11211",
           "dragonfly_master2:11211",
           "dragonfly_master3:11211"
         ]
       },
       "slave_pool": {
         "servers": [
           "dragonfly_slave1:11211",
           "dragonfly_slave2:11211",
           "dragonfly_slave3:11211"
         ]
       }
     },
     "route": {
       "type": "OperationSelectorRoute",
       "operation_policies": {
         "add": {
           "type": "PoolRoute",
           "pool": "master_pool"
         },
         "delete": {
           "type": "PoolRoute",
           "pool": "master_pool"
         },
         "set": {
           "type": "PoolRoute",
           "pool": "master_pool"
         },
         "get": {
           "type": "AllSyncRoute",
           "children": [
             { "type": "PoolRoute", "pool": "master_pool" },
             { "type": "PoolRoute", "pool": "slave_pool" }
           ]
         }
       }
     }
   }
   ```

#### 3. **Three-Pool Variant**
   - **Description**: Each pool contains a master and its corresponding slave, providing maximum redundancy.
   - **Technical Characteristics**: 
     - Three pools, each with one master and one slave.
   - **Advantages**:
     - High availability with localized redundancy.
     - Enhanced fault tolerance; if one master fails, its slave can take over.
   - **Disadvantages**:
     - More complex configuration management.
     - Potential for uneven load distribution if not properly managed.

##### Exemple:

- **Three-Pool Variant**: Maximum performance, scalability, and localized redundancy.
   ```json
   {
     "pools": {
       "pool1": {
         "servers": [
           "dragonfly_master1:11211",
           "dragonfly_slave1:11211"
         ]
       },
       "pool2": {
         "servers": [
           "dragonfly_master2:11211",
           "dragonfly_slave2:11211"
         ]
       },
       "pool3": {
         "servers": [
           "dragonfly_master3:11211",
           "dragonfly_slave3:11211"
         ]
       }
     },
     "route": {
       "type": "OperationSelectorRoute",
       "operation_policies": {
         "add": {
           "type": "HashRoute",
           "children": [
             { "type": "PoolRoute", "pool": "pool1" },
             { "type": "PoolRoute", "pool": "pool2" },
             { "type": "PoolRoute", "pool": "pool3" }
           ]
         },
         "delete": {
           "type": "HashRoute",
           "children": [
             { "type": "PoolRoute", "pool": "pool1" },
             { "type": "PoolRoute", "pool": "pool2" },
             { "type": "PoolRoute", "pool": "pool3" }
           ]
         },
         "set": {
           "type": "HashRoute",
           "children": [
             { "type": "PoolRoute", "pool": "pool1" },
             { "type": "PoolRoute", "pool": "pool2" },
             { "type": "PoolRoute", "pool": "pool3" }
           ]
         },
         "get": {
           "type": "HashRoute",
           "children": [
             { "type": "PoolRoute", "pool": "pool1" },
             { "type": "PoolRoute", "pool": "pool2" },
             { "type": "PoolRoute", "pool": "pool3" }
           ]
         }
       }
     }
   }
   ```

#### 4. **Failover Pool**
   - **Description**: This configuration ensures high availability by failing over requests to alternative pools in case of server failure.
   - **Technical Characteristics**: 
     - Requests are routed to a primary pool, with a secondary pool available for failover.
   - **Advantages**:
     - Guarantees continuity of service during failures.
     - Simple to implement for critical applications.
   - **Disadvantages**:
     - May not be as efficient under normal operation due to failover logic.
     - Increased latency during failover events.

##### Exemple:

- **Failover Pool**: Ensures high availability by failing over requests to alternative pools in case of server failure.
   ```json
   {
     "pools": {
       "failover_pool": {
         "servers": [
           "dragonfly_master1:11211",
           "dragonfly_master2:11211",
           "dragonfly_master3:11211",
           "dragonfly_slave1:11211",
           "dragonfly_slave2:11211",
           "dragonfly_slave3:11211"
         ]
       }
     },
     "route": {
       "type": "OperationSelectorRoute",
       "operation_policies": {
         "add": {
           "type": "FailoverRoute",
           "children": [
             { "type": "PoolRoute", "pool": "failover_pool" }
           ]
         },
         "delete": {
           "type": "FailoverRoute",
           "children": [
             { "type": "PoolRoute", "pool": "failover_pool" }
           ]
         },
         "set": {
           "type": "FailoverRoute",
           "children": [
             { "type": "PoolRoute", "pool": "failover_pool" }
           ]
         },
         "get": {
           "type": "FailoverRoute",
           "children": [
             { "type": "PoolRoute", "pool": "failover_pool" }
           ]
         }
       }
     }
   }
   ```

#### 5. **Load Balancer Pool**
   - **Description**: Distributes requests based on server load, optimizing performance.
   - **Technical Characteristics**: 
     - Utilizes a load-balancing algorithm to distribute requests.
   - **Advantages**:
     - Dynamic load distribution enhances performance.
     - Reduces the risk of server overload.
   - **Disadvantages**:
     - Requires careful tuning of load-balancing algorithms.
     - Additional complexity in configuration.

##### Exemple:

- **Load Balancer Pool**: Distributes requests based on server load for optimized performance.
   ```json
   {
     "pools": {
       "LoadBalancerPool": {
         "servers": [
           "dragonfly_master1:11211",
           "dragonfly_slave1:11211",
           "dragonfly_master2:11211",
           "dragonfly_slave2:11211",
           "dragonfly_master3:11211",
           "dragonfly_slave3:11211"
         ]
       }
     },
     "route": {
       "type": "LoadBalancerRoute",
       "children": [
         { "type": "PoolRoute", "pool": "LoadBalancerPool" }
       ]
     }
   }
   ```

#### 6. **Shard Pool**
   - **Description**: Routes requests to shards based on key segmentation for distributed caching.
   - **Technical Characteristics**: 
     - Segments data into shards, with each shard being managed by its master and slave.
   - **Advantages**:
     - Efficient handling of large datasets.
     - Improved performance for sharded workloads.
   - **Disadvantages**:
     - Complexity in managing shard keys.
     - Potential for uneven load if shard distribution is not balanced.

##### Exemple:

- **Shard Pool**: Routes requests to shards based on key segmentation for distributed caching.
   ```json
   {
     "pools": {
       "ShardPool1": {
         "servers": [
           "dragonfly_master1:11211",
           "dragonfly_slave1:11211"
         ]
       },
       "ShardPool2": {
         "servers": [
           "dragonfly_master2:11211",
           "dragonfly_slave2:11211"
         ]
       },
       "ShardPool3": {
         "servers": [
           "dragonfly_master3:11211",
           "dragonfly_slave3:11211"
         ]
       }
     },
     "route": {
       "type": "ShardRoute",
       "children": [
         { "type": "PoolRoute", "pool": "ShardPool1" },
         { "type": "PoolRoute", "pool": "ShardPool2" },
         { "type": "PoolRoute", "pool": "ShardPool3" }
       ]
     }
   }
   ```

#### 7. **Weighted Pool**
   - **Description**: Assigns weights to servers for uneven distribution based on server capacity.
   - **Technical Characteristics**: 
     - Servers are assigned weights to determine request distribution.
   - **Advantages**:
     - Allows for optimized use of more powerful servers.
     - Improved flexibility in load management.
   - **Disadvantages**:
     - Requires careful management of weights to avoid bottlenecks.
     - Increased complexity in configuration.

##### Exemple:

- **Weighted Pool**: Assigns weights to servers for uneven distribution based on server capacity.
   ```json
   {
     "pools": {
       "WeightedPool": {
         "servers": [
           { "ip": "dragonfly_master1", "port": 11211, "weight": 3 },
           { "ip": "dragonfly_slave1", "port": 11211, "weight": 1 },
           { "ip": "dragonfly_master2", "port": 11211, "weight": 3 },
           { "ip": "dragonfly_slave2", "port": 11211, "weight": 1 },
           { "ip": "dragonfly_master3", "port": 11211, "weight": 3 },
           { "ip": "dragonfly_slave3", "port": 11211, "weight": 1 }
         ]
       }
     },
     "route": {
       "type": "WeightedRoute",
       "children": [
         { "type": "PoolRoute", "pool": "WeightedPool" }
       ]
     }
   }
   ```

#### 8. **Custom Hash Pool**
   - **Description**: Routes requests using a specific hash function for specialized workloads.
   - **Technical Characteristics**: 
     - Utilizes a hash function to distribute requests based on keys.
   - **Advantages**:
     - Optimized for applications with specific hashing needs.
     - Allows for customized load distribution strategies.
   - **Disadvantages**:
     - Additional complexity in implementing and managing hash functions.
     - Potential for uneven distribution if not properly configured.

##### Exemple:

- **Custom Hash Pool**: Routes requests using a specific hash function for specialized workloads.
   ```json
   {
     "pools": {
       "CustomHashPool": {
         "servers": [
           "dragonfly_master1:11211",
           "dragonfly_slave1:11211",
           "dragonfly_master2:11211",
           "dragonfly_slave2:11211",
           "dragonfly_master3:11211",
           "dragonfly_slave3:11211"
         ]
       }
     },
     "route": {
       "type": "HashRoute",
       "hash_function": "crc32"
     }
   }
   ```

###   11. Load Balancer Pool With Failover and Shard:
   - **Description**:   Utilizes two load balancing pools and a failover pool, with sharding for distributed caching. This configuration enhances scalability and performance by distributing data across multiple shards, ensuring efficient resource utilization and fault tolerance.

####  Exemple: MCROUTER_POOL_VARIANT=2LoadBalancerPooll+1FailoverPool+Shard

   ```json

{
  "pools": {
    "LoadBalancerPoolA": {
      "servers": [
        "dragonfly_master1:11211",
        "dragonfly_slave1:11211"
      ]
    },
    "LoadBalancerPoolB": {
      "servers": [
        "dragonfly_master2:11211",
        "dragonfly_slave2:11211"
      ]
    },
    "FailoverPool": {
      "servers": [
        "dragonfly_master3:11211",
        "dragonfly_slave3:11211"
      ]
    }
  },
  "route": {
    "type": "OperationSelectorRoute",
    "operation_policies": {
      "add": {
        "type": "FailoverRoute",
        "children": [
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolA" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          },
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolB" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          }
        ]
      },
      "delete": {
        "type": "FailoverRoute",
        "children": [
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolA" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          },
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolB" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          }
        ]
      },
      "set": {
        "type": "FailoverRoute",
        "children": [
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolA" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          },
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolB" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          }
        ]
      },
      "get": {
        "type": "FailoverRoute",
        "children": [
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolA" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          },
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolB" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          }
        ]
      },
      "hash": {
        "type": "ShardRoute",
        "shards": [
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolA" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          },
          {
            "type": "LoadBalancerRoute",
            "children": [
              { "type": "PoolRoute", "pool": "LoadBalancerPoolB" },
              { "type": "PoolRoute", "pool": "FailoverPool" }
            ]
          }
        ]
      }
    }
  }
}
   ```

#### Configuration Diagram:

```plaintext

                        
                                +-------+-------+
                                |     CLIENT    |
                                +-------+-------+
                                        |
                                        v       
                                +-------+-------+
                                |    PUBLIC     |
                                |    NETWORK    |
                                +-------+-------+
                                        |
                                        v
                                +-------+-------+ 
                                |  DNS SERVER   |
                                +-------+-------+
                                        |
                                        v
                                +-------+-------+ 
                                | REVERSE PROXY |
                                +-------+-------+
                                        |
                                        v
                                +-------+-------+
                                | LoadBalancer  |
                                +-------+-------+
                                        |
                                        v
                                +-------+-------+       +-------+-------+
                                |    PRIVATE    |       |      YOUR     |
                                |    NETWORK    |       |      APP      |
                                +-------+-------+       +-------+-------+
                                        |                       |
                                        v                       |
                                +-------+-------+               |
                                |     NGINX     |               v
                                +               +<------------->+<-------------------->+<--->  OTHER SERVICES
                                | PROXY CLUSTER |                                      |
                                +-------+-------+                                      |
                                        |                                              |
                                        v                                              |
                +<--------------------->+<--------------------->+                      |  
                |                       |                       |                      |
                v                       v                       v                      v
        +---------------+        +------+-------+       +-------+-------+      +-------+-------+
        |   McRouter 1  |        |  McRouter 2  |       |  McRouter 3   |      |  DB Cluster 1 |
        +-------+-------+        +------+-------+       +-------+-------+      +-------+-------+
                |                       |                       |                      |
                v                       v                       v                      |
                +<--------------------->+<--------------------->+                      |  
                |                       |                       |                      |
                v                       v                       v                      v
        +-------+-------+        +------+-------+       +-------+-------+      +-------+-------+
        | LoadBalancer  |        | LoadBalancer |       |  FailoverPool |      |      DB       |
        |    Pool A     |        |    Pool B    |       |    Cold Pool  |      |  LoadBalancer |
        +-------+-------+        +------+-------+       +-------+-------+      +-------+-------+
                |                       |                       |                      |
                v                       v                       v                      |
                +<--------------------->+<--------------------->+                      |  
                |                       |                       |                      |
                v                       v                       v                      v
        +-------+-------+        +------+-------+       +-------+-------+      +-------+-------+
        |  DragonflyDB  |        | DragonflyDB  |       |  DragonflyDB  |      |     Mysql     |
        |    master1    |        |    master2   |       |     master3   |      |    master1    |
        +-------+-------+        +------+-------+       +-------+-------+      +-------+-------+
                |                       |                       |                      |
                v                       v                       v                      v
        +-------+-------+        +------+-------+       +-------+-------+      +-------+-------+
        |  DragonflyDB  |        | DragonflyDB  |       |  DragonflyDB  |      |     Mysql     |
        |    slave1     |        |    slave2    |       |     slave3    |      |    slave1     |
        +-------+-------+        +------+-------+       +-------+-------+      +-------+-------+


```

### Volume Mappings and Commands

The following commands and volume mappings are used in the Docker Compose file to ensure each instance loads the correct configuration:

- **Mcrouter Configuration Command**:

```yaml
command: mcrouter --config-file=/etc/mcrouter/mcrouter_config.json -p 11211
```

- **DragonflyDB Master Configuration Volume and Command** (example for Master 1):

```yaml
volumes:
    - ./config/dragonfly_master1_config.json:/etc/dragonfly/dragonfly_config.json

command: dragonfly --memcached_port=11211
```

- **DragonflyDB Slave Configuration Volume and Command** (example for Slave 1):

```yaml
volumes:
    - ./config/dragonfly_slave1_config.json:/etc/dragonfly/dragonfly_config.json

command: dragonfly --memcached_port=11211 --master=dragonfly_master1:11211
```

### Starting and Managing the Cluster

#### Prepare the Environment Variables  
Copy the example environment file and configure it:  

```bash
cp .env.example .env  
```  
Edit the `.env` file to set the required variables for your setup.  

---

#### Starting the Cluster

To start the DragonflyDB master-slave cluster using Docker Compose, navigate to the directory containing the `docker-compose.yaml` file and run the following command:
```bash
docker compose up -d
```
or
```bash
docker-compose up -d
```

#### Restarting the Cluster
To restart the cluster:
```bash
docker compose restart
```
or
```bash
docker-compose restart
```

#### Stopping the Cluster
To stop the running cluster, use:
```bash
docker compose down
```
or
```bash
docker-compose down
```

#### Removing Volumes
To remove all the volumes associated with the containers:
```bash
docker compose down -v
```
or
```bash
docker-compose down -v
```

### Accessing the Services  

- **DragonflyDB Instances**:  
  Instance 1: [http://127.0.0.1:11214](http://127.0.0.1:11214)  
  Instance 2: [http://127.0.0.1:11215](http://127.0.0.1:11215)  
  Instance 3: [http://127.0.0.1:11216](http://127.0.0.1:11216)  
  Instance 4: [http://127.0.0.1:11217](http://127.0.0.1:11217)  
  Instance 5: [http://127.0.0.1:11218](http://127.0.0.1:11218)  
  Instance 6: [http://127.0.0.1:11219](http://127.0.0.1:11219)  

- **McRouter Interface**:  
  [http://127.0.0.1:11211](http://127.0.0.1:11211)  
  [http://127.0.0.1:11212](http://127.0.0.1:11212)  
  [http://127.0.0.1:11213](http://127.0.0.1:11213)  

### Commands for Configuring the Cluster

- **Retrieve Node IDs**:  
Execute the following command on each node to get their unique IDs:
```bash
DFLYCLUSTER MYID
```

- **Build the Configuration String**:  
Create a JSON-encoded string based on the structure provided above, replacing placeholders with actual values.

- **Apply Configuration**:  
Use the following command to configure each node:
```bash
DFLYCLUSTER CONFIG <json-encoded-string>
```

### Viewing Logs

- **View Logs for a Specific Container**:  
To view logs for a specific container, use:
```bash
docker logs -f <container_name>
```
For example, to view logs for `dragonfly_master1`:
```bash
docker logs -f dragonflydb-cluster.dragonfly_master1
```

- **View Logs for All Containers**:  
To view logs for all containers in the cluster:
```bash
docker compose logs -f
```
or
```bash
docker-compose logs -f
```

- **View Logs for a Specific Service**:  
To view logs for a specific service, use:
```bash
docker compose logs -f <service_name>
```
For example, to view logs for `dragonfly_master1`:
```bash
docker compose logs -f dragonfly_master1
```

### Additional Operations

- **Check Container Status**:  
To check the status of all containers:
```bash
docker compose ps
```
or
```bash
docker-compose ps
```

- **Execute a Command in a Running Container**:  
To execute a command in a running container:
```bash
docker exec -it <container_name> <command>
```
For example, to open a shell in `dragonfly_master1`:
```bash
docker exec -it dragonflydb-cluster.dragonfly_master1 /bin/sh
```

This cluster setup can manage up to ***2.27 TB of data** in total across its instances, making it suitable for applications with significant data demands. It is recommended to scale the infrastructure when utilization reaches **60-70%** of capacity to maintain optimal performance.

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
