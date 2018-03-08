# koa-template

Template for a Node.js Koa2 website.

Features:

* full CoffeeScript 2 ES6 (ES2015) features through Babel.

## Installation ##

Clone this repository.

Run the site with either `npm start` or `coffee --transpile server.coffee`

## Basic Configuration ##

Set the port the site runs under on the command line with `PORT=<port-number>`.
For example, to run the site under port 9966, run

    PORT=9966 coffee --transpile server.coffee

Copy `config/site.coffee.ex` to `config/site.coffee` and complete all of the
`TODO`’s in it.
