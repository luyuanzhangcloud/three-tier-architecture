FROM amazonlinux
RUN yum -y install httpd
RUN yum -y install git
RUN echo ?Hello World from $(hostname -f)? > /var/www/html/index.html

CMD ["/user/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80
