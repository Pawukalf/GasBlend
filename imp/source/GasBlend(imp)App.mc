import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class GasBlend_imp_App extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new GasBlend_imp_View(), new GasBlend_imp_Delegate() ];
    }

}

function getApp() as GasBlend_imp_App {
    return Application.getApp() as GasBlend_imp_App;
}