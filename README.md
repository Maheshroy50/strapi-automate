

# 🚀 Dockerized Strapi with PostgreSQL & Nginx Reverse Proxy

This project demonstrates a fully Dockerized production-style setup of Strapi, PostgreSQL, and Nginx, connected via a user-defined Docker network.

---

## 🏗 Architecture Overview

Browser → localhost:80  
        ↓  
      Nginx  
        ↓  
      Strapi (1337 internal)  
        ↓  
      PostgreSQL (5432 internal)

All services run inside a user-defined Docker network:

strapi-net

---

## 📦 Prerequisites

- Docker installed
- Docker running
- Node.js (only required to build the Strapi image locally)

---

## 🔹 Step 1: Create User-Defined Network

```
docker network create strapi-net
```

Verify:

```
docker network ls
```

---

## 🐘 Step 2: Run PostgreSQL Container

```
docker run -d \
  --name postgres \
  --network strapi-net \
  -e POSTGRES_USER=strapi \
  -e POSTGRES_PASSWORD=strapiPassword \
  -e POSTGRES_DB=strapi \
  -v strapi_data:/var/lib/postgresql/data \
  postgres:16-alpine
```

- Uses proper credentials
- Uses persistent Docker volume
- Attached to strapi-net

---

## 🐳 Step 3: Build Strapi Docker Image

Inside the Strapi project directory:

```
docker build -t my-strapi-app .
```

---

## 🚀 Step 4: Run Strapi Container (Production Mode)

```
docker run -d \
  --name strapi \
  --network strapi-net \
  -p 1337:1337 \
  -e HOST=0.0.0.0 \
  -e PORT=1337 \
  -e NODE_ENV=production \
  -e APP_KEYS=key1,key2,key3,key4 \
  -e JWT_SECRET=myjwtsecret123 \
  -e ADMIN_JWT_SECRET=myadminjwtsecret123 \
  -e DATABASE_CLIENT=postgres \
  -e DATABASE_HOST=postgres \
  -e DATABASE_PORT=5432 \
  -e DATABASE_NAME=strapi \
  -e DATABASE_USERNAME=strapi \
  -e DATABASE_PASSWORD=strapiPassword \
  my-strapi-app
```

Test directly (optional):

http://localhost:1337/admin

---

## 🌐 Step 5: Configure Nginx Reverse Proxy

Create a file named nginx.conf in the project root:

```
events {}

http {
  server {
    listen 80;

    location / {
      proxy_pass http://strapi:1337;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_cache_bypass $http_upgrade;
    }
  }
}
```

---

## 🌍 Step 6: Run Nginx Container

```
docker run -d \
  --name nginx \
  --network strapi-net \
  -p 80:80 \
  -v "$(pwd)/nginx.conf":/etc/nginx/nginx.conf:ro \
  nginx:alpine
```

- Maps host port 80 → Nginx container
- Proxies requests to Strapi internally
- Connected to strapi-net

---

## ✅ Final Result

Access the Strapi Admin Dashboard at:

http://localhost/admin

---

## 🔍 Verify Running Containers

```
docker ps
```

You should see:

- postgres
- strapi
- nginx

---

## 🧠 Key Concepts Demonstrated

- User-defined Docker networking
- Container-to-container communication using Docker DNS
- Environment variable-based configuration
- Production-mode Strapi deployment
- Persistent database storage with Docker volumes
- Nginx reverse proxy setup
- Multi-container architecture without Docker Compose

---


