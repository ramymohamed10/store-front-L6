# Build the Vue.js app
FROM node:20 AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Nginx for serving the built app and acting as a reverse proxy
FROM nginx:alpine

# Copy the custom NGINX configuration file for reverse proxy
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the built app from the build-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 80 for the NGINX web server
EXPOSE 80

# Start NGINX when the container starts
CMD ["nginx", "-g", "daemon off;"]
