# mixtio
## Installation (for testing and development)
Remove ".sample" from the following filenames:
* config/ldap.yml
* config/mailer.yml
* config/print_service.yml
* config/secrets.yml

In config/application.rb line 25, set:
~~~
config.stub_ldap = true
~~~

In Rails console:   
`team = Team.create(name: "Team Name")`  
`user = User.create(username: "Username", team_id: team.id)`  


then `rails server` and navigate to http://localhost:3000

Log in with your chosen username and no password.
