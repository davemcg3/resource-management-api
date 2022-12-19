LUCI Systems Coding Challenge Notes

User Management Dashboard
- Functionalities:
  1. A list of users
  2. A way to update the users' data

Tech Design

I _think_ what you've done with this prompt is think about your existing system and then abstract out a small part of that system into a technical challenge. You didn't isolate the rest of the system out of the prompt, so there's mention about viewing and editing a map, but I don't see how that is a feature of a user management system. You can have an address, but that's not the same as editing a map. Based on our feature discussions from the other day, and the implications of the wording of the prompt, I don't think what you want to see is a user management system, but instead a user authorization system that allows or disallows classes of users privileges over various resources within the application. I'm going to build that, and include the specific features you requested in the prompt.

Most people take the approach of building a user object with authentication details and a handful of attributes on it. I've done that a few times but have found there always ends up being this other entity, like a business entity, that users request and needs to be accounted for. Instead of starting at the basic user model like other people do, I now separate the concerns of a user into at least two classes, and I think it's important to address those up front so it's not confusing when you step into the code.

The "user" object in the system contains the authentication for the user themselves, but not any of the user data.

On the other side of that, a user should have a public-facing profile, so I create a Profile where the public details of the user can be stored. A Profile can be a personal profile, or one of many types of organizations (business, government, etc.) What I have found is that any type of organizational entity, and even many users, want to be able to delegate permissions to other people to operate on behalf of their profile. For example, a CEO might want to delegate access to their social media accounts to a social media manager at the company, or sometimes to their secretary, or to anyone else they trust to post for them. It is also not uncommon for people to belong to many organizations that trust them to operate on behalf of the organizations' profiles. So, Users can operate as many Profiles, and Profiles can be associated to many Users. The way I approach this is building a many-to-many association between accounts and profiles and in the interface building a profile-switcher component.

That should help explain some of the "unnecessary" database complexity that exists around users here. I'm happy to explain this further or better on a call if you need, but I have found that it's better to build this abstraction in from the beginning because as soon as users start using the system it's one of the first things they request. The "List" in your example will be a list of Profiles, not a list of users/accounts.

Both your front-end and back-end requirements specify unit testing. I don't typically unit test because I find on teams they often get in the way of refactoring (ie unit tests are written in such a way that a refactor will cause them to fail). Unit tests, from my understanding, should be testing the boundaries of the unit, ie x input always gives y output and generates z side-effect. That's seldom the way they're written. But when you get into even deeper refactorings, sometimes the functionality that lives within certain units gets moved to other units, and at that time unit tests fail.

I have found that a more useful way to test the application is to test the flows the user wants to perform. For example, a user wants to register, or a user wants to login, or a user wants to update their information. Have the code changes we've made broken anything about that user flow? This is best accomplished by System Testing, in my experience. There are smaller sections of the system that can be tested by Integration Testing, if there are particularly tricky edge cases or contracts in play that you want to verify. That won't test the entire system, but just particular parts of it. I'll include Unit Tests here because it's in the requirements, but I'm dubious about their usefulness and they sometimes test the same things as System Tests.

Database Tables:
User
- email
- password
- sign_in_count
- current_sign_in_at
- last_sign_in_at
- current_sign_in_ip
- last_sign_in_ip
- created_at
- updated_at

rails g migration CreateUsers email:string password_digest:string sign_in_count:integer current_sign_in_at:datetime last_sign_in_at:datetime current_sign_in_ip:string last_sign_in_ip:string

I've added these fields but haven't added the code to set them yet.

Organization
- id
- name

rails g migration CreateOrganizations name:string

Group
- id
- name

rails g migration CreateGroups name:string

Profile
- Organization (personal, business, non-profit, government, community organization)
- Name
- Picture (later revision)
- Email
- Phone
- Group (User, Marketing, Admin, Engineering, etc.) (also consider HR or other business functions)
- State (Active, Inactive)

rails g migration CreateProfiles organization:references name:string email:string phone:string group:references state:binary 

This is as far as I've implemented at the time of committing this file.
Resource
- Product Id
- Serial
- State (healthy, failed)
- Location
- Channel
Products
- Type (tv, sensor, etc.)
- Brand
- Model
Channels
- Name
- Number
- Description
- Currently playing

- Permissions/Authorizations (CRUD user/group/feature, View/Edit Map, etc.) (maybe move this elsewhere)

Questions from the prompt:  
  • What data format/structure did you choose as your API response and why?
    	I chose to build a RESTful API because the particular functionality to be managed in this app is a very discrete set of resources and standard CRUD operations on them, which is most closely aligned to a RESTful application.
    • What classes/components did you choose and why?
    • Why did you choose a specific design pattern?
    • Why did you choose to use an array rather than a map as a data structure in a specific component?
    • Why include/exclude specific technologies/libraries?
		Pundit discussion about authorization vs rolling own

UI wireframes
Basic software design/UML diagram

* Front-End Development
* Must Use React
* Minimum JavaScript ES6
* Unit Tested

Bonus
* Use hooks
* Use a state management library
* Nice  looking and easy to use UI
* Responsive Design (can use Bootstrap and Material but we would also like to see your personal CSS/SASS/etc. styling abilities)
* Use a linter


Back-End Development
Any language is fine, just make sure it's Unit Tested

Bonus
Use an actual database for storage/updates (Serverless database preferred for simplicity, e.g. SQLite)
- I'm dockerizing the application and using PostgreSQL for the main database, and Redis and Sidekiq to handle any asynchronous jobs. The dockerization should handle the simplicity of the database


