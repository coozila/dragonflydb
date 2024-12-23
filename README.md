<p align="center">
    <img width="233px" height=auto src="https://www.coozila.com/static/themes/prometheus/img/coozila.png" />
</p>


<p align="center">
    <a href="https://github.com/coozila/dragonflydb/releases" target="__blank">
        <img src="https://img.shields.io/badge/dynamic/yaml?color=success&label=downloads&query=$.downloads.total&url=https://raw.githubusercontent.com/coozila/dragonflydb/master/downloads.yml" alt="Total Downloads" />
    </a>
    <a href="https://twitter.com/coozila" target="__blank">
        <img src="https://img.shields.io/twitter/follow/coozila?style=social" alt="Follow on Twitter" />
    </a>
    <a href="https://www.facebook.com/coozila" target="__blank">
        <img src="https://img.shields.io/badge/follow-on%20facebook-1877F2?style=social" alt="Follow on Facebook" />
    </a>
    <a href="https://github.com/coozila/dragonflydb" target="__blank">
        <img src="https://img.shields.io/github/stars/coozila/dragonflydb?style=social" alt="GitHub stars" />
    </a>
    <a href="https://github.com/coozila/dragonflydb" target="__blank">
        <img src="https://img.shields.io/github/forks/coozila/dragonflydb?style=social" alt="GitHub forks" />
    </a>
    <a href="https://github.com/coozila/dragonflydb/blob/main/LICENSE" target="__blank">
        <img src="https://img.shields.io/badge/license-MIT-1c7ed6" alt="License" />
    </a>
</p>


## Sponsors

**If you want to support our project and help me grow it, you can [become a sponsor on GitHub](https://github.com/sponsors/coozila)

<p align="center">
  <a href="https://github.com/sponsors/coozila">
  </a>
</p>

# DragonflyDB Cluster

## Coozila! Docker Package APP for Memcached Cluster with DragonflyDB and McRouter

The Coozila! Package for Memcached Cluster integrates DragonflyDB and McRouter to provide a robust, high-performance caching solution for modern applications. Designed to enhance scalability and efficiency, this package allows developers to easily deploy a distributed caching layer that alleviates database load and improves response times.

### Key Features:

- **High Availability**: DragonflyDB ensures that your data is stored reliably with fault tolerance, making it ideal for high-demand environments.
- **Optimized Caching**: Leverage McRouter to efficiently route requests between multiple Memcached servers, enabling better load balancing and resource management.
- **Easy Deployment**: The package includes pre-configured Docker containers and a straightforward setup process, allowing you to get started quickly.
- **Scalable Architecture**: Easily scale your caching infrastructure to meet the demands of your applications as they grow.

This package is perfect for developers looking to enhance their application's performance through effective caching strategies while maintaining simplicity in deployment and management.


## Contributing

We welcome contributions to this project! Please refer to our [Contributing Guidelines](CONTRIBUTING.md) for detailed instructions on how to contribute.

For questions or contributions, feel free to contact the **Coozila! Lab** at [lab@coozila.com](mailto:lab@coozila.com).


### Code of Conduct

We are committed to fostering an inclusive and respectful environment. Please review our [Contributor Code of Conduct](CODE_OF_CONDUCT.md) for guidelines on acceptable behavior.

---

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

---

### What is Memcached?

Memcached is a high-performance, distributed memory object caching system, generic in nature, but intended for use in speeding up dynamic web applications by alleviating database load. It is designed to cache data and reduce the number of times a database must be queried, thereby improving the speed and performance of applications.

### What is DragonFly?

DragonFly is a distributed database that provides a powerful, scalable, and fault-tolerant solution designed for high availability and performance. It is optimized for use cases that require efficient data retrieval and storage, making it an ideal complement to Memcached in clustered environments.

### What is McRouter?

McRouter is a high-performance Memcached router developed by Facebook. It acts as a proxy between clients and Memcached servers, allowing for better load balancing and routing of requests. McRouter can be used to scale Memcached deployments efficiently, enabling applications to handle larger amounts of cached data and improving overall performance.

### Overview of Memcached, DragonFly, and McRouter

Memcached, DragonFly, and McRouter work together to provide a robust caching and database solution for high-demand applications. By utilizing Memcached for caching frequently accessed data, applications can significantly reduce response times and database load. DragonFly, with its distributed architecture, ensures that data is stored reliably and can be accessed quickly, while McRouter optimizes the routing of requests to Memcached servers.

## Copyright

```
Copyright (C) 2009 - 2024 Coozila! MIT License
See the full license at: [Coozila! License](https://github.com/coozila/dragonflydb/license.md)
```

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

## Prerequisites

Before you begin, ensure you have the following installed on your system:

- Docker
- Docker Compose

## Getting Started

### 1. Create the Private Network

Before building the containers and images, you must manually create the `stack_private_network`:

```bash
docker network create --driver bridge stack_private_network --subnet=172.16.0.0/16
```

### 2. Clone the Repository

Clone the Coozila! Apps repository to your local machine:

```bash
git clone https://github.com/coozila/dragonflydb.git
cd dragonflydb
```

### 3. Prepare the Environment Variables

Copy the example environment file and set the necessary variables:

```bash
cp .env.example .env
```

Edit the `.env` file to set the required environment variables.

### 4. Launch the Application

Run the following command to launch the application:

```bash
docker compose up -d
```

### 5. Accessing the Services

- DragonflyDB instances:
  - Instance 1: [http://127.0.0.1:11212](http://127.0.0.1:11212)
  - Instance 2: [http://127.0.0.1:11213](http://127.0.0.1:11213)
  - Instance 3: [http://127.0.0.1:11214](http://127.0.0.1:11214)

- McRouter interface:
  - [http://127.0.0.1:11211](http://127.0.0.1:11211)

## Cleanup

To stop and remove all containers, networks, and volumes, run:

```bash
docker compose down
```

## Installation Assistance

If you would like assistance with the installation of this product, please contact **Coozila! Lab** at [lab@coozila.com](mailto:lab@coozila.com). Our team is ready to help you with the installation process and ensure a smooth setup.

Based on the size and complexity of your project, we will provide you with a tailored pricing quote.

For purchasing the installation, please visit the following link: [Coozila Docker Package App for Memcached](https://www.coozila.com/plus/view-product/coozila-docker-package-app-for-memcached).

You can also check out the official Coozila! Lab page for more information: [Coozila! Lab](https://www.coozila.com/plus/view-organization-profile/coozila-lab).

For any inquiries, feel free to reach out through our contact page: [Contact Coozila!](https://www.coozila.com/plus/contact).

### After Purchase Notes

After your purchase, please provide the following information via email:

- Server login credentials
- An SSH key for secure access
- Details about the project you wish to integrate

## Additional Documentation

For more details, please refer to the main repository: [Coozila! Apps](https://github.com/coozila/apps).

## Trademarks

This software listing is packaged by Coozila!. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## License

This project is licensed under the MIT License. See the full license at: [Coozila! License](https://github.com/coozila/dragonflydb/blob/master/LICENSE).


## Disclaimer

This product is provided "as is," without any guarantees or warranties regarding its functionality, performance, or reliability. By using this product, you acknowledge that you do so at your own risk. Coozila! and its contributors are not liable for any issues, damages, or losses that may arise from the use of this product. We recommend thoroughly testing the product in your own environment before deploying it in a production setting.

Happy coding!
