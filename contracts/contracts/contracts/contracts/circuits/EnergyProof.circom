pragma circom 2.1.0;

/// ----------------------------------------------------------
/// ENERGY REDUCTION PROOF CIRCUIT
/// ----------------------------------------------------------
/// This circuit proves that:
///     (1) User provides BEFORE and AFTER energy usage.
///     (2) The reduction = BEFORE - AFTER is positive.
///     (3) The reduction >= minimumRequired (public).
///
/// NO personal data is revealed — only validity.
/// ----------------------------------------------------------

template EnergyProof() {

    // -------------------------
    // PRIVATE INPUTS
    // -------------------------
    signal input beforeUsage;      // e.g., 500 kWh
    signal input afterUsage;       // e.g., 420 kWh

    // -------------------------
    // PUBLIC INPUTS
    // -------------------------
    signal input minimumRequired;  // e.g., 50 kWh minimum reduction

    // -------------------------
    // PUBLIC OUTPUTS
    // -------------------------
    signal output isValid;

    // -------------------------
    // INTERNAL SIGNALS
    // -------------------------
    signal reduction;

    // reduction = before - after
    reduction <== beforeUsage - afterUsage;

    // enforce: reduction >= 0
    reduction >= 0 === 1;

    // enforce: reduction >= minimumRequired
    (reduction - minimumRequired) >= 0 === 1;

    // set output
    isValid <== 1;
}

component main = EnergyProof();
