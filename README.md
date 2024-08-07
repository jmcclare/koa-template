# koa-template #

Template for a Node.js [Koa 2](http://koajs.com/) website.

Features:

* full [CoffeeScript](http://coffeescript.org/) 2 ES2015 (ES6) features through Babel
* [React](https://reactjs.org/) UI framework with support for [JSX](https://reactjs.org/docs/introducing-jsx.html)
* integrated tests with [Mocha](https://mochajs.org/) and [Supertest](https://github.com/visionmedia/supertest)
* continuous, incremental builds with [Gulp](https://gulpjs.com/) and [Webpack](https://webpack.js.org/)
* [Pug](https://pugjs.org/api/getting-started.html) templating system
* main Pug template and other features based on [HTML5 Boilerplate](https://html5boilerplate.com/)
* [Stylus](http://stylus-lang.com/) CSS preprocessor
  - [kouto-swiss](http://kouto-swiss.io/) Stylus framework
  - [Jeet](https://jeet.gs/) Stylus grid system
* [Font Awesome](https://fontawesome.com/) icon font
* Proper error and 404 handlers
* Production logging middleware
* Cache Buster to ensure browsers get updated static files

Check out a [live demo](http://koa-template.jmcclare.com/).


## Installation ##

Install Node, npm and coffeescript and have them available on your path.

Clone this repository and re‐initialize it as a new Git repository.

    git clone https://github.com/jmcclare/koa-template yourprojectname
    cd yourprojectname
    rm -rf .git
    git init .


## Running The Site ##

Run the site in development mode with:

    npm start

This will run the site at `http://localhost:3000`

Set the port the site runs under on the command line with `PORT=<port-number>`.
For example, to run the site under port 9966, run

    PORT=9966 npm start

`npm start` runs the site in development mode. It also monitors the directory
for changes and restarts the Node server whenever it detects any. Run this
while you’re working.

In production, run the site with:

    NODE_PATH=/path/to/app/build/lib:/path/to/app/build/site_modules:$NODE_PATH PORT=9966 /path/to/node /path/to/app/build

`/path/to/node` is the path to your `node` executable. Set the `PORT` to
whatever you need in production.

`/path/to/app/build/site_modules` is the path to the `site_modules` directory
inside the `build` directory. This needs to be in the `NODE_PATH` so that those
modules can be imported by name like the ones in `node_modules`.

In production it’s better to use `node` directly instead of our `npm` script,
but you can also test the site out in production mode with:

    npm run start-prod


## Building The Production Version of the Site ##

The files you work on and test are the development files. The version of the
site you run in production is the one in the `build` directory—the build. I
will explain each part of this below, but before you commit changes to your
repository or deploy, you should run the following to build the production
version of your site and test it.

    npm run build; npm run test-prod

The first part is `npm run build`. This does two things.

It runs `gulp clean` to delete the current build directory so that you get a
full, clean build from scratch.

Next is the core of the build process, the default gulp task. It compiles all
of the CoffeeScript, JSX, and Stylus. It copies all compiled files and other
necessary files into the `build` directory.

Running `clean` is important before you deploy a release because `build` does
not remove any files that were deleted from the development version.

The next part is `npm run test-prod`. This runs the tests (see below) on the
production code in `build`. This will verify that—at least for the back‐end—you
are building everything necessary and the code will run properly under
production settings.

You can also run `npm run cont-build` to keep a continuous, incremental build
running in the background while you work. You can use this to easily keep the
build updated so you can test in production mode. Before you deploy your code,
do a clean build and test as shown above.


## Testing The Site ##

Run the site’s integrated tests with:

    npm test

The test runner will stay open and automatically re‐run every time it detects
changes in the development files.

Integrated tests are in the `test` directory.

To test the production build, run:

    npm run test-prod

Make sure you update the build first.

If the tests are all passing in regular development mode these ones should all
pass too, but it’s good to make sure nothing went wrong while creating the
build and that there are no problems running in production mode.


## Developing Your Site ##

Add routes, middleware, and any back‐end CoffeeScript code in `core`. There are
some sample routes there to show you how to get started.

The pug templates are in `views`. You should have all templates extend
`layout.pug`. Edit or remove the sample templates as you see fit.

Edit the Stylus CSS preprocessor files in `assets/_css`. These will be compiled
and placed in `public/_css`. You can also add regular CSS library files to
`public/_css` and either import them in your main `style.styl` or link them in
your Pug template.

Edit the front end CoffeeScript files in `assets/_js`. `site.coffee` is the
entry point for your front end CoffeeScript. Make sure this imports everything
else you are using. `site.coffee` and everything imported by it will be
compiled into `public/_js/site.js`.

Edit the front end React JSX files in `assets/_js`. `react-app.jsx` is the
entry point for your main React app. You can import anything else you need from
there. `react-app.jsx` and everything imported by it will be compiled into
`public/_js/react-app.js`.

If you want to have multiple separate CoffeeScript or React JSX apps to run in
different parts of your site you will have to add more entry points for them to
`core/webpack.conf.coffee`, `gulpfile.coffee` and link to them in whatever
template will use them in `views`.

You can place any files to be served statically in `public`. Use the
appropriate sub‐directory though. Only things like `favicon.ico`, `robots.txt`,
and `humans.txt` need to go in the root of `public`.

Put your integrated site‐wide tests in `test`. Make sure to import your test
files in `test/index.coffee`.

There is also a quick command you can use during development to run both the
development server and the continuous build. You can keep this running in the
background while you are working:

    npm run dev

### Site Modules ###

There are a few sample site modules in the `site_modules` directory.

The `site_modules` directory is added to the `NODE_PATH` by all of the scripts
in `package.json`. That means you can import any of the site modules by name in
your back end CoffeeScript code. Make sure you also add `site_modules` to the
`NODE_PATH` when you are running in production as well.

For files that need to be in `assets`, `public`, `test`, or `views`, you need
to either symlink (preferred) or copy them into their main app directory. Views
often need to be copied because you need to customize their markup for the site
you are using the module in.

You can give instructions on exactly what needs to be symlinked or copied where
in your site module’s README, but here is the general best practice.

Let’s assume you have a site module named `dummy-module` in your `site_modules`
directory. Here is its directory layout.

    site_modules/
      dummy-module/
        assets/
          _css/
            index.styl/
            component.styl/
          _js/
            index.jsx/
            component.jsx/
        public/
          _img/
            dummy-icon.png/
        test/
          index.coffee/
          subset.coffee/
        views/
          list.pug/
          detail.pug/

You should design your site module so that all of the directories for these
files are symlinked into their main app directories as `dummy-module`.

For CSS (Stylus `.styl` files) `site_modules/dummy-modle/assets/_css` will be
symlnked to `assets/_css/dummy-module`. You will import the `index.styl` from
`assets/_css/site.styl` with `@import './dummy-module'`.

You will do the same for the other types of resources. Here is where you would
create symlinks in the main app directory.

    assets/
      _css/
        dummy-module/
      _js/
        dummy-module/
    public/
      _img/
        dummy-module/
    test/
      dummy-module/
    views/
      dummy-module/

This keeps the files for each site module separate, easy to update (via
symlinks) and easy to remove.

If your site module needs Node packages that are not used in the default site
template, nor by any other site modules, you can keep a separate `package.json`
and `node_modules` directory in the site module’s directory.


## Versions ##

Aside from what is here in the app’s local library directories (`node_modules`,
`site_modules`, `lib`), these are the versions of software dependencies this
site template has been tested with.

* node: v8.9.4
* npm: 5.6.0
* npx: 9.7.1
* coffee: CoffeeScript version 2.2.2
* js2coffee: 2.2.0


## Exporting The Site To Static Files ##

As of 2024-07-12 I no longer plan to build any new Node.js sites and I do not
want to deal with running Node.js processes on my servers to run my existing
Node.js sites. Instead, I will use `wget` to mirror these sites to static files
and serve those using NGinX alone.

The contact page on the Sakuramai site was the only page on any of my Node.js
sites that did anything dynamically on the backend and that had to be turned
into a JavaScript obscured link to the team’s email address, so there is
nothing that I need an active Node.js backend process for.

To export this site to static files run:

    source ./bin/set-env
    export-static

This will create a fully up to date static mirror of the site in
`static-export`

You can copy the files in that directory to the public root of a web server and
have a static version of the site.
