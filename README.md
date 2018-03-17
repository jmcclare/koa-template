# koa-template #

Template for a Node.js [Koa 2](http://koajs.com/) website.

Features:

* full [CoffeeScript](http://coffeescript.org/) 2 ES2015 (ES6) features through Babel
* integrated tests with [Mocha](https://mochajs.org/) and [Supertest](https://github.com/visionmedia/supertest)
* continuous, incremental builds with [Gulp](https://gulpjs.com/)
* [Pug](https://pugjs.org/api/getting-started.html) templating system
* main Pug template and other features based on [HTML5 Boilerplate](https://html5boilerplate.com/)
* [Stylus](http://stylus-lang.com/) CSS preprocessor


## Installation ##

Install Node, npm and coffeescript and have them available on your path.

Clone this repository.

For development, run the site with `npm start`

In production, run the site with `PORT=3000 coffee --transpile server.coffee`

Set `PORT` to whatever port you want to run the Node server under.


## Basic Configuration ##

You can run the site with no configuration, but to customize it for your
environment copy `core/site.coffee.ex` to `core/site.coffee` and complete
all of the `TODO`’s in it. `config/site.coffee` is excluded by Git.


## Running The Site ##

Run the site with:

  npm start

This will run the site at `http://localhost:3000`

Set the port the site runs under on the command line with `PORT=<port-number>`.
For example, to run the site under port 9966, run

    PORT=9966 npm start

`npm start` runs the site in development mode. It also monitors the directory
for changes and restarts the Node server whenever it detects any. Run this
while you’re working.

In production, run the site with:

    PORT=9966 /path/to/node ./build

`/path/to/node` is the path to your `node` executable.

You can also test the site out in production mode with `npm run start-prod`

In production it’s better to use `node` directly instead of our `npm` script.


## Building The Site ##

The files you work on and test are the development files. The version of the
site you run in production is the one in the `build` directory—the build. To
update the build, run `npm run build`

To flush out any unneeded files and do a fresh build, run `npm run clean; npm
run build`

You should do that whenever you delete or rename a `.coffee` file.

While you are working, you should keep the continuous, incremental build
running in the background to keep the build updated for you. Run that with `npm
run cont-build`


## Testing The Site ##

Run the site’s integrated tests with `npm test`

The test runner will stay open and automatically re‐run every time it detects
changes in the development files.

Integrated tests are in the `test` directory.


## Developing Your Site ##

Add routes, middleware, and any back‐end CoffeeScript code in `core`. There are
some sample routes there to show you how to get started.

The pug templates are in `views`. You should have all templates extend
`layout.pug`. Edit or remove the sample templates as you see fit.

Edit the Stylus CSS preprocessor files in `assets/_css`. These will be compiled
and placed in `public/_css`. You can also add regular CSS library files to
`public/_css` and either import them in your main `style.styl` or link them in
your Pug template.

Edit the front end CoffeeScript files in `assets/_js`. They will be compiled
into JavaScript files that go in `public/_js`.

You can place any files to be served statically in `public`. Use the
appropriate sub‐directory though. Only things like `favicon.ico`, `robots.txt`,
and `humans.txt` need to go in the root of `public`.

Put your integrated site‐wide tests in `test`. Make sure to import your test
files in `test/index.coffee`.
