Sylius Starter Standard
=======================

Documentation
-------------

Documentation is available at [docs.sylius.com](http://docs.sylius.com).

Installation
------------

```bash
docker-compose up -d
docker exec -it sylius_php composer install
docker exec -it sylius_php bin/console sylius:install
docker exec -it sylius_php bin/console assets:install
docker exec -it sylius_php bin/console sylius:theme:assets:install public
docker exec -it sylius_nodejs yarn build
```

