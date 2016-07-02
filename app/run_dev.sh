# Remember as a koa project this needs harmony features available in node 0.11.x

export NODE_PATH=modules
export NODE_ENV=dev

APP=${1-""}

echo $APP

if [ "$APP" == "console" ]; then
    node bootstrap.js console
else
    grunt watch &
    node_modules/.bin/nodemon -w config -w modules -w app.js -w bootstrap.js -w lib -i modules/webserver/frontend/ -i modules/webserver/public/ bootstrap.js
fi
