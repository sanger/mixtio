# mixtio
## Installation (for testing)
Remove ".sample" from the following filenames:
* config/ldap.yml
* config/mailer.yml
* config/print_service.yml
* config/secrets.yml

In config/application.rb line 25, set:
~~~
config.stub_ldap = true
~~~

Run `bundle install`, then `rails server` and navigate to http://localhost:3000
