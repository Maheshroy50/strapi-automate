version: "3.9"

services:
  postgres:
    image: postgres:16-alpine
    container_name: postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: strapi
      POSTGRES_PASSWORD: strapiPassword
      POSTGRES_DB: strapi
    volumes:
      - strapi_data:/var/lib/postgresql/data
    networks:
      - strapi-net

  strapi:
    image: ${strapi_image}
    container_name: strapi
    restart: unless-stopped
    environment:
      NODE_ENV: production
      DATABASE_CLIENT: postgres
      DATABASE_HOST: postgres
      DATABASE_PORT: 5432
      DATABASE_NAME: strapi
      DATABASE_USERNAME: strapi
      DATABASE_PASSWORD: strapiPassword
      JWT_SECRET: myjwtsecret123
      ADMIN_JWT_SECRET: myadminjwtsecret123
      APP_KEYS: key1,key2,key3,key4
      API_TOKEN_SALT: somerandomlongsecurestring123456
    depends_on:
      - postgres
    ports:
      - "1337"
    networks:
      - strapi-net

  nginx:
    image: nginx:alpine
    container_name: nginx
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - strapi
    networks:
      - strapi-net

volumes:
  strapi_data:

networks:
  strapi-net:
    driver: bridge
