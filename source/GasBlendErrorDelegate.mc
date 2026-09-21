using Toybox.WatchUi as Ui;

class GasBlendErrorDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {

        Ui.popView(
            Ui.SLIDE_RIGHT
        );

        return true;
    }

    function onSelect() {

        Ui.popView(
            Ui.SLIDE_RIGHT
        );

        return true;
    }
}