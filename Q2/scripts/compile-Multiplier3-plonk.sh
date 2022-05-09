#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom using PLONK below
cd contracts/circuits

mkdir _plonk_Multiplier3

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling _plonk_Multiplier3.circom..."

# compile circuit

circom Multiplier3.circom --r1cs --wasm --sym -o _plonk_Multiplier3
snarkjs r1cs info Multiplier3/Multiplier3.r1cs

# Start a new zkey and make a contribution

snarkjs plonk setup _plonk_Multiplier3/Multiplier3.r1cs powersOfTau28_hez_final_10.ptau _plonk_Multiplier3/circuit_final.zkey
#snarkjs zkey contribute Multiplier3/circuit_0000.zkey Multiplier3/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey _plonk_Multiplier3/circuit_final.zkey _plonk_Multiplier3/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier _plonk_Multiplier3/circuit_final.zkey ../_plonk_Multiplier3Verifier.sol

cd ../..