# App Symfony

### Usage

```shell
mkdir -p $(pwd)/.composer
```

```shell
docker run -it --rm \
-u $(id -u):$(id -g) \
-v $(pwd)/src:/src \
-v $(pwd)/.composer:/var/cache/composer \
aartintelligent/ops-composer:latest \
install
```

```shell
docker run -it --rm \
-u $(id -u):$(id -g) \
-v $(pwd)/src:/src \
-v $(pwd)/.composer:/var/cache/composer \
aartintelligent/ops-composer:latest \
update
```

```shell
docker build . \
--tag aartintelligent/app-symfony:latest \
--build-arg "UID=$(id -u)" \
--build-arg "GID=$(id -g)" \
--build-arg "GIT_COMMIT=$(git rev-parse HEAD)" \
--build-arg "PHP_VERSION=8.3"
```

```shell
docker run -d \
--net host \
--name app-symfony \
aartintelligent/app-symfony:latest
```

```shell
docker container logs app-symfony
```

```shell
docker exec -it app-symfony supervisorctl status
```

```shell
docker exec -it app-symfony supervisorctl stop server:server-fpm
```

```shell
until docker exec -it app-symfony /docker/d-health.sh >/dev/null 2>&1; do \
  (echo >&2 "Waiting..."); \
  sleep 2; \
done
```

```shell
docker exec -it app-symfony supervisorctl start server:server-fpm
```

```shell
docker exec -it app-symfony bash
```

```shell
docker stop app-symfony
```

```shell
docker rm app-symfony
```
