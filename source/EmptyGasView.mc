using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.System;
using Toybox.WatchUi as Ui;

class EmptyGasView extends Ui.View {

    // 0 = O2
    // 1 = He
    // 2 = Final bar
    // 3 = Top-up O2
    // 4 = CALC
    private var _selectedRow = 0;

    private var _isEditing = false;
    private var _originalValue = 0;

    private var _selectBackground;
    private var _editBackground;

    private var _white = 0xFFFFFF;
    private var _black = 0x000000;
    private var _cyan = 0x00D9E8;
    private var _editGrey = 0x303030;
    private var _green = 0x00FF7F;

    function initialize() {

        View.initialize();

        _selectBackground = Ui.loadResource(
            Rez.Drawables.InputSelect
        );

        _editBackground = Ui.loadResource(
            Rez.Drawables.InputEdit
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
        var cx = w / 2;

        dc.setColor(
            _black,
            _black
        );

        dc.clear();

        if (_isEditing) {

            dc.drawBitmap(
                0,
                0,
                _editBackground
            );

        } else {

            dc.drawBitmap(
                0,
                0,
                _selectBackground
            );
        }

        drawHeader(
            dc,
            cx,
            w,
            h
        );

        drawValueRow(
            dc,
            cx,
            w,
            h * 335 / 1000,
            "O2",
            GasBlendData.targetO2.format("%d") + "%",
            _selectedRow == 0,
            _isEditing && _selectedRow == 0
        );

        drawValueRow(
            dc,
            cx,
            w,
            h * 445 / 1000,
            "He",
            GasBlendData.targetHe.format("%d") + "%",
            _selectedRow == 1,
            _isEditing && _selectedRow == 1
        );

        drawValueRow(
            dc,
            cx,
            w,
            h * 555 / 1000,
            "Final pressure",
            GasBlendData.finalPressure.format("%d") + " bar",
            _selectedRow == 2,
            _isEditing && _selectedRow == 2
        );

        drawValueRow(
            dc,
            cx,
            w,
            h * 665 / 1000,
            " O2",
            GasBlendData.topupO2.format("%d") + "%",
            _selectedRow == 3,
            _isEditing && _selectedRow == 3
        );

        drawCalcButton(
            dc,
            cx,
            w,
            h * 790 / 1000,
            _selectedRow == 4
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
            h * 70 / 1000;

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            titleY,
            titleFont,
            "EMPTY",
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

        var subtitleY =
            dividerY +
            5;

        dc.setColor(
            _white,
            Gfx.COLOR_TRANSPARENT
        );

        dc.drawText(
            cx,
            subtitleY,
            subtitleFont,
            "TARGET GAS",
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }


    // =======================================================
    // VALUE ROW
    // =======================================================

    function drawValueRow(
        dc,
        cx,
        w,
        centerY,
        label,
        value,
        selected,
        editing
    ) {

        var rowWidth =
            w * 78 / 100;

        var rowHeight =
            w * 88 / 1000;

        var rowX =
            cx -
            rowWidth / 2;

        var rowY =
            centerY -
            rowHeight / 2;

        var radius =
            rowHeight / 2;

        if (editing) {

            drawEditingRow(
                dc,
                rowX,
                rowY,
                rowWidth,
                rowHeight,
                radius
            );

        } else if (selected) {

            drawSelectedRow(
                dc,
                rowX,
                rowY,
                rowWidth,
                rowHeight,
                radius
            );

        } else {

            drawNormalRow(
                dc,
                rowX,
                rowY,
                rowWidth,
                rowHeight,
                radius
            );
        }

        drawRowText(
            dc,
            rowX,
            rowWidth,
            centerY,
            label,
            value,
            selected,
            editing
        );
    }


    // =======================================================
    // NORMAL ROW
    // =======================================================

    function drawNormalRow(
        dc,
        rowX,
        rowY,
        rowWidth,
        rowHeight,
        radius
    ) {

        dc.setColor(
            _white,
            _white
        );

        dc.fillRoundedRectangle(
            rowX,
            rowY,
            rowWidth,
            rowHeight,
            radius
        );

        var border = 2;

        dc.setColor(
            _black,
            _black
        );

        dc.fillRoundedRectangle(
            rowX + border,
            rowY + border,
            rowWidth - border * 2,
            rowHeight - border * 2,
            radius - border
        );
    }


    // =======================================================
    // SELECTED ROW
    // =======================================================

    function drawSelectedRow(
        dc,
        rowX,
        rowY,
        rowWidth,
        rowHeight,
        radius
    ) {

        dc.setColor(
            _white,
            _white
        );

        dc.fillRoundedRectangle(
            rowX,
            rowY,
            rowWidth,
            rowHeight,
            radius
        );
    }


    // =======================================================
    // EDITING ROW
    // =======================================================

    function drawEditingRow(
        dc,
        rowX,
        rowY,
        rowWidth,
        rowHeight,
        radius
    ) {

        dc.setColor(
            _cyan,
            _cyan
        );

        dc.fillRoundedRectangle(
            rowX,
            rowY,
            rowWidth,
            rowHeight,
            radius
        );

        var border = 3;

        dc.setColor(
            _editGrey,
            _editGrey
        );

        dc.fillRoundedRectangle(
            rowX + border,
            rowY + border,
            rowWidth - border * 2,
            rowHeight - border * 2,
            radius - border
        );
    }


    // =======================================================
    // ROW TEXT
    // =======================================================

    function drawRowText(
        dc,
        rowX,
        rowWidth,
        centerY,
        label,
        value,
        selected,
        editing
    ) {

        var font =
            Gfx.FONT_XTINY;

        var fontHeight =
            dc.getFontHeight(font);

        var textY =
            centerY -
            fontHeight / 2;

        var labelX =
            rowX +
            rowWidth * 9 / 100;

        var valueX =
            rowX +
            rowWidth * 91 / 100;

        if (selected && !editing) {

            dc.setColor(
                _black,
                Gfx.COLOR_TRANSPARENT
            );

        } else {

            dc.setColor(
                _white,
                Gfx.COLOR_TRANSPARENT
            );
        }

        dc.drawText(
            labelX,
            textY,
            font,
            label,
            Gfx.TEXT_JUSTIFY_LEFT
        );

        if (editing) {

            dc.setColor(
                _green,
                Gfx.COLOR_TRANSPARENT
            );

        } else if (selected) {

            dc.setColor(
                _black,
                Gfx.COLOR_TRANSPARENT
            );

        } else {

            dc.setColor(
                _white,
                Gfx.COLOR_TRANSPARENT
            );
        }

        dc.drawText(
            valueX,
            textY,
            font,
            value,
            Gfx.TEXT_JUSTIFY_RIGHT
        );
    }


    // =======================================================
    // CALC BUTTON
    // =======================================================

    function drawCalcButton(
        dc,
        cx,
        w,
        centerY,
        selected
    ) {

        var buttonWidth =
            w * 50 / 100;

        var buttonHeight =
            w * 100 / 1000;

        var buttonX =
            cx -
            buttonWidth / 2;

        var buttonY =
            centerY -
            buttonHeight / 2;

        var radius =
            buttonHeight / 2;

        if (selected) {

            dc.setColor(
                _cyan,
                _cyan
            );

            dc.fillRoundedRectangle(
                buttonX,
                buttonY,
                buttonWidth,
                buttonHeight,
                radius
            );

            dc.setColor(
                _black,
                Gfx.COLOR_TRANSPARENT
            );

        } else {

            dc.setColor(
                _cyan,
                _cyan
            );

            dc.fillRoundedRectangle(
                buttonX,
                buttonY,
                buttonWidth,
                buttonHeight,
                radius
            );

            var border = 3;

            dc.setColor(
                _black,
                _black
            );

            dc.fillRoundedRectangle(
                buttonX + border,
                buttonY + border,
                buttonWidth - border * 2,
                buttonHeight - border * 2,
                radius - border
            );

            dc.setColor(
                _cyan,
                Gfx.COLOR_TRANSPARENT
            );
        }

        var font =
            Gfx.FONT_SMALL;

        var fontHeight =
            dc.getFontHeight(font);

        dc.drawText(
            cx,
            centerY - fontHeight / 2,
            font,
            "CALC",
            Gfx.TEXT_JUSTIFY_CENTER
        );
    }


    // =======================================================
    // NAVIGATION
    // =======================================================

    function moveUp() {

        if (_isEditing) {
            increaseValue();
            return;
        }

        _selectedRow--;

        if (_selectedRow < 0) {
            _selectedRow = 4;
        }

        Ui.requestUpdate();
    }

    function moveDown() {

        if (_isEditing) {
            decreaseValue();
            return;
        }

        _selectedRow++;

        if (_selectedRow > 4) {
            _selectedRow = 0;
        }

        Ui.requestUpdate();
    }

    function select() {

        if (_isEditing) {
            acceptEdit();
            return;
        }

        if (_selectedRow == 4) {
            calculateBlend();
            return;
        }

        beginEdit();
    }


    // =======================================================
    // EDITING
    // =======================================================

    function beginEdit() {

        if (_selectedRow == 0) {

            _originalValue =
                GasBlendData.targetO2;

        } else if (_selectedRow == 1) {

            _originalValue =
                GasBlendData.targetHe;

        } else if (_selectedRow == 2) {

            _originalValue =
                GasBlendData.finalPressure;

        } else if (_selectedRow == 3) {

            _originalValue =
                GasBlendData.topupO2;
        }

        _isEditing = true;

        Ui.requestUpdate();
    }

    function acceptEdit() {

        _isEditing = false;

        Ui.requestUpdate();
    }

    function cancelEdit() {

        if (_selectedRow == 0) {

            GasBlendData.targetO2 =
                _originalValue;

        } else if (_selectedRow == 1) {

            GasBlendData.targetHe =
                _originalValue;

        } else if (_selectedRow == 2) {

            GasBlendData.finalPressure =
                _originalValue;

        } else if (_selectedRow == 3) {

            GasBlendData.topupO2 =
                _originalValue;
        }

        _isEditing = false;

        Ui.requestUpdate();
    }


    // =======================================================
    // VALUE CHANGES
    // =======================================================

    function increaseValue() {

        if (_selectedRow == 0) {

            GasBlendData.targetO2++;

            if (
                GasBlendData.targetO2 +
                GasBlendData.targetHe >
                100
            ) {

                GasBlendData.targetO2 =
                    100 -
                    GasBlendData.targetHe;
            }

        } else if (_selectedRow == 1) {

            GasBlendData.targetHe++;

            if (
                GasBlendData.targetO2 +
                GasBlendData.targetHe >
                100
            ) {

                GasBlendData.targetHe =
                    100 -
                    GasBlendData.targetO2;
            }

        } else if (_selectedRow == 2) {

            GasBlendData.finalPressure += 10;

            if (
                GasBlendData.finalPressure >
                400
            ) {

                GasBlendData.finalPressure =
                    400;
            }

        } else if (_selectedRow == 3) {

            GasBlendData.topupO2++;

            if (
                GasBlendData.topupO2 >
                99
            ) {

                GasBlendData.topupO2 =
                    99;
            }
        }

        Ui.requestUpdate();
    }

    function decreaseValue() {

        if (_selectedRow == 0) {

            GasBlendData.targetO2--;

            if (
                GasBlendData.targetO2 <
                0
            ) {

                GasBlendData.targetO2 =
                    0;
            }

        } else if (_selectedRow == 1) {

            GasBlendData.targetHe--;

            if (
                GasBlendData.targetHe <
                0
            ) {

                GasBlendData.targetHe =
                    0;
            }

        } else if (_selectedRow == 2) {

            GasBlendData.finalPressure -= 10;

            if (
                GasBlendData.finalPressure <
                10
            ) {

                GasBlendData.finalPressure =
                    10;
            }

        } else if (_selectedRow == 3) {

            GasBlendData.topupO2--;

            if (
                GasBlendData.topupO2 <
                0
            ) {

                GasBlendData.topupO2 =
                    0;
            }
        }

        Ui.requestUpdate();
    }


    // =======================================================
    // CALCULATE EMPTY CYLINDER
    // =======================================================

    function calculateBlend() {

        GasBlendData.clearResult();

        if (
            GasBlendData.finalPressure <=
            0
        ) {

            openCalculationError(
                "Check final pressure."
            );

            return;
        }

        if (
            GasBlendData.targetO2 <
            0 ||
            GasBlendData.targetO2 >
            100
        ) {

            openCalculationError(
                "Check target O2."
            );

            return;
        }

        if (
            GasBlendData.targetHe <
            0 ||
            GasBlendData.targetHe >
            100
        ) {

            openCalculationError(
                "Check target He."
            );

            return;
        }

        if (
            GasBlendData.targetO2 +
            GasBlendData.targetHe >
            100
        ) {

            openCalculationError(
                "Target O2 + He exceeds 100%."
            );

            return;
        }

        if (
            GasBlendData.topupO2 <
            0 ||
            GasBlendData.topupO2 >=
            100
        ) {

            openCalculationError(
                "Top-up O2 must be below 100%."
            );

            return;
        }

        var result =
            GasCalculator.blend(
                GasCalculator.MODE_EMPTY,
                GasBlendData.topupO2,
                0,
                GasBlendData.finalPressure,
                0,
                0,
                GasBlendData.targetO2,
                GasBlendData.targetHe
            );

        var error =
            result["error"];

        if (error != null) {

            GasBlendData.errorMessage =
                error.toString();

            openCalculationError(
                GasBlendData.errorMessage
            );

            return;
        }

        var heliumValue =
            result["addHeValue"];

        var oxygenValue =
            result["addO2Value"];

        var topupValue =
            result["addTopValue"];

        if (
            heliumValue == null ||
            oxygenValue == null ||
            topupValue == null
        ) {

            GasBlendData.errorMessage =
                "Calculation returned incomplete results.";

            openCalculationError(
                GasBlendData.errorMessage
            );

            return;
        }

        GasBlendData.drainTo =
            0.0;

        GasBlendData.addO2 =
            (oxygenValue as Lang.Numeric).toFloat();

        GasBlendData.addHe =
            (heliumValue as Lang.Numeric).toFloat();

        GasBlendData.addTopup =
            (topupValue as Lang.Numeric).toFloat();

        GasBlendData.requiresDrain =
            false;

        GasBlendData.calculationValid =
            true;

        GasBlendData.errorMessage =
            "";

        System.println("===== EMPTY BLEND RESULT =====");

        System.println(
            "Add O2: " +
            GasBlendData.addO2.format("%.1f")
        );

        System.println(
            "Add He: " +
            GasBlendData.addHe.format("%.1f")
        );

        System.println(
            "Add top-up: " +
            GasBlendData.addTopup.format("%.1f")
        );

        var resultsView =
            new GasBlendCalculationResults();

        Ui.pushView(
            resultsView,
            new GasBlendCalculationResultsDelegate(),
            Ui.SLIDE_LEFT
        );
    }


    // =======================================================
    // CALCULATION ERROR
    // =======================================================

    function openCalculationError(message) {

        var errorView =
            new GasBlendErrorView(
                message
            );

        Ui.pushView(
            errorView,
            new GasBlendErrorDelegate(),
            Ui.SLIDE_LEFT
        );
    }


    // =======================================================
    // BACK
    // =======================================================

    function handleBack() {

        if (_isEditing) {

            cancelEdit();

            return true;
        }

        return false;
    }
}