# Defence Solicitor Service Rota
[![Code
Climate](https://codeclimate.com/github/ministryofjustice/defence-request-service-rota/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/defence-request-service-rota)

## Environment Variables

See `.example.env`. Add any new Env vars required to this file, setting
placeholder data for them.

## Local Setup

To get the application running locally, you need to:

 * ### Clone the repository
 	``` git clone git@github.com:ministryofjustice/defence-request-service-rota.git```

 * ### Install ruby 2.2.2
 	It is recommended that you use a ruby version manager such as [rbenv](http://rbenv.org/) or [rvm](https://rvm.io/)

 * ### Install postgres (9.4 or better)
 	http://www.postgresql.org/

 * ### Install clingo
 	This can be downloaded from [here](http://sourceforge.net/projects/potassco/files/clingo/).

  	**Note**: Ensure to download version `3.0.5` and **not** version `4.x`.

 * ### Bundle the gems
       cd defence-request-rota
       bundle install

 * ### Create and migrate the database; run seeds

 		bundle exec rake db:reset

 * ### Start server

 		cd defence-request-service-rota && bundle exec rails s
>>>>>>> update readme with port changes

 * ### Use the app

 	You can find the rota app running on `http://localhost:3000`

### Test setup

To run the tests, you will need to install [PhantomJS](http://phantomjs.org/), the test suite is known to be working with version `1.9.7`, it may or may not work with other versions. To run the tests, use the command: ```bundle exec rake```

### Rota generation

In order for the rotas to be generated, ```clingo``` will need to be installed (as instructed above). Clingo must be on the PATH of the user the process if running under.

In order to view what facts are being written, and what response ```clingo``` returns, simply set the environment variable
```ENV[CLINGO_DEBUG]```. Once set, these will be written out to the log file.

### Remote Authentication

The tag `remote-authentication` has been created in order to mark the point at which remote authentication
with the Auth app is stripped out. Please checkout this tag in order to familiarise yourself with how this
used to work.


