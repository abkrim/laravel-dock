# Laravel Docker Image

Pre-built PHP-FPM Alpine images optimized for Laravel applications.


## Quick Start

```bash
docker pull abkrim/laravel-dock:8.4
```


## Available Tags

| Tag | PHP Version | Status |
|-----|-------------|--------|
| `8.4`, `latest` | PHP 8.4 | Active |
| `8.3` | PHP 8.3 | Active |
| `8.5` | PHP 8.5 | Planned |


## Included Extensions

- **Database**: pdo_mysql, pdo_pgsql
- **Image**: gd (with freetype and jpeg)
- **Compression**: zip
- **Performance**: opcache, redis
- **Laravel required**: mbstring, exif, pcntl, bcmath, intl


## Usage

### Docker Compose

```yaml
services:
  app:
    image: abkrim/laravel-dock:8.4
    volumes:
      - ./:/var/www/html
    working_dir: /var/www/html
```


### GitLab CI

```yaml
test:
  image: abkrim/laravel-dock:8.4
  script:
    - composer install
    - php artisan test
```


### GitHub Actions

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    container: abkrim/laravel-dock:8.4
    steps:
      - uses: actions/checkout@v4
      - run: composer install
      - run: php artisan test
```


## Build Locally

```bash
# Build for PHP 8.4
docker build --build-arg PHP_VERSION=8.4 -t laravel-dock:8.4 .

# Build for PHP 8.3
docker build --build-arg PHP_VERSION=8.3 -t laravel-dock:8.3 .
```


## Configuration

The image runs as non-root user `laravel` (UID 1000).

PHP settings:

- memory_limit: 512M
- upload_max_filesize: 100M
- post_max_size: 100M
- opcache: enabled and optimized


## Repository

- **GitHub**: https://github.com/abkrim/laravel-dock
- **Docker Hub**: https://hub.docker.com/r/abkrim/laravel-dock


## License

MIT