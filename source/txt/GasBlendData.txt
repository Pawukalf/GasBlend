class GasBlendData {

    // Starting gas
    static var startO2 = 21;
    static var startHe = 0;
    static var startPressure = 100;

    // Target gas
    static var targetO2 = 18;
    static var targetHe = 45;
    static var finalPressure = 230;
    static var topupO2 = 21;

    // Calculated results
    static var drainTo = 0.0;
    static var addO2 = 0.0;
    static var addHe = 0.0;
    static var addTopup = 0.0;

    // Calculation state
    static var calculationValid = false;
    static var requiresDrain = false;
    static var errorMessage = "";

    static function clearResult() {

        drainTo = 0.0;
        addO2 = 0.0;
        addHe = 0.0;
        addTopup = 0.0;

        calculationValid = false;
        requiresDrain = false;
        errorMessage = "";
    }
}