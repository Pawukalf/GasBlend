using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class StartingGasView extends Ui.View {

    // 0 = O2
    // 1 = He
    // 2 = Start pressure
    // 3 = NEXT
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
            h * 365 / 1000,
            "O2",
            GasBlendData.startO2.format("%d") + "%",
            _selectedRow == 0,
            _isEditing && _selectedRow == 0
        );

        drawValueRow(
            dc,
            cx,
            w,
            h * 500 / 1000,
            "He",
            GasBlendData.startHe.format("%d") + "%",
            _selectedRow == 1,
            _isEditing && _selectedRow == 1
        );

        drawValueRow(
            dc,
            cx,
            w,
            h * 635 / 1000,
            "Start pressure",
            GasBlendData.startPressure.format("%d") + " bar",
            _selectedRow == 2,
            _isEditing && _selectedRow == 2
        );

        drawNextButton(
            dc,
            cx,
            w,
            h * 790 / 1000,
            _selectedRow == 3
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
            "STARTING GAS",
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
    // NEXT BUTTON
    // =======================================================

    function drawNextButton(
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
            "NEXT",
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
            _selectedRow = 3;
        }

        Ui.requestUpdate();
    }

    function moveDown() {

        if (_isEditing) {
            decreaseValue();
            return;
        }

        _selectedRow++;

        if (_selectedRow > 3) {
            _selectedRow = 0;
        }

        Ui.requestUpdate();
    }

    function select() {

        if (_isEditing) {
            acceptEdit();
            return;
        }

        if (_selectedRow == 3) {
            openTargetGas();
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
                GasBlendData.startO2;

        } else if (_selectedRow == 1) {

            _originalValue =
                GasBlendData.startHe;

        } else if (_selectedRow == 2) {

            _originalValue =
                GasBlendData.startPressure;
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

            GasBlendData.startO2 =
                _originalValue;

        } else if (_selectedRow == 1) {

            GasBlendData.startHe =
                _originalValue;

        } else if (_selectedRow == 2) {

            GasBlendData.startPressure =
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

            GasBlendData.startO2++;

            if (
                GasBlendData.startO2 +
                GasBlendData.startHe >
                100
            ) {

                GasBlendData.startO2 =
                    100 -
                    GasBlendData.startHe;
            }

        } else if (_selectedRow == 1) {

            GasBlendData.startHe++;

            if (
                GasBlendData.startO2 +
                GasBlendData.startHe >
                100
            ) {

                GasBlendData.startHe =
                    100 -
                    GasBlendData.startO2;
            }

        } else if (_selectedRow == 2) {

            GasBlendData.startPressure += 10;

            if (
                GasBlendData.startPressure >
                400
            ) {

                GasBlendData.startPressure =
                    400;
            }
        }

        Ui.requestUpdate();
    }

    function decreaseValue() {

        if (_selectedRow == 0) {

            GasBlendData.startO2--;

            if (
                GasBlendData.startO2 <
                0
            ) {

                GasBlendData.startO2 =
                    0;
            }

        } else if (_selectedRow == 1) {

            GasBlendData.startHe--;

            if (
                GasBlendData.startHe <
                0
            ) {

                GasBlendData.startHe =
                    0;
            }

        } else if (_selectedRow == 2) {

            GasBlendData.startPressure -= 10;

            if (
                GasBlendData.startPressure <
                0
            ) {

                GasBlendData.startPressure =
                    0;
            }
        }

        Ui.requestUpdate();
    }


    // =======================================================
    // BACK AND NEXT
    // =======================================================

    function handleBack() {

        if (_isEditing) {

            cancelEdit();

            return true;
        }

        return false;
    }

    function openTargetGas() {

        var targetView =
            new TargetGasView();

        Ui.pushView(
            targetView,
            new TargetGasDelegate(
                targetView
            ),
            Ui.SLIDE_LEFT
        );
    }

    function isEditing() {
        return _isEditing;
    }

    function getSelectedRow() {
        return _selectedRow;
    }
}