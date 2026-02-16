# 🐳 Docker Deep Dive
**Author:** Mahesh Bhoopathi Rao  
**Date:** 11 February 2026

---

## 📌 Table of Contents
1. The Problem Docker Solves  
2. Virtual Machines vs Docker  
3. Docker Architecture (Deep Dive)  
4. How Containers Actually Work (Namespaces & cgroups)  
5. Dockerfile Deep Dive  
6. Image Layering & Caching  
7. Key Docker Commands  
8. Docker Networking (Advanced)  
9. Volumes & Persistence  
10. Docker Compose & Orchestration  
11. Security Best Practices  
12. Conclusion  

---

# 1️⃣ The Problem Docker Solves

Before Docker, deploying applications across environments caused major challenges:

- Dependency mismatches  
- OS-level inconsistencies  
- Manual environment setup  
- Configuration drift between dev, staging, and production  

This led to the common issue:

> “It works on my machine.”

Docker solves this by packaging:

- Application code  
- Runtime  
- Dependencies  
- Configuration  

Into a standardized, portable unit called a **container**.

### Core Philosophy

> Build once. Run anywhere.

---

# 2️⃣ Virtual Machines vs Docker

## 🖥 Virtual Machines

Architecture:

Host OS → Hypervisor → Guest OS → Application

Each VM contains a full operating system.

### Characteristics
- Heavyweight  
- Slower startup  
- Higher memory usage  
- Strong isolation  

---

## 🐳 Docker Containers

Architecture:

Host OS → Docker Engine → Containers → Application

Containers share the host OS kernel.

### Characteristics
- Lightweight  
- Faster startup  
- Efficient resource usage  
- Process-level isolation  

Docker achieves efficiency by avoiding multiple OS kernels.

---

# 3️⃣ Docker Architecture (Deep Dive)

When Docker is installed, the following components are available:

##  Docker Client (CLI)
Used to communicate with Docker Daemon.

##  Docker Daemon (dockerd)
Responsible for:
- Building images  
- Running containers  
- Managing networks  
- Managing volumes  

##  Docker Engine
Core runtime that manages container lifecycle.

##  containerd
Low-level container runtime that executes containers.

##  Docker Registry
Stores images (Docker Hub or private registry).

---

# 4️⃣ How Containers Actually Work

Docker containers rely on Linux kernel features:

##  Namespaces
Provide isolation for:
- Process IDs  
- Network  
- Mount points  
- Users  

Each container believes it has its own isolated system.

##  cgroups (Control Groups)
Limit and manage:
- CPU usage  
- Memory usage  
- Disk I/O  

This ensures containers do not consume unlimited resources.

---

# 5️⃣ Dockerfile Deep Dive

Example:

```dockerfile
FROM node:20-alpine
WORKDIR /opt/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build
USER node
EXPOSE 1337
CMD ["npm", "start"]
```

### Key Concepts

- `FROM` defines base image.
- `WORKDIR` sets execution directory.
- Copying dependency files first optimizes layer caching.
- `RUN` executes during build time.
- `CMD` executes at container runtime.
- `USER node` improves security.

### ENTRYPOINT vs CMD

- `ENTRYPOINT` defines the main executable.
- `CMD` provides default arguments.

---

# 6️⃣ Image Layering & Caching

Each Dockerfile instruction creates a new immutable layer.

Benefits:
- Faster rebuilds  
- Layer reuse  
- Efficient storage  

Best Practice:
- Copy dependency files before application source code.

---

# 7️⃣ Key Docker Commands

### Build
```
docker build -t my-app .
```

### Run
```
docker run -d -p 1337:1337 my-app
```

### Inspect
```
docker inspect container_name
```

### Logs
```
docker logs container_name
```

### Network Inspect
```
docker network inspect network_name
```

---

# 8️⃣ Docker Networking (Advanced)

Docker network drivers:

- bridge (default)  
- host  
- none  
- overlay (Swarm mode)  

## User-Defined Bridge Network

Advantages:
- Automatic DNS resolution  
- Service name-based communication  
- Better isolation  

Example:
```
DATABASE_HOST=postgres
```

Docker internally runs an embedded DNS server.

---

# 9️⃣ Volumes & Persistence

Containers are ephemeral by design.

## Types of Storage

### Named Volumes
Managed by Docker.

### Bind Mounts
Mount host directory directly into container.

### tmpfs
Stored in memory only.

Volumes decouple storage lifecycle from container lifecycle.

---

# 🔟 Docker Compose & Orchestration

Docker Compose allows defining multi-container setups declaratively.

Example:

```yaml
services:
  postgres:
  strapi:
  nginx:
```

Start all services:
```
docker compose up -d
```

Benefits:
- Centralized configuration  
- Automatic network creation  
- Service dependency management  
- Reproducible environments  

Note: `depends_on` controls startup order but does not wait for full service readiness.

---

# 1️⃣1️⃣ Security Best Practices

- Use minimal base images (e.g., alpine)  
- Run containers as non-root users  
- Avoid hardcoding secrets  
- Use .env files or secret management  
- Limit container resources using cgroups  

---

# 1️⃣2️⃣ Conclusion

Docker standardizes application deployment through lightweight containers built on kernel-level isolation mechanisms. It improves portability, scalability, and operational efficiency.

Key technical concepts demonstrated:

- Kernel-level isolation (Namespaces & cgroups)  
- Layered image architecture  
- Networking & DNS resolution  
- Volume persistence  
- Multi-container orchestration using Docker Compose  

Docker is a foundational technology in modern DevOps, CI/CD pipelines, and cloud-native architectures.