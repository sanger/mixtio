# mixtio

Reagent creation and barcoding service for DNA Pipeline.

## Installation (for testing and development)
1. Remove ".sample" from the following file names:
  * config/ldap.yml
  * config/mailer.yml
  * config/print_service.yml
  * config/secrets.yml
2. In config/application.rb line 25, set:
~~~
config.stub_ldap = true
~~~
3. In Rails console (`$ rails console`):
~~~
> team = Team.create(name: "Team Name")
> user = User.create(username: "Username", team_id: team.id)
~~~
4. Run `rails server` and navigate to http://localhost:3000
5. Log in with your chosen username and no password.

### Initialising data
To initialize data while dev-ing/testing run:
`rake consumables:load`

## Testing
To run tests, execute: `rake spec`

## Misc

### Gems used
* Testing: [RSpec Rails](https://github.com/rspec/rspec-rails)
* Pagination: [Kaminari](https://github.com/kaminari/kaminari)
* Creating test data: [Factory Girl](https://github.com/thoughtbot/factory_girl)
* For testing web interactions: [Capybara](https://github.com/teamcapybara/capybara)
