# Use the official Node.js image as the base image
FROM node:latest AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install Angular CLI and other dependencies
RUN npm install  -g @angular/cli && npm install --legacy-peer-deps

# Copy the entire application to the container
COPY . .

# Build the Angular app for production
RUN ng build 

# Use the official NGINX image as the base image for the final image
FROM nginx:latest


# Copy the built Angular app from the previous stage to the NGINX web root directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for the NGINX server
EXPOSE 80

# Start NGINX server when the container is run
CMD ["nginx", "-g", "daemon off;"]
