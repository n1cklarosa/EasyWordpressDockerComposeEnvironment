curl -sS https://wordpress.org/latest.zip > file.zip && \
unzip file.zip                                       && \
rm file.zip
mkdir themes && \
mkdir plugins && \
mkdir docker-compose && \
mkdir docker-compose/mysql && \
cp -r ./wordpress/wp-content/themes/* ./themes/ && \
cp -r ./wordpress/wp-content/plugins/* ./plugins/ && \
cp ./wordpress/wp-config-sample.php ./wordpress/wp-config.php && \
sed -i 's/password_here/wordpress_password/g' ./wordpress/wp-config.php && \
sed -i 's/database_name_here/wordpress_db/g' ./wordpress/wp-config.php && \
sed -i 's/username_here/wordpress_user/g' ./wordpress/wp-config.php

