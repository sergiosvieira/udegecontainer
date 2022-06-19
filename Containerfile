FROM registry.fedoraproject.org/fedora:35
LABEL AUTHOR="Sergio Vieira"
ENV PORT=80
RUN dnf -y install git make python nginx fcgiwrap cronie cracklib diffutils discount fakechroot procmail bash procmail tidy gcc g++ tidy java-11-openjdk lua nodejs initscripts
RUN mkdir -p /etc/nginx/sites-enabled
ARG WWWDATA_GUID=82
ENV WWWDATA_GUID=82
RUN groupadd www-data
#RUN adduser -u ${WWWDATA_GUID} -G www-data -s /bin/sh -D www-data
RUN adduser -g www-data www-data
RUN mkdir -p /etc/nginx/conf.d /var/log/nginx /usr/local/nginx/html  
#RUN chmod +x /usr/local/bin/*
RUN chown -R www-data:www-data /usr/local/nginx
RUN chown -R www-data:www-data /etc/nginx 
RUN nginx -v # buildkit
RUN git clone https://github.com/rudymatela/udge.git
RUN cd udge && make V=1 install
RUN echo -e "tmpfs /run/udge   tmpfs rw,nosuid,nodev,relatime,size=12288k,mode=755,uid=udge,gid=udge   0 0\ntmpfs /run/udge/1 tmpfs rw,nosuid,nodev,relatime,size=12288k,mode=775,uid=udge,gid=udge-1 0 0\ntmpfs /run/udge/2 tmpfs rw,nosuid,nodev,relatime,size=12288k,mode=775,uid=udge,gid=udge-2 0 0\ntmpfs /run/udge/3 tmpfs rw,nosuid,nodev,relatime,size=12288k,mode=775,uid=udge,gid=udge-3 0 0\ntmpfs /run/udge/4 tmpfs rw,nosuid,nodev,relatime,size=12288k,mode=775,uid=udge,gid=udge-4 0 0\ntmpfs /run/udge/5 tmpfs rw,nosuid,nodev,relatime,size=12288k,mode=775,uid=udge,gid=udge-5 0 0\ntmpfs /run/udge/6 tmpfs rw,nosuid,nodev,relatime,size=12288k,mode=775,uid=udge,gid=udge-6 0 0" >> /etc/fstab 
RUN sudo -u udge udge-update-all-problem-htmls
RUN sudo -u udge udge-update-rank-html
RUN echo "127.0.0.1 udge udge.example.com" >> /etc/hosts
#RUN /etc/inid.d/nginx start
#RUN systemctl start nginx
#RUN chkconfig nginx on
#CMD ["service", "nginx", "start"]
RUN cd udge && make enable-nginx-udge-site
ENTRYPOINT [ "nginx -g 'daemon off;'"]
#CMD ["udge-create-run"]
#CMD ["service", "fcgiwrap.socket", "start"]
#CMD ["service", "fcgiwrap", "start"]
#CMD ["service", "nginx", "start"]
#RUN cd udge && make enable-nginx-udge-site
EXPOSE 80