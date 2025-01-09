# DragonflyDB Cluster Quick Start  

Welcome to the **DragonflyDB Cluster Docs**! Follow these steps to quickly set up and run the application.  


## 1. Clone the Repository  
Clone the Coozila! Apps repository to your local machine:  
```bash
git clone https://github.com/coozila/dragonflydb-cluster.git  
cd dragonflydb-cluster
```  

**Tip**: Before proceeding, ensure you are on the correct branch and using the appropriate version of the application.  

- **Stable Version (Recommended)**: For stability and reliability, use version `1.0.1`, the latest published stable version.  
- **Development Version**: If you prefer the latest features and updates, you can switch to the `dev` branch. However, please note:  
  - The `dev` branch is continuously updated.  
  - It may contain experimental features or changes that have not yet been fully tested.  
  - Use this version with caution, and ensure you test thoroughly in a non-production environment before deployment.  

---

## 2. Checkout the Desired Version
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

## 3. Prepare the Environment Variables  
Copy the example environment file and configure it:  
```bash
cp .env.example .env  
```  
Edit the `.env` file to set the required variables for your setup.  

---

## 4. Launch the Application  
Start the application using Docker Compose:  
```bash
docker compose up -d  
```  

---

## 5. Accessing the Services  

- **DragonflyDB Instances**:  
  - Instance 1: [http://127.0.0.1:11212](http://127.0.0.1:11212)  
  - Instance 2: [http://127.0.0.1:11213](http://127.0.0.1:11213)  
  - Instance 3: [http://127.0.0.1:11214](http://127.0.0.1:11214)  

- **McRouter Interface**:  
  - [http://127.0.0.1:11211](http://127.0.0.1:11211)  

---

## 6. Cleanup  
To stop and remove all containers and networks:  
```bash
docker compose down  
```  
To stop and remove all containers, networks, and volumes:  
```bash
docker compose down -v  
```  

---

### Cluster Variants

We provide 2 variants of the DragonflyDB cluster:

1. **Basic Cluster with 3 DragonflyDB Instances and 1 Mcrouter Instance**:
   - Documentation: [Basic Cluster Documentation](SETUP_CLUSTER_1_3.md)

2. **Intermediate Cluster with 5 DragonflyDB Instances and 3 Mcrouter Instances**:
- [3 Routers, 5 Nodes](SETUP_CLUSTER_3_5.md)  


2. **Advance Cluster with 6 DragonflyDB Instances 3 Master & 3 Slave and 3 Mcrouter Instances**:
- [3 Routers, 3 Masters, 3 Slaves](SETUP_CLUSTER_3_3_3.md)  

---

**Important Note**: If you opt for the `dev` branch, please understand that:  
- Features in this branch may be subject to change without notice.  
- Some functionalities may not work as expected or could impact performance.  
- Always test the `dev` branch in a controlled environment before deploying it in production.  

Happy coding! 🚀  
```