ARG PORT=3000

FROM node:14-alpine AS node

# Build stage

FROM node AS builder

# Use /app as the CWD
WORKDIR /app

# Copy package.json and package-lock.json to /app
COPY package.json yarn.lock ./   

# Install all dependencies
RUN npm i               

# Copy the rest of the code
COPY . .                

# Invoke the build script to transpile ts code to js
RUN yarn build

# Open desired port
EXPOSE ${PORT}

# Run development server
ENTRYPOINT [ "yarn", "dev" ]

# Final stage

FROM node AS final

# Set node environment to production
ENV NODE_ENV production

# Update the system
RUN apk --no-cache -U upgrade

# Prepare destination directory and ensure user node owns it
RUN mkdir -p /home/node/app/dist && chown -R node:node /home/node/app

# Set CWD
WORKDIR /home/node/app

# Copy package.json, package-lock.json and process.yml
COPY package.json yarn.lock ./

# Switch to user node
USER node

# Install libraries as user node
RUN yarn --prod

# Copy js files and change ownership to user node
COPY --chown=node:node --from=builder /app/dist ./dist

# Open desired port
EXPOSE ${PORT}

# Use js files to run the application
ENTRYPOINT ["node", "./dist/index.js"]  