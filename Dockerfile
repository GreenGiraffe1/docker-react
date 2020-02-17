
# First step, in multi-stage build process
# From this line down, is all refered to as "builder" phase
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
# Don't use volume-system since we're not worried about
# the build-phase being "fat", since we're going to cut
# away unneeded things in phase 2, also we don't need to update
# the files immediatly on change.  Prod files don't change.
COPY . .
# Build folder will be created in the working directory
# /app/build  <-- all the build stuff
RUN npm run build

# Just having a second "FROM" tells docker previous phase is over
FROM nginx
# --from= Syntax means "copy from another phase"
# Location to copy to specific for nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Default command of nginx is to start the server container
# so we don't have to specify one