Additional Info

* First, tell us how to pull and run your application(s) so we can test.
* For you, what are the one or two most glaring omissions in what you’ve built in each step?
* What, if anything, did you need to learn to finish this assessment?
    I've never properly setup this machine for all types of my development (reformatted recently), so I need to install docker using these instructions: https://linuxhint.com/install-docker-on-pop_os/ and installed docker-compose with `sudo apt install docker-compose -y`
    Added the user to the docker group with these instructions: https://stackoverflow.com/a/48450294
    Dockerizing a Rails App: 
    	Primary resource: https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application
    	Secondary resources: 
    		https://hub.docker.com/_/ruby
    		https://www.digitalocean.com/community/tutorials/containerizing-a-ruby-on-rails-application-for-development-with-docker-compose
    		https://docker-docs.netlify.app/compose/rails/#rebuild-the-application
    I used a "Perfect Rails 5 API" blog as a starter (https://ntam.me/building-the-perfect-rails-5-api-only-app/) for core concepts, updated for Rails 7:
    	Setting up Rails
    		"rails new" options for Rails 7: https://gist.github.com/kirillshevch/1b52f711e66b064416d746f07e834c00
    		docker run -it -v $PWD:/usr/src/app rails-toolbox rails new --database=postgresql --skip-bundle --skip-test --skip-system-test --skip-git --skip-keeps --skip-action-mailer --skip-action-mailbox --skip-action-text --skip-action-cable --skip-javascript --skip-hotwire --skip-jbuilder --api resource-management-api
    		docker run -it -v $PWD:/usr/src/app rails-toolbox rake secret
    		Added a dockerfile to the rma container in docker-compose.rails https://stackoverflow.com/a/57724377
    		Solve bundle issue: https://stackoverflow.com/a/53703933 In Dockerfile.rails I switched frozen from 1 to 0 on line 5
    		Had to add the Dockerfile.rails reference to sidekiq container as well
    		Added an environment variable specific to the port puma is listening on
    		References for fixing sidekiq not connecting to redis (moved the config file into the initializer folder)
    			https://yizeng.me/2019/11/17/add-sidekiq-to-a-docker-compose-managed-rails-project/
    				https://www.cloudbees.com/blog/get-started-quickly-with-docker-and-sidekiq
		Cache store configuration: https://guides.rubyonrails.org/caching_with_rails.html#cache-stores
		To run a command try these:
			docker run -it -v $PWD:/usr/src/app rails-toolbox 
			docker run resource-management-api_rma 
		To login to the container try this:
			docker exec -ti <container id> /bin/sh
			docker exec -ti 3462b0959121 /bin/sh
    	Setting up RSpec: https://dev.to/adrianvalenz/setup-rspec-on-a-fresh-rails-7-project-5gp
    		Setup the db: https://stackoverflow.com/a/11158685
    		Use factory bot: https://devhints.io/factory_bot
    		generate data with faker: https://fakerjs.dev/api/internet.html#password
    		test model validation: https://til.hashrocket.com/posts/af87b1eaa8-test-validation-errors-with-rspec
    		error messages: https://medium.com/@rfleury2/a-quick-guide-to-model-errors-in-rails-965e2be3ac93
    		bundle exec rspec spec/system/user_actions_spec.rb
    	Building API
        Authenticating - Normally I would use devise for user authentication but for an API-only app it feels like overkill.
    	Serializing API Output
    	Enabling CORS: https://www.stackhawk.com/blog/rails-cors-guide/
    	Versioning: Covered here: https://dev.to/nemwelboniface/api-with-rails-7-ngh
    	Rate Limiting and Throttling: https://github.com/rack/rack-attack
    	API Documentation with Swagger UI
    * Any issues or concerns you had with the assessment and what you would change, if anything, going forward?
    * Anything extra you want to add.

Bonus:
    * Have the example application hosted

When finished double-check:
1. Technical design
2. Front-end development
3. Back-end development
4. Additional info
5. Bonus

My bonus items:
Lead funnel
Observability
Metrics
Dashboard
Slack notifications



Basically destroy runs any callbacks on the model while delete doesn't.

Need to move to cheat sheet:
100 = :continue
101 = :switching_protocols
102 = :processing
200 = :ok
201 = :created
202 = :accepted
203 = :non_authoritative_information
204 = :no_content
205 = :reset_content
206 = :partial_content
207 = :multi_status
226 = :im_used
300 = :multiple_choices
301 = :moved_permanently
302 = :found
303 = :see_other
304 = :not_modified
305 = :use_proxy
307 = :temporary_redirect
400 = :bad_request
401 = :unauthorized
402 = :payment_required
403 = :forbidden
404 = :not_found
405 = :method_not_allowed
406 = :not_acceptable
407 = :proxy_authentication_required
408 = :request_timeout
409 = :conflict
410 = :gone
411 = :length_required
412 = :precondition_failed
413 = :request_entity_too_large
414 = :request_uri_too_long
415 = :unsupported_media_type
416 = :requested_range_not_satisfiable
417 = :expectation_failed
422 = :unprocessable_entity
423 = :locked
424 = :failed_dependency
426 = :upgrade_required
500 = :internal_server_error
501 = :not_implemented
502 = :bad_gateway
503 = :service_unavailable
504 = :gateway_timeout
505 = :http_version_not_supported
507 = :insufficient_storage
510 = :not_extended