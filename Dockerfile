# Use official nginx image
FROM nginx:alpine

# Copy our static site into nginx web root
COPY /usr/share/nginx/html/

# Expose HTTP port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
