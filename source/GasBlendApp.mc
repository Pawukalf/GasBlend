using Toybox.Application as App;

class GasBlendApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        var view = new GasBlendView();

        return [
            view,
            new GasBlendDelegate(view)
        ];
    }
}