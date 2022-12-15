# Resource Management API and Front-End Example

## Initial Spin-up
To use this repository in the simplest fashion please install docker and docker-compose using whichever instructions are correct for your system.

To spin up open a command line and enter:

```docker-compose up --build```

The first build _may_ be slow as all the docker images are downloaded. Once downloaded the following components will be spun up:
1. postgres db on port 5432
2. redis on port 6379
3. sidekiq for async jobs
4. rails api on port 8010
5. nginx reverse proxy on port 8020
6. (eventually) a next.js app on port 8030

### Rails API
* Ruby version: 3.1.3
* System dependencies: The whole thing is dockerized so as long as you have docker and docker-compose installed it should spin up without issue.
* Configuration: No particular configuration options should need to be set, but if you want to see what is being used the most pertinent ones can be found in the .env file, which normally wouldn't be committed to the repo but I did it this time for simplicity of sharing the setup.
* Find the name and id of your docker container with:
```
docker ps
```
* Access the docker container with this command:
```
docker exec -ti <container id> /bin/sh
```
* Database creation: Should happen automatically on initial spin up. If not the commands to run inside the docker container are:

```
rails db:create
rails db:migrate
```

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

