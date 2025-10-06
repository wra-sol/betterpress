FROM wordpress:6.6-php8.2-apache

# Copy entrypoint to adjust Apache to PORT provided by Railway
COPY docker/wp-entrypoint.sh /usr/local/bin/wp-entrypoint.sh
RUN chmod +x /usr/local/bin/wp-entrypoint.sh

# Default envs appropriate for container behavior
ENV WORDPRESS_CONFIG_EXTRA="define('FS_METHOD', 'direct');"

# Ensure wp-content path exists (Railway volume will mount over it)
RUN mkdir -p /var/www/html/wp-content && chown -R www-data:www-data /var/www/html/wp-content

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/wp-entrypoint.sh"]
CMD ["apache2-foreground"]


