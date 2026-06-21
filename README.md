# Cavavin

## Presentation

Cavavin is a Single Page Application (SPA) written in Ruby to organize your wine cellar.

The application is made with a Sinatra web server and a GTK3 interface connected to it.

The advantage is that the app can be used as a regular web application or a desktop one.

## Installation

#### Install Ruby and Bundler
See [Ruby Documentation](https://www.ruby-lang.org/en/documentation/installation/) depending on your OS.

After that, install the Bundler gem:
```shell
gem install bundler
```

#### Clone Code
```shell
git clone https://github.com/valentinRyckaert/Cavavin.git
cd Cavavin
```

#### Install dependencies

Gems are installed in the rubydep/ directory. If you want to restart gem installation, just delete the folder.

```shell
bundle install
```

If the installation fails, especially on native extension building, you likely lack from some stuff like `gcc` or `make` packages. Search on the Internet.

#### Create database
Cavavin uses a CSV file as database:
```shell
touch database.csv # in the root directory
```

#### Launch
```shell
ruby web.rb
ruby app.rb # in another shell
```
Web app is accessible at http://localhost:4567.

## Features to code
- makes code independent from database
- web security
- translation
- dark theme
- web to desktop security (token)
- toogle for authentication or not
- .env file
- migrate to my own CSS/JS
- scripts for install/launch (web, web/desktop, desktop only, linux, windows...)
