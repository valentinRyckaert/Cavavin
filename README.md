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

#### Create .env file
```
LAUNCH_TYPE=desktoponly
DB_PATH=database.csv
WEBAPP_IP=127.0.0.1
WEBAPP_PORT=4567
```

#### Launch
```shell
bundle exec ruby app.rb
```
Web app is accessible at http://localhost:4567.

## Release

Pushing a `vX.Y.Z` tag runs `.github/workflows/release.yml`, which attaches to a GitHub release:
- `Cavavin-x86_64.AppImage`: desktop app (GTK/WebKit embedded). `database.csv` is created in the launch directory.
- `Cavavin.exe`: WebKitGTK does not exist on Windows, so the exe runs in web mode: open http://localhost:4567 in a browser. `database.csv` and the optional `.env` live next to the exe.

Without a `.env`, defaults are `DB_PATH=database.csv`, `WEBAPP_IP=127.0.0.1`, `WEBAPP_PORT=4567` and `LAUNCH_TYPE=webonly` on Windows / `desktoponly` elsewhere.

## Features to code
- makes code independent from database
- web security
- translation
- dark theme
- web to desktop security (token)
- toogle for authentication or not
- .env file
- scripts for install/launch (web, web/desktop, desktop only, linux, windows...)
