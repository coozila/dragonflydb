<p align="center">
    <a href="https://twitter.com/coozila" target="_blank"><img src="https://img.shields.io/twitter/follow/:coozila" alt="Follow on Twitter" /></a>
</p>

<p align="center">
    <img width="233px" height="auto" src="https://www.coozila.com/static/themes/prometheus/img/coozila.png" />
</p>
<p align="center">
    <a href="https://github.com/coozila/dragonflydb-cluster/releases" target="_blank"><img src="https://img.shields.io/badge/dynamic/json?color=green&label=downloads&query=downloads&url=https://raw.githubusercontent.com/coozila/dragonflydb-cluster/dev/metrics.yaml" alt="Total Downloads" /></a>
    <a href="https://github.com/coozila/dragonflydb-cluster/dev/main/LICENSE" target="_blank"><img src="https://img.shields.io/badge/license-MIT-1c7ed6" alt="License" /></a>
</p>

> If you enjoy the project, please consider giving us a GitHub star ⭐️. Thank you!

## Sponsors

If you want to support our project and help us grow it, you can [become a sponsor on GitHub](https://github.com/sponsors/coozila)

<p align="center">
  <a href="https://github.com/sponsors/coozila">
  </a>
</p>

# DragonflyDB Cluster

![Cluster](assets/dragpnflydb-cluster.png)

## Coozila! Docker Package APP for DragonflyDB Cluster with McRouter

The **Coozila! Package for DragonflyDB Cluster** integrates **DragonflyDB** and **McRouter**, delivering a cutting-edge caching solution tailored for modern applications. Designed to maximize scalability and performance, this package empowers developers to deploy a distributed caching layer effortlessly, alleviating database load while significantly improving response times.

### Why Choose Coozila?

- **Simplified Scalability**: Deploy a highly efficient distributed caching layer using pre-configured Docker packages, reducing complexity and ensuring faster response times.
- **Intelligent Request Routing**: Take advantage of McRouter's advanced capabilities, including prefix routing, replicated pools, and failover mechanisms, for seamless cache operation.
- **Blazing-Fast Performance**: With DragonflyDB at its core, Coozila! offers a high-speed, fault-tolerant caching system optimized for high-demand environments.
- **Dynamic Configuration**: Easily manage and scale your caching infrastructure with live updates, ensuring zero downtime.
- **Multi-Level Caching**: Implement tiered caching with local and remote caches for enhanced data retrieval efficiency.

### Documentation

- [Quick Start Guide](docs/README.md)
- [Basic Cluster Documentation](docs/SETUP_CLUSTER_1_3.md)
- [Cluster 3-5 Documentation](docs/SETUP_CLUSTER_3_5.md)

### Core Features

- **High Availability**: Ensure reliable data storage with integrated failover and replication mechanisms, even during node failures.
- **Optimized Caching**: Leverage McRouter to route requests efficiently across multiple Memcached servers, achieving better load balancing and resource management.
- **Advanced Routing Logic**: Configure routing based on prefixes, clusters, or custom policies using McRouter’s modular routing handles.
- **Cold Cache Warmup**: Bring new cache nodes online seamlessly without impacting application performance.
- **Rich Monitoring Tools**: Access detailed statistics and debugging commands for complete visibility into cache performance.
- **Security First**: Utilize built-in SSL support and IPv6 compatibility to secure data in transit.
- **Multi-Threaded Architecture**: Harness the power of multi-core systems for efficient request handling.

### Easy Deployment

The package comes with pre-configured Docker containers and a straightforward setup process, enabling developers to get started quickly. With Coozila!, you can build a scalable, reliable caching infrastructure in minutes.

### Who Is It For?

- **Developers**: Aiming to enhance application performance through efficient caching strategies.
- **Organizations**: Looking to reduce database overhead while achieving faster response times with minimal complexity.
- **Teams**: In need of a robust and scalable caching solution for web applications, APIs, or data-intensive systems.

#### Specific Use Cases:

- **Web Developers**: Creating high-traffic websites or APIs.
- **E-Commerce Platforms**: Managing real-time product availability and pricing data.
- **Streaming Services**: Overseeing user preferences, recommendations, and playback data.
- **Enterprises**: Running data-intensive applications that require high availability and responsiveness.

Elevate your application's performance with the **Coozila! Memcached Cluster**—a powerful caching solution that combines the reliability of DragonflyDB with the flexibility of McRouter. Whether you're managing high-demand environments or planning for future growth, Coozila! is your ideal package for effortless deployment and unparalleled efficiency.

## Contributing

We welcome contributions to this project! Please refer to our [Contributing Guidelines](CONTRIBUTING.md) for detailed instructions on how to contribute.

For questions or contributions, feel free to contact the **Coozila! Labs** at [labs@coozila.com](mailto:lab@coozila.com).


### Code of Conduct

We are committed to fostering an inclusive and respectful environment. Please review our [Contributor Code of Conduct](CODE_OF_CONDUCT.md) for guidelines on acceptable behavior.

## References and Credits

We extend our gratitude to the creators and maintainers of the tools and technologies that power this project. Below are some key references:

### Websites:

- [Introducing McRouter: A Memcached Protocol Router for Scaling Memcached Deployments](https://engineering.fb.com/2014/09/15/web/introducing-mcrouter-a-memcached-protocol-router-for-scaling-memcached-deployments/)
- [Docker Hub Official Website](https://hub.docker.com/)
- [DragonflyDB Official Website](https://www.dragonflydb.io/)
- [Memcached Official Website](https://memcached.org/)
- [Coozila! AGI Official Website](https://agi.coozila.com/)
- [Coozila! AGI Developer API](https://agi.coozila.com/api/docs/)
- [Coozila! Official Website](https://www.coozila.com/)
- [Github Official Website](https://github.com/)

### Github:

- [DragonflyDB GitHub Repository](https://github.com/dragonflydb/dragonfly)
- [McRouter GitHub Repository](https://github.com/facebook/mcrouter)
- [Memcached GitHub Repository](https://github.com/memcached/memcached)
- [Coozila! Github main Repository](https://github.com/coozila)

### Acknowledgments:

Special thanks to **Sandeep Kongathi** for the inspiration behind this project.
- Blog: [HA Memcached with McRouter with UI on Docker Compose](https://kn-sandeep.medium.com/ha-memcached-with-mcrouter-with-ui-on-docker-compose-5eca2989afdd)  
- Website: [https://kn-sandeep.medium.com/](https://kn-sandeep.medium.com/)
- Github: [Sandeep Kongathi](https://github.com/sandeep540)

### AI Contributions:

We would also like to acknowledge **Hypatia AI**, a project of Coozila! AGI, for providing intelligent assistance and support in developing this documentation and enhancing the overall project experience.

### What is Memcached?

Memcached is a high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load. It is designed to cache data and reduce the number of times a database must be queried, thereby improving the speed and performance of applications.

### What is DragonFly?

DragonFly is a distributed database that provides a powerful, scalable, and fault-tolerant solution designed for high availability and performance. It is optimized for use cases that require efficient data retrieval and storage, making it an ideal complement to Memcached in clustered environments.

### What is McRouter?

McRouter is a high-performance Memcached router developed by Facebook. It acts as a proxy between clients and Memcached servers, allowing for better load balancing and routing of requests. McRouter can be used to scale Memcached deployments efficiently, enabling applications to handle larger amounts of cached data and improving overall performance.

### Overview of Memcached, DragonFly, and McRouter

Memcached, DragonFly, and McRouter work together to provide a robust caching and database solution for high-demand applications. By utilizing Memcached for caching frequently accessed data, applications can significantly reduce response times and database load. DragonFly, with its distributed architecture, ensures that data is stored reliably and can be accessed quickly, while McRouter optimizes the routing of requests to Memcached servers.

## Project Structure

- **Docker Compose Configuration**: Defines services for DragonflyDB and McRouter.
- **Networks**: Configured for application services.
- **Volumes**: Data persistence for DragonflyDB instances.

## Services

### DragonflyDB Servers

Three instances of DragonflyDB are configured:

1. **dragonfly1**
2. **dragonfly2**
3. **dragonfly3**

Each instance:
- Uses the image `docker.dragonflydb.io/dragonflydb/dragonfly`.
- Sets memory lock limits.
- Maps port `11211` to local ports `11212`, `11213`, and `11214`.
- Persists data in separate volumes.

### McRouter

- Image: `coozila/mcrouter:40.0.0`
- Links to the three DragonflyDB instances.
- Command configuration for routing operations.

## Trademarks and Copyright

This software listing is packaged by Coozila!. All trademarks mentioned are the property of their respective owners, and their use does not imply any affiliation or endorsement.

### Copyright

Copyright (C) 2009 - 2024 Coozila! Licensed under the MIT License.

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

Happy coding!
