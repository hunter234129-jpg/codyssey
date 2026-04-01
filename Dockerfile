FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-week1-web"
ENV APP_ENV=development
COPY src/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
