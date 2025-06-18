# MEL Counter Project - Master Simulation Script
#
# Description: Master script to compile and run all simulations
#              in sequence with proper setup.
#
# Author : Summer Paulus, Matthias Brinskelle
# Date : 18.06.2025
# File : sim.do

echo "MEL Counter Project - Master Simulation Script"
echo "=============================================="

# Step 1: Compile all files
echo "Step 1: Compiling all VHDL files..."
do compile.do

# Step 2: Ask user which simulation to run
echo ""
echo "Available simulations:"
echo "1. IO Control Unit (sim_io_ctrl.do)"
echo "2. Counter Unit (sim_cntr.do)" 
echo "3. Top-Level System (sim_cntr_top.do)"
echo "4. Run all simulations"
echo ""
echo "To run a specific simulation, use:"
echo "  do sim_io_ctrl.do"
echo "  do sim_cntr.do"
echo "  do sim_cntr_top.do"
echo ""
echo "Or uncomment the desired simulation below and run this script again."

# Uncomment one of the following lines to run automatically:
# do sim_io_ctrl.do
# do sim_cntr.do  
# do sim_cntr_top.do

echo ""
echo "Master script completed. Ready for simulation."
