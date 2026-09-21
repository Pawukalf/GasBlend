class GasBlendValidator {

    static function validateTopUp() {

        GasBlendData.errorMessage = "";

        if (GasBlendData.startPressure < 0) {

            GasBlendData.errorMessage =
                "Check start pressure.";

            return false;
        }

        if (GasBlendData.finalPressure <= 0) {

            GasBlendData.errorMessage =
                "Check final pressure.";

            return false;
        }

        if (
            GasBlendData.startPressure >
            GasBlendData.finalPressure
        ) {

            GasBlendData.errorMessage =
                "Start bar is above final bar.";

            return false;
        }

        if (
            GasBlendData.startO2 < 0 ||
            GasBlendData.startO2 > 100
        ) {

            GasBlendData.errorMessage =
                "Check starting O2.";

            return false;
        }

        if (
            GasBlendData.startHe < 0 ||
            GasBlendData.startHe > 100
        ) {

            GasBlendData.errorMessage =
                "Check starting He.";

            return false;
        }

        if (
            GasBlendData.startO2 +
            GasBlendData.startHe >
            100
        ) {

            GasBlendData.errorMessage =
                "Starting O2 + He exceeds 100%.";

            return false;
        }

        if (
            GasBlendData.targetO2 < 0 ||
            GasBlendData.targetO2 > 100
        ) {

            GasBlendData.errorMessage =
                "Check target O2.";

            return false;
        }

        if (
            GasBlendData.targetHe < 0 ||
            GasBlendData.targetHe > 100
        ) {

            GasBlendData.errorMessage =
                "Check target He.";

            return false;
        }

        if (
            GasBlendData.targetO2 +
            GasBlendData.targetHe >
            100
        ) {

            GasBlendData.errorMessage =
                "Target O2 + He exceeds 100%.";

            return false;
        }

        if (
            GasBlendData.topupO2 < 0 ||
            GasBlendData.topupO2 >= 100
        ) {

            GasBlendData.errorMessage =
                "Top-up O2 must be below 100%.";

            return false;
        }

        return true;
    }
}