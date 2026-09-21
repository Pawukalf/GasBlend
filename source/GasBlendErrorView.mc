using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class GasBlendErrorView extends Ui.View {

    private var _message;

    private var _white = 0xFFFFFF;
    private var _black = 0x000000;
    private var _cyan = 0x00D9E8;
    private var _red = 0xFF4040;

    function initialize(message) {

        View.initialize();

        _message = message;
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function onUpdate(dc) {

        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;

        dc.setColor(
            _black,
            _black
        );

        dc.clear();

        drawTitle(
            dc,
            cx,
            h
        );

        drawMessage(
            dc,
            cx,
            w,
            h
        );

        drawBack(
            dc,
            cx,
            h
        );
    }


    // =======================================================
    // TITLE
    // =======================================================

    function drawTitle(
        dc,
        cx,
        h
    ) {

        var font =
            Gfx.FONT_MEDIUM;

        var titleY =
            h * 190 / 1000;

        dc.setColor(
            _red,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            titleY,
            font,
            "CHECK INPUT",
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }


    // =======================================================
    // ERROR MESSAGE
    // =======================================================

    function drawMessage(
        dc,
        cx,
        w,
        h
    ) {

        var font =
            Gfx.FONT_XTINY;

        /*
         * Compact message area kept safely inside
         * the round display.
         */
        var messageWidth =
            w * 68 / 100;

        var messageHeight =
            h * 320 / 1000;

        var messageCenterY =
            h * 500 / 1000;

        /*
         * Automatically adds line breaks and truncates
         * only if the full message cannot fit.
         */
        var fittedMessage =
            Gfx.fitTextToArea(
                _message,
                font,
                messageWidth,
                messageHeight,
                false
            );

        if (fittedMessage == null) {

            fittedMessage =
                _message;
        }

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            messageCenterY,
            font,
            fittedMessage,
            Gfx.TEXT_JUSTIFY_CENTER |
            Gfx.TEXT_JUSTIFY_VCENTER
        );
    }


    // =======================================================
    // BACK
    // =======================================================

    function drawBack(
        dc,
        cx,
        h
    ) {

        var font =
            Gfx.FONT_SMALL;

        var fontHeight =
            dc.getFontHeight(font);

        var centerY =
            h * 820 / 1000;

        dc.setColor(
            _cyan,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            centerY - fontHeight / 2,
            font,
            "BACK",
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }
}