FROM frojd/wp-cli-php-7.4
	
# Setup Pressbooks CLI
RUN wp package install pressbooks/pb-cli:dev-dev --allow-root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
