using Toybox.WatchUi as Ui;

class GasBlendCalculationResultsDelegate
    extends Ui.BehaviorDelegate {

    private var _view;

    function initialize(view) {
        BehaviorDelegate.initialize();

        _view =
            view;
    }

    function onBack() {
        Ui.popView(
            Ui.SLIDE_RIGHT
        );

        return true;
    }

    function onSelect() {
        _view.toggleResultMode();

        return true;
    }
}