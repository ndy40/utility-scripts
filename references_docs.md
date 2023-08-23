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


## Books or Web resources

* [DJango Admin Cookbook](https://books.agiliq.com/projects/django-admin-cookbook/en/latest/index.html) - Everything to do with working with Django Admin Sites. 
