public class App : Gtk.Application {
    public App() {
        Object (
            application_id: "com.github.totalfreak.TeaTime",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    public int timeMinutesWhiteTea = 2;
    public int timeMinutesGreenTea = 3;
    public int timeMinutesBlackTea = 5;

    public int timeLeft = 0;
    public bool timeStarted = false;

    public Gtk.Label TimeLeftLabel;

    public override void activate() {

        // var button_hello = new Gtk.Button.with_label ("Wow") {
        //     margin = 12
        // };

        var grid = new Gtk.Grid();
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.row_spacing = 6;
        grid.margin = 24;

        var timeLeftMinutes = timeLeft / 60;
        var timeLeftSeconds = timeLeft % 60;

        var timeLeftText = @"$timeLeftMinutes:$timeLeftSeconds";

        TimeLeftLabel = new Gtk.Label(timeLeftText);
        grid.add(TimeLeftLabel);

        var label = new Gtk.Label ("What kind of tea you brewing?");
        grid.add(label);

        var startButton = new Gtk.Button.with_label("Start");
        grid.add(startButton);

        var teaBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

        var whiteTeaButton = new Gtk.RadioButton.with_label_from_widget(null, "White tea");
        teaBox.pack_start(whiteTeaButton, false, false, 0);
        whiteTeaButton.toggled.connect(toggled);

        var greenTeaButton = new Gtk.RadioButton.with_label_from_widget(whiteTeaButton, "Green tea");
        teaBox.pack_start(greenTeaButton, false, false, 0);
        greenTeaButton.toggled.connect(toggled);

        var blackTeaButton = new Gtk.RadioButton.with_label_from_widget(greenTeaButton, "Black tea");
        teaBox.pack_start(blackTeaButton, false, false, 0);
        blackTeaButton.toggled.connect(toggled);

        grid.add(teaBox);

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

        main_window.add(grid);

        main_window.show_all();
    }

    private void toggled (Gtk.ToggleButton button) {
        if (button.label == "White tea") {
            timeLeft = timeMinutesWhiteTea * 60;
        }
        else if (button.label == "Green tea") {
            timeLeft = timeMinutesGreenTea * 60;
        }
        else if (button.label == "Black tea") {
            timeLeft = timeMinutesGreenTea * 60;
        }

        var timeLeftMinutes = timeLeft / 60;
        var timeLeftSeconds = timeLeft % 60;

        var timeLeftText = @"$timeLeftMinutes:$timeLeftSeconds";

        TimeLeftLabel.label = timeLeftText;
    }

    public static int main (string[] args) {
        return new App().run(args);
    }
}
