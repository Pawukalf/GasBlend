using Toybox.WatchUi as Ui;

class EmptyGasDelegate extends Ui.BehaviorDelegate {

    private var _view;

    function initialize(view) {

        BehaviorDelegate.initialize();

        _view = view;
    }

    function onPreviousPage() {

        _view.moveUp();

        return true;
    }

    function onNextPage() {

        _view.moveDown();

        return true;
    }

    function onSelect() {

        _view.select();

        return true;
    }

    function onBack() {

        if (_view.handleBack()) {
            return true;
        }

        Ui.popView(
            Ui.SLIDE_RIGHT
        );

        return true;
    }
}