FROM node:20-bullseye

WORKDIR /opt/app

COPY package.json package-lock.json ./

RUN npm ci

COPY . .

RUN npm run build

EXPOSE 1337

CMD ["npm", "start"]