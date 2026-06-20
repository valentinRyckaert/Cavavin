require 'gtk3'
require 'webkit2-gtk'


app = Gtk::Application.new("org.example.cavavin", :flags_none)

app.signal_connect("activate") do |application|

  window = Gtk::ApplicationWindow.new(application)
  window.title = "Cavavin"
  window.set_default_size(800, 600)

  web_view = WebKit2Gtk::WebView.new

  web_view.load_uri("http://localhost:4567")

  window.add(web_view)

  window.show_all
end

app.run
