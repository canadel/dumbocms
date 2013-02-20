# DumboCMS

DumboCMS is a CMS.

## Installation

```bash
bundle install
bundle exec rake db:schema:load db:test:prepare
bundle exec rake test
```

## Database schema
Current database schema can be found in /db/schema.rb 

## API
DumboCMS has API, that can be used for get info about resources such as pages, users, etc and modify them.

API URL (version 1): http://dumbocms.com/api/v1/
API URL (last version): http://dumbocms.com/api/

For example, list of pages can be found here:
```
http://dumbocms.dev/api/v1/pages
```

API requires authentication, that can be completed by transfering user token in GET parameters or API key in headers.

If you want to use token authentication, you should use follow URL:
```
http://dumbocms.dev/api/v1/pages?token={your_token}
```
where
```
{your_token} = MD5(SUBSTR(SHA1(email), 5, 25)).
```

