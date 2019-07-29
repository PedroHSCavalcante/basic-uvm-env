package pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "./transaction_in.sv"
  `include "./sequence_in.sv"
  `include "./driver_in.sv"
  `include "./monitor_in.sv"
  `include "./agent_in.sv"

  `include "./transaction_out.sv"
  `include "./driver_out.sv"
  `include "./monitor_out.sv"
  `include "./agent_out.sv"

  `include "./refmod.sv"
  `include "./coverage.sv"
  `include "./scoreboard.sv"
  `include "./env.sv"
  `include "./simple_test.sv"
endpackage
