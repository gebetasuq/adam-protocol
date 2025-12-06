pragma circom 2.0.0;

include "node_modules/circomlib/circuits/comparators.circom";

template EnergyProof() {
    // Private inputs (never revealed)
    signal input previousReading;
    signal input currentReading;
    signal input secretSalt;
    
    // Public inputs/outputs
    signal output reductionPercentage;
    signal output isValid;
    
    // Calculate reduction
    var reduction = previousReading - currentReading;
    var percentage = (reduction * 100) / previousReading;
    
    // Constrain outputs
    reductionPercentage <== percentage;
    
    // Prove reduction >= 15% without revealing actual values
    component isGreater = GreaterEqThan(32);
    isGreater.in[0] <== reduction * 100;
    isGreater.in[1] <== previousReading * 15;  // 15% threshold
    
    isValid <== isGreater.out;
}

component main = EnergyProof();
