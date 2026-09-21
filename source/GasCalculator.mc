import Toybox.Lang;
import Toybox.Math;

module GasCalculator {

    enum Mode {
        MODE_TOP,
        MODE_EMPTY
    }

    // ---------------------------------------------------------------------
    // Numeric helpers
    // ---------------------------------------------------------------------
    // Garmin UI / settings values are very often Lang.Number rather than
    // Lang.Float.  The web version implicitly converts everything through
    // Number(...).  Do the equivalent explicitly here and keep all blend
    // arithmetic in floating point.
    function asFloat(x as Numeric) as Float {
        return x.toFloat();
    }

    function clampPct(x as Numeric) as Float {
        var val = asFloat(x);

        if (val < 0.0) {
            return 0.0;
        }
        if (val > 100.0) {
            return 100.0;
        }
        return val;
    }

    function frac(p as Numeric) as Float {
        // 100.0 is intentional: force floating-point division.
        return clampPct(p) / 100.0;
    }

    function cleanBar(x as Numeric) as Float {
        var value = asFloat(x);
        return (value.abs() < 0.05) ? 0.0 : value;
    }

    function fmtBar(x as Numeric) as String {
        return cleanBar(x).format("%.1f");
    }

    function roundToNumber(x as Numeric) as Number {
        // Do NOT use x.toNumber() here. Float.toNumber() truncates toward 0.
        return Math.round(x).toNumber();
    }

    // ---------------------------------------------------------------------
    // Gas additions calculation
    // ---------------------------------------------------------------------
    function calcAdditions(
        PsIn as Numeric,
        sO2In as Numeric,
        sHeIn as Numeric,
        PfIn as Numeric,
        tO2In as Numeric,
        tHeIn as Numeric,
        FtopIn as Numeric
    ) as Dictionary {

        var Ps = asFloat(PsIn);
        var sO2 = asFloat(sO2In);
        var sHe = asFloat(sHeIn);
        var Pf = asFloat(PfIn);
        var tO2 = asFloat(tO2In);
        var tHe = asFloat(tHeIn);
        var Ftop = asFloat(FtopIn);

        var addHe = (Pf * tHe) - (Ps * sHe);
        var denom = 1.0 - Ftop;
        var num = (Pf * (tO2 - Ftop * (1.0 - tHe)))
                - (Ps * (sO2 - Ftop + Ftop * sHe));
        var addO2 = num / denom;
        var addTop = Pf - Ps - addHe - addO2;

        return {
            "addHe" => addHe,
            "addO2" => addO2,
            "addTop" => addTop
        };
    }

    // ---------------------------------------------------------------------
    // Drain pressure solver
    // ---------------------------------------------------------------------
    function findDrain(
        PsIn as Numeric,
        sO2In as Numeric,
        sHeIn as Numeric,
        PfIn as Numeric,
        tO2In as Numeric,
        tHeIn as Numeric,
        FtopIn as Numeric
    ) as Float or Null {

        var Ps = asFloat(PsIn);
        var sO2 = asFloat(sO2In);
        var sHe = asFloat(sHeIn);
        var Pf = asFloat(PfIn);
        var tO2 = asFloat(tO2In);
        var tHe = asFloat(tHeIn);
        var Ftop = asFloat(FtopIn);

        var denom = 1.0 - Ftop;
        var A = Pf * (tO2 - Ftop * (1.0 - tHe));
        var B = sO2 - Ftop + Ftop * sHe;

        var lo = 0.0;
        var hi = Ps;

        // He constraint
        if (sHe > 0.000000001) {
            var maxHeBar = (Pf * tHe) / sHe;
            if (maxHeBar < hi) {
                hi = maxHeBar;
            }
        }

        // O2 constraint
        if (B.abs() > 0.000000000001) {
            var bound = A / B;
            if (B > 0.0) {
                if (bound < hi) {
                    hi = bound;
                }
            } else {
                if (bound > lo) {
                    lo = bound;
                }
            }
        } else {
            if ((A / denom) < -0.000000001) {
                return null;
            }
        }

        // Top-up constraint
        var C0 = Pf * (1.0 - tHe) - (A / denom);
        var C1 = -(1.0 - sHe) + (B / denom);

        if (C1.abs() > 0.000000000001) {
            var bound2 = -C0 / C1;
            if (C1 > 0.0) {
                if (bound2 > lo) {
                    lo = bound2;
                }
            } else {
                if (bound2 < hi) {
                    hi = bound2;
                }
            }
        } else {
            if (C0 < -0.000000001) {
                return null;
            }
        }

        if (lo < 0.0) {
            lo = 0.0;
        }
        if (hi > Ps) {
            hi = Ps;
        }

        if (hi < lo - 0.000001) {
            return null;
        }

        return hi;
    }

