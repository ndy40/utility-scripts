# Docker

All things removing docker images and containers. 

https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes



# Django Tips

## Enable logging in Django for DB Queries
During debugging sessions you may want to enable query logs to the console in your django app. 

```
LOGGING["loggers"].update({'django.db.backends': {
    'level': 'DEBUG',
    'handlers': ['console'],
}})
```

## Deprecating and removing fields in Django Orm in a production environment 
package: https://github.com/3YOURMIND/django-deprecate-fields


# Books or Web resources

* [DJango Admin Cookbook](https://books.agiliq.com/projects/django-admin-cookbook/en/latest/index.html) - Everything to do with working with Django Admin Sites. 


# Webhook tool
* https://webhook.cool/at/drab-dawn-98

# Rest Postgres
* https://github.com/PostgREST/postgrest
