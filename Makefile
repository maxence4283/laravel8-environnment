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
	docker-compose exec app php artisan key:generate
	docker-compose exec app composer install
	docker-compose exec app npm install
	docker-compose exec app php artisan optimize:clear