    // ---------------------------------------------------------------------
    // Main gas blend engine
    //
    // IMPORTANT:
    // Parameters are Numeric, not Float.  This allows callers to pass either
    // Garmin Number values (integers) or Float values without losing data or
    // relying on implicit conversion.
    // ---------------------------------------------------------------------
    function blend(
        mode as Mode,
        topO2 as Numeric,
        startBar as Numeric,
        finalBar as Numeric,
        startO2 as Numeric,
        startHe as Numeric,
        targetO2 as Numeric,
        targetHe as Numeric
    ) as Dictionary {

        var Ftop = frac(topO2);

        if (Ftop >= 1.0 - 0.000000001) {
            return {
                "error" => "Top-up gas O2 must be less than 100."
            };
        }

        var Ps = 0.0;
        var Pf = asFloat(finalBar);
        var sO2 = 0.0;
        var sHe = 0.0;
        var tO2 = frac(targetO2);
        var tHe = frac(targetHe);

        if (mode == MODE_TOP) {
            Ps = asFloat(startBar);
            sO2 = frac(startO2);
            sHe = frac(startHe);
        }

        // Validation mirrors the working web implementation.
        if (Pf <= 0.0) {
            return { "error" => "Check final pressure." };
        }

        if (Ps < 0.0) {
            return { "error" => "Check start pressure." };
        }

        if (mode == MODE_TOP && Ps > Pf) {
            return {
                "error" => "Start pressure cannot be higher than final pressure."
            };
        }

        if ((sO2 + sHe) > 1.0 + 0.000000001) {
            return {
                "error" => "Start mix: O2 + He must be <= 100."
            };
        }

        if ((tO2 + tHe) > 1.0 + 0.000000001) {
            return {
                "error" => "Target mix: O2 + He must be <= 100."
            };
        }

        var Pd = Ps;
        var add = calcAdditions(Pd, sO2, sHe, Pf, tO2, tHe, Ftop);

        var addHe = (add["addHe"] as Numeric).toFloat();
        var addO2 = (add["addO2"] as Numeric).toFloat();
        var addTop = (add["addTop"] as Numeric).toFloat();

        // If direct blending requires a negative addition, calculate the
        // required drain pressure first, just like the web version.
        if (mode == MODE_TOP &&
            (addHe < -0.000001 ||
             addO2 < -0.000001 ||
             addTop < -0.000001)) {

            var found = findDrain(Ps, sO2, sHe, Pf, tO2, tHe, Ftop);

            if (found == null) {
                return {
                    "error" => "Target not achievable with selected top-up gas. Try a different top-up gas or adjust target."
                };
            }

            Pd = found as Float;

            if (Pd < 0.0) {
                Pd = 0.0;
            }
            if (Pd > Ps) {
                Pd = Ps;
            }

            add = calcAdditions(Pd, sO2, sHe, Pf, tO2, tHe, Ftop);
            addHe = (add["addHe"] as Numeric).toFloat();
            addO2 = (add["addO2"] as Numeric).toFloat();
            addTop = (add["addTop"] as Numeric).toFloat();
        }

        if (addHe < -0.00001 ||
            addO2 < -0.00001 ||
            addTop < -0.00001) {

            return {
                "error" => "Target not achievable with selected top-up gas at this starting pressure."
            };
        }

        // Remove tiny floating-point negative/positive noise around zero.
        addHe = cleanBar(addHe);
        addO2 = cleanBar(addO2);
        addTop = cleanBar(addTop);

        var didDrain = (mode == MODE_TOP && Pd < Ps - 0.05);

        // JS uses Math.round(), not truncation.
        var finalO2Val = roundToNumber(tO2 * 100.0);
        var finalHeVal = roundToNumber(tHe * 100.0);
        var startHeVal = (mode == MODE_TOP) ? clampPct(startHe) : 0.0;
        var usingHe = (finalHeVal > 0 || roundToNumber(startHeVal) > 0);

        // Keep the original display keys as Strings so existing Garmin UI
        // code can continue to render them directly.  Also expose numeric
        // values with *Value keys for calculations/debugging.
        return {
            "error" => null,
            "didDrain" => didDrain,

            "drainBar" => fmtBar(Pd),
            "addHe" => fmtBar(addHe),
            "addO2" => fmtBar(addO2),
            "addTop" => fmtBar(addTop),

            "drainBarValue" => Pd,
            "addHeValue" => addHe,
            "addO2Value" => addO2,
            "addTopValue" => addTop,

            "usingHe" => usingHe,
            "finalO2" => finalO2Val,
            "finalHe" => finalHeVal
        };
    }

    // ---------------------------------------------------------------------
    // Plan metrics calculation
    // ---------------------------------------------------------------------
    function plan(
        mixPct as Numeric,
        depthMeters as Numeric,
        ppO2 as Numeric
    ) as Dictionary or Null {

        var fo2 = frac(mixPct);
        var depth = asFloat(depthMeters);
        var ppo2Value = asFloat(ppO2);

        if (fo2 <= 0.0 || ppo2Value <= 0.0 || depth < 0.0) {
            return null;
        }

        var amb = 1.0 + (depth / 10.0);
        var mod = 10.0 * ((ppo2Value / fo2) - 1.0);
        var best = (ppo2Value / amb) * 100.0;
        var ead = ((depth + 10.0) * ((1.0 - fo2) / 0.79)) - 10.0;

        var modClamped = (mod < 0.0) ? 0.0 : mod;
        var eadClamped = (ead < 0.0) ? 0.0 : ead;

        return {
            "mod" => modClamped.format("%.1f"),
            "best" => roundToNumber(best),
            "ead" => eadClamped.format("%.1f"),

            // Optional numeric values for Garmin-side calculations/debugging.
            "modValue" => modClamped,
            "bestValue" => best,
            "eadValue" => eadClamped
        };
    }
}
