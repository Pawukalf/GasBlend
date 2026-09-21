using Toybox.WatchUi as Ui;

class GasBlendDelegate extends Ui.BehaviorDelegate {

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

        if (_view.getSelectedMode() == 0) {

            var startingView =
                new StartingGasView();

            Ui.pushView(
                startingView,
                new StartingGasDelegate(
                    startingView
                ),
                Ui.SLIDE_LEFT
            );

        } else {

            var emptyView =
                new EmptyGasView();

            Ui.pushView(
                emptyView,
                new EmptyGasDelegate(
                    emptyView
                ),
                Ui.SLIDE_LEFT
            );
        }

        return true;
    }

    function onBack() {
        return false;
    }
}