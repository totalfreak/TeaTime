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
    public int initialTimeWhenStarted = 0;
    public bool timerStarted = false;

    public Gtk.Button startButton;

    public Timer teaTimer = new Timer();

    public Gtk.Label TimeLeftLabel;

    public override void activate() {
        var grid = new Gtk.Grid();
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.row_spacing = 6;
        grid.margin = 12;

        timeLeft = timeMinutesWhiteTea * 60;
        initialTimeWhenStarted = timeLeft;

        var timeLeftText = setTimeLeftLabel();

        TimeLeftLabel = new Gtk.Label(timeLeftText);
        grid.add(TimeLeftLabel);

        var label = new Gtk.Label ("What kind of tea you brewing?");
        grid.add(label);

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

        startButton = new Gtk.Button.with_label("Start");
        startButton.margin_top = 12;
        startButton.clicked.connect(startButtonClicked);
        grid.add(startButton);

        var main_window = new Gtk.ApplicationWindow(this) {
            default_height = 200,
            default_width = 200,
            resizable = false,
            window_position = Gtk.WindowPosition.CENTER,
            title = "Tea Time"
        };

        main_window.destroy.connect(() => {

        });

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
            timeLeft = timeMinutesBlackTea * 60;
        }

        setTimeLeftLabel();
    }

    private void startButtonClicked() {
        if (!timerStarted) {
            timerStarted = true;
            startButton.sensitive = false;
            initialTimeWhenStarted = timeLeft;
            Granite.Services.Application.set_progress_visible.begin(true);
            var thread = new Thread<void>("TeaTimer", countdown);
        }
    }

    private void countdown() {
        if (timeLeft > 0)
        {
            Thread.usleep(1000000);
            timeLeft -= 1;
            setTimeLeftLabel();
            double percentage = (((double)timeLeft / (double)initialTimeWhenStarted) - 1.0).abs();
            Granite.Services.Application.set_progress.begin(percentage);
            countdown();
        }
        else
        {
            var notification = new Notification("Your tea is ready!");

            var icon = new GLib.ThemedIcon ("dialog-warning");
            notification.set_icon (icon);
            notification.set_body("Get that tea bag out of there.");

            send_notification("TeaTimer", notification);

            Granite.Services.Application.set_progress_visible.begin(false);

            timerStarted = false;
            startButton.sensitive = true;
            timeLeft = initialTimeWhenStarted;
        }
    }

    private string setTimeLeftLabel() {
        var timeLeftMinutes = (timeLeft / 60).to_string();
        if (int.parse(timeLeftMinutes) < 10) {
            timeLeftMinutes = @"0$timeLeftMinutes";
        }
        var timeLeftSeconds = (timeLeft % 60).to_string();
        if (int.parse(timeLeftSeconds) < 10) {
            timeLeftSeconds = @"0$timeLeftSeconds";
        }
        var timeLeftText = @"$timeLeftMinutes:$timeLeftSeconds";

        TimeLeftLabel.label = timeLeftText;

        return timeLeftText;
    }

    public static int main (string[] args) {
        return new App().run(args);
    }
}
