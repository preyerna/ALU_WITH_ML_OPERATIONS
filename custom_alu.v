module custom_alu #( 
    parameter WIDTH = 8
)(
  input  [WIDTH-1:0] a,        
  input  [WIDTH-1:0] b,  
  input  clk,
  input  rst,    
  input  enable, 
  input  [3:0] opcode,   // Extended to 4 bits
  output reg [2*WIDTH-1:0] result,
  output reg carry_flag,
  output reg borrow_flag,
  output reg zero_flag
);

  wire cin = 1'b0;
  wire bin = 1'b0; 
  
  wire [WIDTH-1:0] add_out, sub_out, and_out, or_out, xor_out, inc_out, dec_out, not_out;
  wire [WIDTH-1:0] relu_out, abs_out, clip_out, sigmoid_out, square_out, tanh_out;
  wire [2*WIDTH-1:0] mac_out;
  wire cout_wire, bout_wire;
  
  Ripple_carryadder adder_ins (a, b, cin, add_out, cout_wire);
  eightbitsubtractor subt_ins (a, b, bin, sub_out, bout_wire);
  bitwise_and and_ins (a, b, and_out);
  bitwise_or or_ins (a, b, or_out);
  bitwise_xor xor_ins (a, b, xor_out);
  inc8bit inc_ins (a, clk, rst, inc_out); 
  dec_bit dec_ins (a, clk, rst, dec_out);
  not_8bit not_ins (a, not_out);
  MAC Mac_ins(clk, rst, enable, a, b, mac_out);
  Relu relu_ins(a, relu_out);
  absolute abs_ins(a, abs_out);
  sigmoid sig_ins(a, sigmoid_out);
  clip clip_ins(a, clip_out);
  square sq_ins(a, square_out);
  tanh tan_ins(a, tanh_out);

  always @(*) begin
    result      = {2*WIDTH{1'b0}};  // Initialize to zeros
    carry_flag  = 0;
    borrow_flag = 0;
    zero_flag   = 0;

    case (opcode)
      4'b0000: begin result = { {WIDTH{1'b0}}, add_out }; carry_flag = cout_wire; end
      4'b0001: begin result = { {WIDTH{1'b0}}, sub_out }; borrow_flag = bout_wire; end
      4'b0010: result = { {WIDTH{1'b0}}, and_out };
      4'b0011: result = { {WIDTH{1'b0}}, or_out };
      4'b0100: result = { {WIDTH{1'b0}}, xor_out };
      4'b0101: begin result = { {WIDTH{1'b0}}, inc_out }; carry_flag = (a == 8'hFF); end
      4'b0110: begin result = { {WIDTH{1'b0}}, dec_out }; borrow_flag = (a == 8'h00); end
      4'b0111: result = { {WIDTH{1'b0}}, not_out };

      4'b1000: result = mac_out;  // MAC output is already 2×WIDTH
      4'b1001: result = { {WIDTH{1'b0}}, relu_out };
      4'b1010: result = { {WIDTH{1'b0}}, abs_out };
      4'b1011: result = { {WIDTH{1'b0}}, sigmoid_out };
      4'b1100: result = { {WIDTH{1'b0}}, clip_out };
      4'b1101: result = { {WIDTH{1'b0}}, square_out };
      4'b1110: result = { {WIDTH{1'b0}}, tanh_out };

      default: result = {2*WIDTH{1'b0}};
    endcase

    if (result == {2*WIDTH{1'b0}})
      zero_flag = 1;
  end  

endmodule
