# koa-coffeescript #

A CoffeeScript compiler middleware for Koa 2. Use this to compile your
front‐end CoffeeScript files into JavaScript.

Note that for production you should ideally compile your front‐end CoffeeScript
into JavaScript beforehand and not run this middleware at all. You should be
serving static files like your front‐end `.js` files using a more efficient
file server like NginX.

This middleware is currently not written for production use. It does not skip
compilation if there is already a generated `.js` file with the same time as
the source `.coffee` file. It will do the compilation on every request. Fine
for development, not for production.

Based on [koa-coffee-script](https://github.com/evansdiy/koa-coffee-script).

koa-coffeescript is an update of koa-coffee-script that also lets you pass
options to the CoffeeScript compiler.


## Usage ##

Assume you have the following basic project layout.

    app
      index.coffee
      assets
      public
      views
        layout.pug
        home.pug

In `index.coffee`:

    import Koa from 'koa'
    import serve from 'koa-static'
    import coffee from 'koa-coffeescript'

    app = new Koa()

    app.use coffee
      src: path.join __dirname, 'assets'
      dst: path.join __dirname, 'public'
      compileOpt:
        bare: true
        transpile:
          presets: 'es2015'

    # Your static file serving middleware must come after the CoffeeScript
    compiler.
    app.use serve path.join __dirname, 'public'

Assuming `__dirname` is the root of your project, this will look for `.coffee`
files in your `assets` directory and compile them to a file in the same place
under your `public` directory.

In your template, link to the `.js` file that will be generated and
koa-coffeescript will make sure it gets generated.

For example, in a Pug template, to serve the JavaScript for
`assets/_js/site.coffee`, add this script tag.

    script(src="/_js/site.js")
