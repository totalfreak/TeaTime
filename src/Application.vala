public class App : Gtk.Application {
    public App() {
        Object (
            application_id: "com.github.totalfreak.TeaTime",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    public override void activate() {

        // var button_hello = new Gtk.Button.with_label ("Wow") {
        //     margin = 12
        // };

        var label = new Gtk.Label ("What kind of tea you brewing?");

        // button_hello.clicked.connect(() => {
        //     button_hello.label = "Double wow";
        //     button_hello.sensitive = false;
        // });

        var main_window = new Gtk.ApplicationWindow(this) {
            default_height = 300,
            default_width = 300,
            title = "Tea Time"
        };
        // main_window.add(button_hello);

        main_window.add(label);


        main_window.show_all();
    }

    public static int main (string[] args) {
        return new App().run(args);
    }
}
