function [6:0] display_decode;
    input [3:0] a;

    begin
        display_decode = a == 4'h0 ? 7'h3F :
                         a == 4'h1 ? 7'h06 :
                         a == 4'h2 ? 7'h5B :
                         a == 4'h3 ? 7'h4F :
                         a == 4'h4 ? 7'h66 :
                         a == 4'h5 ? 7'h6D :
                         a == 4'h6 ? 7'h7D :
                         a == 4'h7 ? 7'h07 :
                         a == 4'h8 ? 7'h7F :
                         a == 4'h9 ? 7'h6F :
                         a == 4'hA ? 7'h77 :
                         a == 4'hB ? 7'h7C :
                         a == 4'hC ? 7'h39 :
                         a == 4'hD ? 7'h5E :
                         a == 4'hE ? 7'h79 :
                         a == 4'hF ? 7'h71 : 7'h00;
    end
endfunction
