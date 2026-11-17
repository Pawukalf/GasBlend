using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class GasBlendCalculationResults extends Ui.View {

    // false = show individual gas additions
    // true  = show cumulative cylinder pressures
    private var _showFillPressures = false;

    // false = TOP-UP calculation
    // true  = EMPTY calculation
    private var _isEmptyBlend = false;

    private var _white = 0xFFFFFF;
    private var _black = 0x000000;
    private var _cyan = 0x00D9E8;
    private var _green = 0x00FF7F;
    private var _grey = 0xA0A0A0;

    function initialize(isEmptyBlend) {
        View.initialize();

        _isEmptyBlend =
            isEmptyBlend;
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

        if (_showFillPressures) {
            drawPressureResults(
                dc,
                cx,
                w,
                firstRowY,
                rowSpacing
            );
        } else {
            drawAdditionResults(
                dc,
                cx,
                w,
                firstRowY,
                rowSpacing
            );
        }

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
    // ADDITION RESULTS
    // =======================================================

    function drawAdditionResults(
        dc,
        cx,
        w,
        firstRowY,
        rowSpacing
    ) {
        drawResultRow(
            dc,
            cx,
            w,
            firstRowY + rowSpacing,
            "Add O2",
            GasBlendData.addO2.format("%.1f") + " bar"
        );

        // Do not display helium when no helium is required.
        if (GasBlendData.addHe > 0.05) {
            drawResultRow(
                dc,
                cx,
                w,
                firstRowY + rowSpacing * 2,
                "Add He",
                GasBlendData.addHe.format("%.1f") + " bar"
            );
        }

        // Keep top-up visible even when no top-up is required.
        drawResultRow(
            dc,
            cx,
            w,
            firstRowY + rowSpacing * 3,
            "Add top-up",
            GasBlendData.addTopup.format("%.1f") + " bar"
        );
    }

    // =======================================================
    // PRESSURE RESULTS
    // =======================================================

    function drawPressureResults(
        dc,
        cx,
        w,
        firstRowY,
        rowSpacing
    ) {
        var basePressure;

        if (_isEmptyBlend) {
            basePressure =
                0.0;
        } else if (GasBlendData.requiresDrain) {
            basePressure =
                GasBlendData.drainTo;
        } else {
            basePressure =
                GasBlendData.startPressure.toFloat();
        }

        var oxygenPressure =
            basePressure +
            GasBlendData.addO2;

        var heliumPressure =
            oxygenPressure +
            GasBlendData.addHe;

        var finalPressure =
            heliumPressure +
            GasBlendData.addTopup;

        // Oxygen pressure
        if (GasBlendData.addO2 > 0.05) {
            drawResultRow(
                dc,
                cx,
                w,
                firstRowY + rowSpacing,
                "O2 to",
                oxygenPressure.format("%.1f") + " bar"
            );
        } else {
            drawResultRow(
                dc,
                cx,
                w,
                firstRowY + rowSpacing,
                "O2 to",
                "-"
            );
        }

        // Helium pressure
        if (GasBlendData.addHe > 0.05) {
            drawResultRow(
                dc,
                cx,
                w,
                firstRowY + rowSpacing * 2,
                "He to",
                heliumPressure.format("%.1f") + " bar"
            );
        } else {
            drawResultRow(
                dc,
                cx,
                w,
                firstRowY + rowSpacing * 2,
                "He to",
                "-"
            );
        }

        // Final top-up pressure
        if (GasBlendData.addTopup > 0.05) {
            drawResultRow(
                dc,
                cx,
                w,
                firstRowY + rowSpacing * 3,
                "Top-up to",
                finalPressure.format("%.1f") + " bar"
            );
        } else {
            drawResultRow(
                dc,
                cx,
                w,
                firstRowY + rowSpacing * 3,
                "Top-up to",
                "-"
            );
        }
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

        var title;

        if (_isEmptyBlend) {
            title =
                "EMPTY";
        } else {
            title =
                "TOP-UP";
        }

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            titleY,
            titleFont,
            title,
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

        var subtitle;

        if (_showFillPressures) {
            subtitle =
                "BLEND RESULTS (PRESSURE)";
        } else {
            subtitle =
                "BLEND RESULTS (ADD)";
        }

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            dividerY + 6,
            subtitleFont,
            subtitle,
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

    // =======================================================
    // RESULT MODE TOGGLE
    // =======================================================

    function toggleResultMode() {
        _showFillPressures =
            !_showFillPressures;

        Ui.requestUpdate();
    }
}