# Generated by https://smithery.ai. See: https://smithery.ai/docs/config#dockerfile
# Use a Node.js image
FROM node:20-bullseye-slim AS builder

# Set the working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --ignore-scripts

# Copy source files
COPY src ./src

# Build the project
RUN npm run build

# Use a smaller Node.js runtime image for the final output
FROM node:20-bullseye-slim

# Set the working directory
WORKDIR /app

# Copy built files and node_modules from the builder stage
COPY --from=builder /app/build ./build
COPY --from=builder /app/node_modules ./node_modules

# Set the entrypoint to run the server
ENTRYPOINT ["node", "build/index.js"]
