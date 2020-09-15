Here is docker-compose file that will containerise all the services required to run a local wordpress development enviroment. All your theme, plugin and upload files are stored in your local file tree and can be backed up and edited as your normally would.

It comes with a setup script to get you going on Linux and Macos in a few seconds, windows users will need to follow a few extra steps.

Read more info on this on my blog here (here)[https://blog.nicklarosa.net/articles/easy-wordpress-docker-compose/]

**This project leverages the work from done in the following three projects found on DockerHub**

[Mysql5.7](https://hub.docker.com/r/ymnoor21/mysql5.7/)

[Local Wordpress](https://hub.docker.com/r/alfiemx/local-wordpress)

[Wordpress CLI](https://hub.docker.com/_/wordpress)

### Requirements

- Docker Desktop - <a href="https://docs.docker.com/get-docker/" target="_blank">Get Docker</a> 
- Docker Composer - Windows and Mac users will have docker-compose available once Docker Desktop is installed. Linux users will need to follow the guide found <a href="https://docs.docker.com/compose/install/" target="_blank">here.</a> 
- Git - <a href="https://www.atlassian.com/git/tutorials/install-git">Installation instructions</a>

### Initial Setup

Clone this repo or download the zip directly.

###### For Mac and Linux

Using a terminal, navigate to a folder you want to house your project in, and run the following.

```git clone https://github.com/n1cklarosa/EasyWordpressDockerComposeEnvironment.git
cd EasyWordpressDockerComposeEnvironment
chmod 770 setup.sh
./setup.sh
```

`setup.sh` will create the required folders, download Wordpress then configure the wp-config.php for this project.

###### For Windows Users

You will need to create the following folders in the root of your project

/docker-compose/mysql

/wordpress

/themes

/plugins

Then [download](https://en-au.wordpress.org/latest-en_AU.zip) and unzip the Wordpress files to the /wordpress folder. You will need to update the wp-config.php details to match the following

```
define( 'DB_NAME', 'wordpress_db' );
define( 'DB_USER', 'wordpress_user' );
define( 'DB_PASSWORD', 'wordpress_password' );
define( 'DB_HOST', '127.0.0.1' );
```

### Usage

#### Starting Docker 

Run the following from the root of your project.

```
docker-compose up -d
```

Running the above for the first time will download the required docker containers, provided you don't happen to have them cached locally from another project. 

Once the above command is run, you should see a response like the following. 

```
Creating network "docker_default" with the default driver
Creating local-wordpress-db ... done
Creating local-wordpress    ... done
```

If all went well, you can now access your new Wordpress installation with the url http://localhost

To end your docker container, run the following from the root of your project. The local files used will still be in tact

```
docker-compose down
```

#### Connecting with MYSQL

The docker-compose file will setup a MYSQL server on port 3306 (this can be altered in the `docker-compose.yml` file). You can connect to the server using the following details

- Hostname: 127.0.0.1
- Username: wordpress_user
- Password: wordpress_password
- Schema: wordpress_db

![Image showing Mysql Credentials](mysql-config.jpg)


#### Importing a .sql file using the Command Line

Example command using local mysql install (ie - not using a docker installation of mysql)

```/path/to/mysql -h 127.0.0.1 -u wordpress_user -p wordpress_dv < data.sql```

#### Finding Docker Container ID

To find the ID of your container, run the following command

```
docker ps
```

You will see an output like the following, we are looking for the wordpress:latest container. 

```
ed72061e0466        wordpress:latest    "docker-entrypoint.s…"   7 hours ago         Up 7 hours          0.0.0.0:80->80/tcp                   local-wordpress
3b2678b45ad2        mysql:5.7           "docker-entrypoint.s…"   7 hours ago         Up 7 hours          33060/tcp, 0.0.0.0:18766->3306/tcp   local-wordpress-db
```

You can see from our above example, that the container ID for wordpress is *ed72061e0466* and the database container is *3b2678b45ad2*

#### PHP Error monitoring

On mac and linux, you can use the following command to show a continuous reading of errors on your Wordpress install. Grab the ID from your wordpress container using the above instructions.

```
docker logs -f CONTAINER_ID 2>&1 >/dev/null | grep -i error
```

Swap CONTAINER_ID with the ID docker has assigned to your running container. Here is an example using the above example

```
docker logs -f ed72061e0466 2>&1 >/dev/null | grep -i error
```

#### WP Cli

Example setup of test instance using WP-Cli. This can be run after the setup.sh script to setup your wordpress instance.

```
docker-compose run wpcli wp core install --path=/var/www/html  --url=http://localhost --title="Local Wordpress" --admin_user=admin --admin_email=my@email.com --admin_password=mypassword 
```

#### Exporting the db using the command line

Using the instructions above, find your container ID for the local-wordpress-db  container(the example above shows *3b2678b45ad2*)

```
docker exec CONTAINER_ID /usr/bin/mysqldump -u root --password=somewordpress wordpress_db > backup.sql
```

Example of command with container ID from above example of `ps` output

```
docker exec 3b2678b45ad2 /usr/bin/mysqldump -u root --password=somewordpress wordpress_db > backup.sql
```