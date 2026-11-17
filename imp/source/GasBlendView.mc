using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class GasBlendView extends Ui.View {

    private var _selectedMode = 0;
    private var _background;

    function initialize() {
        View.initialize();

        _background = Ui.loadResource(
            Rez.Drawables.GTMain
        );
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

        dc.setColor(
            Gfx.COLOR_BLACK,
            Gfx.COLOR_BLACK
        );

        dc.clear();

        // Background image
        dc.drawBitmap(
            0,
            0,
            _background
        );

        // TOP-UP
        drawButton(
            dc,
            w / 2,
            260,
            "TOP-UP",
            _selectedMode == 0
        );

        // EMPTY
        drawButton(
            dc,
            w / 2,
            320,
            "EMPTY",
            _selectedMode == 1
        );
    }

    function drawButton(
        dc,
        centerX,
        centerY,
        label,
        selected
    ) {

        var buttonWidth = 250;
        var buttonHeight = 48;

        var x =
            centerX -
            buttonWidth / 2;

        var y =
            centerY -
            buttonHeight / 2;

        var radius =
            buttonHeight / 2;

        if (selected) {

            dc.setColor(
                Gfx.COLOR_WHITE,
                Gfx.COLOR_WHITE
            );

            dc.fillRoundedRectangle(
                x,
                y,
                buttonWidth,
                buttonHeight,
                radius
            );

            dc.setColor(
                Gfx.COLOR_BLACK,
                Gfx.COLOR_TRANSPARENT
            );

        } else {

            dc.setColor(
                Gfx.COLOR_WHITE,
                Gfx.COLOR_WHITE
            );

            dc.fillRoundedRectangle(
                x,
                y,
                buttonWidth,
                buttonHeight,
                radius
            );

            var border = 2;

            dc.setColor(
                Gfx.COLOR_BLACK,
                Gfx.COLOR_BLACK
            );

            dc.fillRoundedRectangle(
                x + border,
                y + border,
                buttonWidth - border * 2,
                buttonHeight - border * 2,
                radius - border
            );

            dc.setColor(
                Gfx.COLOR_WHITE,
                Gfx.COLOR_TRANSPARENT
            );
        }

        var font = Gfx.FONT_MEDIUM;

        var fontHeight =
            dc.getFontHeight(font);

        var textY =
            centerY -
            fontHeight / 2;

        dc.drawText(
            centerX,
            textY,
            font,
            label,
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }

    function moveUp() {

        if (_selectedMode == 0) {
            _selectedMode = 1;
        } else {
            _selectedMode = 0;
        }

        Ui.requestUpdate();
    }

    function moveDown() {

        moveUp();
    }

    function getSelectedMode() {
        return _selectedMode;
    }
}