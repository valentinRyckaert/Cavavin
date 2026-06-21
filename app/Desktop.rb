require 'gtk3'
require 'webkit2-gtk'
require 'dotenv'


class Desktop

  def initialize
    Dotenv.load('.env')
    @app = Gtk::Application.new("org.example.cavavin", :flags_none)

    @app.signal_connect("activate") do |application|

      window = Gtk::ApplicationWindow.new(application)
      window.title = "Cavavin"
      window.set_default_size(800, 600)

      web_view = WebKit2Gtk::WebView.new

      web_view.load_uri("http://#{ENV["WEBAPP_IP"]}:#{ENV["WEBAPP_PORT"]}")

      window.add(web_view)

      window.show_all
    end
  end

  def run
    @app.run
  end
end

Desktop.new.run