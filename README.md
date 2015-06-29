# Defence Solicitor Service Rota
[![Code
Climate](https://codeclimate.com/github/ministryofjustice/defence-request-service-rota/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/defence-request-service-rota)

This application receives content from
[ministryofjustice/defence-request-service-auth](https://github.com/ministryofjustice/defence-request-service)
to build solicitor rotas.

## Environment Variables

See `.example.env`. Add any new Env vars required to this file, setting
placeholder data for them.

## API documentation
Written using API Blueprint syntax: https://apiblueprint.org/ into apiary.apib

To generate a new HTML format locally run: ```bin/render_api```
(requires [aglio](https://github.com/danielgtaylor/aglio))

API docs accessible from /api.html

## Local Setup

To get the application running locally, you need to:

 * ### Clone the repository
 	``` git clone git@github.com:ministryofjustice/defence-request-service-rota.git```

 * ### Install ruby 2.2.2
 	It is recommended that you use a ruby version manager such as [rbenv](http://rbenv.org/) or [rvm](https://rvm.io/)

 * ### Install postgres
 	http://www.postgresql.org/
 	
 * ### Install clingo
 	This can be downloaded from [here](http://sourceforge.net/projects/potassco/files/clingo/).
 	
  	**Note**: Ensure to download version `3.0.5` and **not** version `4.x`.

 * ### Bundle the gems
       cd defence-request-service
       bundle install

 * ### Create and migrate the database; run seeds

 		bundle exec rake db:create
 		bundle exec rake db:migrate
 		bundle exec rake db:seed

 * ### Follow the same steps to set up the auth app

 	This application uses a corresponding oauth server, which will also need to be running locally. It can be found [here](https://github.com/ministryofjustice/defence-request-service-auth)

 * ### Start both servers

 		cd defence-request-service-rota && bundle exec rails server
 		cd defence-request-service-auth && bundle exec rails server

 * ### Use the app

 	You can find the service app running on `http://localhost:34343`

### Test setup

To run the tests, you will need to install [PhantomJS](http://phantomjs.org/), the test suite is known to be working with version `1.9.7`, it may or may not work with other versions. To run the tests, use the command: ```bundle exec rake```

### Rota generation

In order for the rotas to be generated, ```clingo``` will need to be installed (as instructed above). In order to
view what facts are being written, and what response ```clingo``` returns, simply set the environment variable
```ENV[CLINGO_DEBUG]```. Once set, these will be written out to the log file.

### Remote Authentication

The tag `remote-authentication` has been created in order to mark the point at which remote authentication
with the Auth app is stripped out. Please checkout this tag in order to familiarise yourself with how this
used to work.


