using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class GasBlendCalculationResults extends Ui.View {

    private var _white = 0xFFFFFF;
    private var _black = 0x000000;
    private var _cyan = 0x00D9E8;
    private var _green = 0x00FF7F;
    private var _grey = 0xA0A0A0;

    function initialize() {
        View.initialize();
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

        drawHeader(
            dc,
            cx,
            w,
            h
        );

        /*
         * When draining is required, four result rows
         * are displayed:
         *
         * Drain to
         * Add O2
         * Add He
         * Add top-up
         *
         * When draining is not required, only the three
         * addition rows are displayed.
         */
        var firstRowY;

        if (GasBlendData.requiresDrain) {

            firstRowY =
                h * 365 / 1000;

            drawResultRow(
                dc,
                cx,
                w,
                firstRowY,
                "Drain to",
                GasBlendData.drainTo.format("%.1f") + " bar"
            );

        } else {

            firstRowY =
                h * 400 / 1000;
        }

        var rowSpacing =
            h * 82 / 1000;

        drawResultRow(
            dc,
            cx,
            w,
            firstRowY + rowSpacing,
            "Add O2",
            GasBlendData.addO2.format("%.1f") + " bar"
        );

        drawResultRow(
            dc,
            cx,
            w,
            firstRowY + rowSpacing * 2,
            "Add He",
            GasBlendData.addHe.format("%.1f") + " bar"
        );

        drawResultRow(
            dc,
            cx,
            w,
            firstRowY + rowSpacing * 3,
            "Add top-up",
            GasBlendData.addTopup.format("%.1f") + " bar"
        );

        var dividerY =
            firstRowY +
            rowSpacing * 4 -
            h * 18 / 1000;

        drawFinalMix(
            dc,
            cx,
            w,
            h,
            dividerY
        );
    }


    // =======================================================
    // HEADER
    // =======================================================

    function drawHeader(
        dc,
        cx,
        w,
        h
    ) {

        var titleFont =
            Gfx.FONT_LARGE;

        var subtitleFont =
            Gfx.FONT_XTINY;

        var titleY =
            h * 75 / 1000;

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            titleY,
            titleFont,
            "TOP-UP",
            Gfx.TEXT_JUSTIFY_CENTER
        );

        var titleHeight =
            dc.getFontHeight(titleFont);

        var dividerY =
            titleY +
            titleHeight -
            1;

        var dividerWidth =
            w * 40 / 100;

        dc.setColor(
            _cyan,
            _cyan
        );

        dc.setPenWidth(3);

        dc.drawLine(
            cx - dividerWidth / 2,
            dividerY,
            cx + dividerWidth / 2,
            dividerY
        );

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            dividerY + 6,
            subtitleFont,
            "BLEND RESULTS",
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }


    // =======================================================
    // RESULT ROW
    // =======================================================

    function drawResultRow(
        dc,
        cx,
        w,
        centerY,
        label,
        value
    ) {

        var rowWidth =
            w * 70 / 100;

        var rowX =
            cx -
            rowWidth / 2;

        var labelX =
            rowX;

        var valueX =
            rowX +
            rowWidth;

        var font =
            Gfx.FONT_XTINY;

        var fontHeight =
            dc.getFontHeight(font);

        var textY =
            centerY -
            fontHeight / 2;

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            labelX,
            textY,
            font,
            label,
            Gfx.TEXT_JUSTIFY_LEFT
        );

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            valueX,
            textY,
            font,
            value,
            Gfx.TEXT_JUSTIFY_RIGHT
        );
    }


    // =======================================================
    // FINAL MIX
    // =======================================================

    function drawFinalMix(
        dc,
        cx,
        w,
        h,
        dividerY
    ) {

        var dividerWidth =
            w * 70 / 100;

        dc.setColor(
            _grey,
            _grey
        );

        dc.setPenWidth(2);

        dc.drawLine(
            cx - dividerWidth / 2,
            dividerY,
            cx + dividerWidth / 2,
            dividerY
        );

        var labelFont =
            Gfx.FONT_XTINY;

        var mixFont =
            Gfx.FONT_LARGE;

        var labelY =
            dividerY +
            h * 18 / 1000;

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            labelY,
            labelFont,
            "FINAL MIX",
            Gfx.TEXT_JUSTIFY_CENTER
        );

        var mixText;

        /*
         * Standard trimix notation:
         *
         * O2 percentage / helium percentage
         *
         * Example: 18/45
         *
         * For a mix without helium, only the O2
         * percentage is displayed.
         */
        if (GasBlendData.targetHe > 0) {

            mixText =
                GasBlendData.targetO2.format("%d") +
                "/" +
                GasBlendData.targetHe.format("%d");

        } else {

            mixText =
                GasBlendData.targetO2.format("%d");
        }

        var labelHeight =
            dc.getFontHeight(labelFont);

        var mixY =
            labelY +
            labelHeight +
            h * 5 / 1000;

        dc.setColor(
            _green,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            mixY,
            mixFont,
            mixText,
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }
}