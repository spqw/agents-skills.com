FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY robots.txt /usr/share/nginx/html/robots.txt
COPY sitemap.xml /usr/share/nginx/html/sitemap.xml
COPY compare/ /usr/share/nginx/html/compare/
COPY dev-recipes/ /usr/share/nginx/html/dev-recipes/
COPY llm-benchmark/ /usr/share/nginx/html/llm-benchmark/
COPY vs/ /usr/share/nginx/html/vs/
EXPOSE 80
