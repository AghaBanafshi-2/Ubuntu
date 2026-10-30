FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nginx \
    ttyd \
    supervisor \
    apache2-utils \
    gettext-base \
    curl \
    && rm -rf /var/lib/apt/lists/*

# کاربر dev برای ترمینال
RUN useradd -m -s /bin/bash dev && mkdir -p /data && chown -R dev:dev /data

# کپی فایل‌ها
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf
COPY .htpasswd /etc/nginx/.htpasswd
COPY www/ /var/www/html/

# اسکریپت شروع: اول envsubst برای PORT، بعد supervisord
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080
CMD ["/start.sh"]
