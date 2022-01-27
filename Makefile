.PHONY: list

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

up-build:
	cp .env.example .env
	docker-compose up -d && sleep 5
	docker-compose exec -u root app chown -R www-data:www-data /var/www/html
	docker-compose exec -u root app chmod 755 -R /var/www/html/bootstrap/cache
	docker-compose exec -u root app chmod 755 -R /var/www/html/storage
	docker-compose exec -u root app chmod 755 /var/www/html/package-lock.json
	docker-compose exec app composer install
	docker-compose exec app npm install
	docker-compose exec app npm run dev
	docker-compose exec app php artisan key:generate
	docker-compose exec app php artisan optimize:clear
	docker-compose exec app php artisan migrate

up:
	docker-compose up -d && sleep 5
	$(MAKE) cache

down:
	docker-compose stop

npm-install:
	docker-compose exec app npm install
	$(MAKE) cache

cache:
	docker-compose exec app php artisan cache:clear
	docker-compose exec app php artisan view:clear
	docker-compose exec app php artisan route:clear
	docker-compose exec app php artisan config:clear

npm:
	docker-compose exec app npm run watch

ssh:
	docker-compose exec app sh

