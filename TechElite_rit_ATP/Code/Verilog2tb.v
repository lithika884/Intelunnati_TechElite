 module Verilog2tb;
  
  reg clk;
  reg reset;
  reg cashValid;
  reg chequeValid;
  reg ddValid;
  reg [31:0] cashNumber;
  reg [31:0] chequeNumber;
  reg [31:0] ddNumber;
  reg [15:0] micrField;
  reg [31:0] currentMonthBill;
  reg [31:0] previousMonthBalance;
  
  wire [31:0] nextMonthBalance;
  
  // Instantiate the Verilog2 module
  Verilog2 dut (
    .clk(clk),
    .reset(reset),
    .cashValid(cashValid),
    .chequeValid(chequeValid),
    .ddValid(ddValid),
    .cashNumber(cashNumber),
    .chequeNumber(chequeNumber),
    .ddNumber(ddNumber),
    .micrField(micrField),
    .currentMonthBill(currentMonthBill),
    .previousMonthBalance(previousMonthBalance),
    .nextMonthBalance(nextMonthBalance)
  );
  
  // Define other variables
  reg [31:0] excessPayment;
  reg [31:0] cashAmount;
  reg [31:0] chequeAmount;
  reg [31:0] ddAmount;
  
  // Clock generation
  always begin
    #5 clk = ~clk;
  end
  
  initial begin
    // Initialize inputs
    reset = 1;
    cashValid = 0;
    chequeValid = 0;
    ddValid = 0;
    cashNumber = 0;
    chequeNumber = 0;
    ddNumber = 0;
    micrField = 0;
    currentMonthBill = 0;
    previousMonthBalance = 0;
    cashAmount = 0;
    chequeAmount = 0;
    ddAmount = 0;
    
    // Wait for a few clock cycles
    #10;
    
    // Deassert reset
    reset = 0;
    
    // Test case 1: Cash payment
    #10;
    cashValid = 1;
    cashNumber = 32'd1234;
    cashAmount = 32'd100;
    currentMonthBill = 32'd150;
    #10;
    cashValid = 0;
    
    // Test case 2: Cheque payment
    #10;
    chequeValid = 1;
    chequeNumber = 32'd5678;
    micrField = 16'd9876;
    chequeAmount = 32'd200;
    currentMonthBill = 32'd300;
    #10;
    chequeValid = 0;
    
    // Test case 3: DD payment
    #10;
    ddValid = 1;
    ddNumber = 32'd5432;
    ddAmount = 32'd150;
    currentMonthBill = 32'd200;
    #10;
    ddValid = 0;
    
    // Wait for simulation to complete
    #20;
    
    // End simulation
    $finish;
  end
  
endmodule
