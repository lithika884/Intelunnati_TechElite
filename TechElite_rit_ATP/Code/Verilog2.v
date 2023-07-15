module Verilog2 (
  input wire clk,
  input wire reset,
  input wire cashValid,
  input wire chequeValid,
  input wire ddValid,
  input wire [31:0] cashNumber,
  input wire [31:0] chequeNumber,
  input wire [31:0] ddNumber,
  input wire [15:0] micrField,
  input wire [31:0] currentMonthBill,
  input wire [31:0] previousMonthBalance,
  output reg [31:0]  nextMonthBalance
);
  
  // Define states
  parameter IDLE = 2'b00;
  parameter CASH_PAYMENT = 2'b01;
  parameter CHEQUE_PAYMENT = 2'b10;
  parameter DD_PAYMENT = 2'b11;
  
  // Define state register and next state logic
  reg [1:0] currentState;
  reg [1:0] nextState;
  
  // Define other variables
  reg [31:0] excessPayment;
  reg [31:0] cashAmount;
  reg [31:0] chequeAmount;
  reg [31:0] ddAmount;
  
  // Placeholder values for testing (replace with actual values)
  localparam [31:0] CASH_NUMBER = 32'd1234;
  localparam [31:0] CHEQUE_NUMBER = 32'd5678;
  localparam [15:0] MICR_FIELD = 16'd9876;
  localparam [31:0] DD_NUMBER = 32'd5432;
  localparam [31:0] CASH_AMOUNT = 32'd100;
  localparam [31:0] CHEQUE_AMOUNT = 32'd200;
  localparam [31:0] DD_AMOUNT = 32'd150;
 

  always @(posedge clk) begin
    if (reset) begin
      currentState <= IDLE;
      excessPayment <= 32'd0;
    end
    else begin
      currentState <= nextState;
      
      case (currentState)
        IDLE: begin
          if (cashValid) begin
            nextState <= CASH_PAYMENT;
          end
          else if (chequeValid) begin
            nextState <= CHEQUE_PAYMENT;
          end
          else if (ddValid) begin
            nextState <= DD_PAYMENT;
          end
          else begin
            nextState <= IDLE;
          end
        end
        
        CASH_PAYMENT: begin
          if (cashNumber == CASH_NUMBER && currentMonthBill >= cashAmount) begin
            excessPayment <= currentMonthBill - cashAmount;
          end
          else begin
            excessPayment <= 32'd0;
          end
          nextState <= IDLE;
        end
        
        CHEQUE_PAYMENT: begin
          if (chequeNumber == CHEQUE_NUMBER && micrField == MICR_FIELD && currentMonthBill >= chequeAmount) begin
            excessPayment <= currentMonthBill - chequeAmount;
          end
          else begin
            excessPayment <= 32'd0;
          end
          nextState <= IDLE;
        end
        
        DD_PAYMENT: begin
          if (ddNumber == DD_NUMBER && currentMonthBill >= ddAmount) begin
            excessPayment <= currentMonthBill - ddAmount;
          end
          else begin
            excessPayment <= 32'd0;
          end
          nextState <= IDLE;
        end
      endcase
    end
  end
  
  always @(posedge clk) begin
    case (currentState)
      IDLE: begin
        if (excessPayment > previousMonthBalance) begin
          nextMonthBalance <= 32'd0;
        end
        else begin
          nextMonthBalance <= previousMonthBalance - excessPayment;
        end
      end
      
      default: begin
        nextMonthBalance <= previousMonthBalance;
      end
    endcase
  end
  
endmodule




