function [6:0] display_decode;
    input [7:0] a;

    begin
        display_decode = a == 8'h0 ? 7'h3F :
                         a == 8'h1 ? 7'h06 :
                         a == 8'h2 ? 7'h5B :
                         a == 8'h3 ? 7'h4F :
                         a == 8'h4 ? 7'h66 :
                         a == 8'h5 ? 7'h6D :
                         a == 8'h6 ? 7'h7D :
                         a == 8'h7 ? 7'h07 :
                         a == 8'h8 ? 7'h7F :
                         a == 8'h9 ? 7'h6F :
                         a == 8'hA ? 7'h77 :
                         a == 8'hB ? 7'h7C :
                         a == 8'hC ? 7'h39 :
                         a == 8'hD ? 7'h5E :
                         a == 8'hE ? 7'h79 :
                         a == 8'hF ? 7'h71 : 7'h00;
    end
endfunction
