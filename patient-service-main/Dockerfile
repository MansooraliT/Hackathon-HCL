FROM node:14-alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

# Use this instead of CMD ["npm", "start"]
CMD ["node", "index.js.js"] 