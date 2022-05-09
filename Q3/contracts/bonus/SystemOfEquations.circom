pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/gates.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom";
include "../../node_modules/circomlib-matrix/circuits/matSub.circom"; // hint: you can use more than one templates in circomlib-matrix to help you

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
         component multiplier = matMul(n, n, 1);
         component subtraction = matSub(n, 1);

   
    for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {
            multiplier.a[i][j] <== A[i][j];
        }
        multiplier.b[i][0] <== x[i];
    }

   
    for (var i = 0; i < n; i++) {
        subtraction.a[i][0] <== multiplier.out[i][0];
        subtraction.b[i][0] <== b[i];
    }

    
    component zero[n];
    for (var i = 0; i < n; i++) {
        zero[i] = IsZero();
        zero[i].in <== subtraction.out[i][0];
        zero[i].out === 1;
    }

  
    component multiplierAnd = MultiAND(n);
    for (var i = 0; i < n; i++) {
        multiplierAnd.in[i] <== zero[i].out;
    }
    
  
    out <== multiplierAnd.out;

}

component main {public [A, b]} = SystemOfEquations(3);