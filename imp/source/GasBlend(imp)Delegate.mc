import Toybox.Lang;
import Toybox.WatchUi;

class GasBlend_imp_Delegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new GasBlend_imp_MenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}