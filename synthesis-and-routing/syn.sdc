#------------------------------------------#
# Design Constraints
#------------------------------------------#

# Define a virtual clock for I/O timing constraints
create_clock -name virtual_clock -period 20 

# Set input delay constraints relative to the virtual clock
set_input_delay 1 [all_inputs] -clock virtual_clock

# Set output delay constraints relative to the virtual clock
set_output_delay 0.5 [all_outputs] -clock virtual_clock

# Define the load for output pins (in terms of capacitance)
set_load 10 [all_outputs]

# Add timing exceptions (optional but ensure they are valid for both stages)
set_false_path -from [get_ports reset_n]

# Define utilization constraint
set_max_utilization 0.6

# Enable usage of all library cells
set_max_area 0

