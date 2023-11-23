# Use an official Node.js runtime as the base image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Use nginx to serve the React app

# Use an official nginx runtime as the base image
FROM nginx:1.17.1-alpine

# Copy the react build files to the nginx html directory
COPY --from=0 /app/build /usr/share/nginx/html

# Remove the default nginx config file
RUN rm /etc/nginx/conf.d/default.conf

# Copy the nginx config file from the current directory to the container
COPY nginx/nginx.conf /etc/nginx/conf.d

# Expose port 80 to the outer world
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]