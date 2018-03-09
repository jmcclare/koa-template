# koa-template #

Template for a Node.js Koa2 website.

Features:

* full CoffeeScript 2 ES6 (ES2015) features through Babel.

## Installation ##

Install Node, npm and coffeescript and have them available on your path.

Clone this repository.

For development, run the site with `npm start`

In production, run the site with `PORT=3000 coffee --transpile server.coffee`

Set `PORT` to whatever port you want to run the Node server under.

## Basic Configuration ##

Set the port the site runs under on the command line with `PORT=<port-number>`.
For example, to run the site under port 9966, run

    PORT=9966 coffee --transpile server.coffee

Copy `config/site.coffee.ex` to `config/site.coffee` and complete all of the
`TODO`’s in it. `config/site.coffee` is excluded by Git.
