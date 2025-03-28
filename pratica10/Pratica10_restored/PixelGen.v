module PixelGen(
    input  wire clk,
    input  wire rstn,
    input  wire video_on, 
    input  wire p_tick,

    // Four separate signals for paddles
    input  wire left_up,      // W
    input  wire left_down,    // S
    input  wire right_up,     // I
    input  wire right_down,   // K

    input  wire [9:0] pixel_x,
    input  wire [9:0] pixel_y,

    // 12-bit color output: {4'b red, 4'b green, 4'b blue}
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b
);

    //---------------------------------------------------------
    // 1) Screen & Object Parameters
    //---------------------------------------------------------
    localparam SCREEN_W     = 640;
    localparam SCREEN_H     = 480;

    localparam PADDLE_W     = 10;  
    localparam PADDLE_H     = 60;  
    localparam BALL_SIZE    = 10;  

    localparam LEFT_PADDLE_X  = 30;
    localparam RIGHT_PADDLE_X = SCREEN_W - 30 - PADDLE_W;

    // Colors (12-bit)
    localparam COLOR_BLACK = 12'h000;
    localparam COLOR_WHITE = 12'hFFF;
    localparam COLOR_RED   = 12'hF00;
    localparam COLOR_YELLOW  = 12'hFF0;

    //---------------------------------------------------------
    // 2) Frame Refresh Tick: ~60 Hz
    //---------------------------------------------------------
    wire refr_tick;
    assign refr_tick = (pixel_y == 480) && (pixel_x == 0);

    //---------------------------------------------------------
    // 3) Paddles & Ball State
    //---------------------------------------------------------
    reg [9:0] left_paddle_y, right_paddle_y;
    reg [9:0] ball_x, ball_y;
    reg        ball_dir_x, ball_dir_y;

    // Contadores de pontuação
    reg [3:0] left_score;  // Pontuação do jogador da esquerda (0 a 9)
    reg [3:0] right_score; // Pontuação do jogador da direita (0 a 9)

    //---------------------------------------------------------
    // 4) Initialization & Movement Logic
    //---------------------------------------------------------
 

    //---------------------------------------------------------
    // 5) Initialization & Movement Logic
    //---------------------------------------------------------
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            left_paddle_y  <= (SCREEN_H - PADDLE_H) / 2;
            right_paddle_y <= (SCREEN_H - PADDLE_H) / 2;
            ball_x         <= (SCREEN_W - BALL_SIZE) / 2;
            ball_y         <= (SCREEN_H - BALL_SIZE) / 2;
            ball_dir_x     <= 1'b1;
            ball_dir_y     <= 1'b1;
            left_score     <= 0;
            right_score    <= 0;
        end else if (refr_tick) begin
            if (left_up && (left_paddle_y >= 4))
                left_paddle_y <= left_paddle_y - 4;
            else if (left_down && ((left_paddle_y + PADDLE_H + 4) <= SCREEN_H))
                left_paddle_y <= left_paddle_y + 4;

            if (right_up && (right_paddle_y >= 4))
                right_paddle_y <= right_paddle_y - 4;
            else if (right_down && ((right_paddle_y + PADDLE_H + 4) <= SCREEN_H))
                right_paddle_y <= right_paddle_y + 4;

            if (ball_dir_x)
                ball_x <= ball_x + 2;
            else
                ball_x <= ball_x - 2;

            if (ball_dir_y)
                ball_y <= ball_y + 2;
            else
                ball_y <= ball_y - 2;

            if (ball_y <= BALL_SIZE)
                ball_dir_y <= 1'b1;
            else if (ball_y + BALL_SIZE >= SCREEN_H)
                ball_dir_y <= 1'b0;

            if (ball_x <= (LEFT_PADDLE_X + PADDLE_W)) begin
                if ((ball_y + BALL_SIZE >= left_paddle_y) &&
                    (ball_y <= left_paddle_y + PADDLE_H))
                    ball_dir_x <= 1'b1;
                else begin
                    ball_x     <= (SCREEN_W - BALL_SIZE) / 2;
                    ball_y     <= (SCREEN_H - BALL_SIZE) / 2;
                    ball_dir_x <= 1'b1;
                    ball_dir_y <= 1'b1;
                    right_score <= right_score + 1;
                end
            end

            if ((ball_x + BALL_SIZE) >= RIGHT_PADDLE_X) begin
                if ((ball_y + BALL_SIZE >= right_paddle_y) &&
                    (ball_y <= right_paddle_y + PADDLE_H))
                    ball_dir_x <= 1'b0;
                else begin
                    ball_x     <= (SCREEN_W - BALL_SIZE) / 2;
                    ball_y     <= (SCREEN_H - BALL_SIZE) / 2;
                    ball_dir_x <= 1'b0;
                    ball_dir_y <= 1'b1;
                    left_score <= left_score + 1;
                end
            end
        end
    end

    //---------------------------------------------------------
    // 6) On-Screen Detection for Drawing
    //---------------------------------------------------------
    wire left_paddle_on, right_paddle_on, ball_on;

    assign left_paddle_on =
        (pixel_x >= LEFT_PADDLE_X) &&
        (pixel_x <  LEFT_PADDLE_X + PADDLE_W) &&
        (pixel_y >= left_paddle_y) &&
        (pixel_y <  left_paddle_y + PADDLE_H);

    assign right_paddle_on =
        (pixel_x >= RIGHT_PADDLE_X) &&
        (pixel_x <  RIGHT_PADDLE_X + PADDLE_W) &&
        (pixel_y >= right_paddle_y) &&
        (pixel_y <  right_paddle_y + PADDLE_H);

    assign ball_on =
        (pixel_x >= ball_x) &&
        (pixel_x <  (ball_x + BALL_SIZE)) &&
        (pixel_y >= ball_y) &&
        (pixel_y <  (ball_y + BALL_SIZE));

    //---------------------------------------------------------
    // 7) Score Display Logic
    //---------------------------------------------------------
    wire [3:0] tens_digit_left = (left_score >= 10) ? 4'd1 : 4'd0;
    wire [3:0] units_digit_left = left_score - (tens_digit_left * 10);

    wire [3:0] tens_digit_right = (right_score >= 10) ? 4'd1 : 4'd0;
    wire [3:0] units_digit_right = right_score - (tens_digit_right * 10);

    wire left_tens_on = (pixel_x >= 16) && (pixel_x < 24) && (pixel_y >= 16) && (pixel_y < 24);
    wire left_units_on = (pixel_x >= 24) && (pixel_x < 32) && (pixel_y >= 16) && (pixel_y < 24);
    wire right_tens_on = (pixel_x >= 600) && (pixel_x < 608) && (pixel_y >= 16) && (pixel_y < 24);
    wire right_units_on = (pixel_x >= 608) && (pixel_x < 616) && (pixel_y >= 16) && (pixel_y < 24);

    function automatic pixel_on;
        input [3:0] digit;
        input [2:0] x_rel;
        input [2:0] y_rel;
        reg [6:0] seg;
        reg in_a, in_b, in_c, in_d, in_e, in_f, in_g;
    begin
        case (digit)
            4'd0: seg = 7'b1111110;
            4'd1: seg = 7'b0110000;
            4'd2: seg = 7'b1101101;
            4'd3: seg = 7'b1111001;
            4'd4: seg = 7'b0110011;
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1111011;
            default: seg = 7'b0000000;
        endcase

        in_a = (y_rel == 0) && (x_rel >= 1) && (x_rel <=6);
        in_b = (x_rel ==7) && (y_rel >=1) && (y_rel <=2);
        in_c = (x_rel ==7) && (y_rel >=4) && (y_rel <=5);
        in_d = (y_rel ==6) && (x_rel >=1) && (x_rel <=6);
        in_e = (x_rel ==0) && (y_rel >=4) && (y_rel <=5);
        in_f = (x_rel ==0) && (y_rel >=1) && (y_rel <=2);
        in_g = (y_rel ==3) && (x_rel >=1) && (x_rel <=6);

        pixel_on = (in_a & seg[6]) | (in_b & seg[5]) | (in_c & seg[4]) |
                   (in_d & seg[3]) | (in_e & seg[2]) | (in_f & seg[1]) |
                   (in_g & seg[0]);
    end
    endfunction

    wire [2:0] left_tens_x = pixel_x - 16;
    wire [2:0] left_tens_y = pixel_y - 16;
    wire left_tens_pixel = pixel_on(tens_digit_left, left_tens_x, left_tens_y);

    wire [2:0] left_units_x = pixel_x - 24;
    wire [2:0] left_units_y = pixel_y - 16;
    wire left_units_pixel = pixel_on(units_digit_left, left_units_x, left_units_y);

    wire [2:0] right_tens_x = pixel_x - 600;
    wire [2:0] right_tens_y = pixel_y - 16;
    wire right_tens_pixel = pixel_on(tens_digit_right, right_tens_x, right_tens_y);

    wire [2:0] right_units_x = pixel_x - 608;
    wire [2:0] right_units_y = pixel_y - 16;
    wire right_units_pixel = pixel_on(units_digit_right, right_units_x, right_units_y);

    wire score_on = (left_tens_on && left_tens_pixel) ||
                    (left_units_on && left_units_pixel) ||
                    (right_tens_on && right_tens_pixel) ||
                    (right_units_on && right_units_pixel);

    wire left_digit_pixel_on, right_digit_pixel_on;
	wire [7:0] left_digit_pixels, right_digit_pixels;
   
    reg [11:0] rgb_next; // 12-bit color = {4'hR,4'hG,4'hB}

    always @* begin
        if (!video_on) begin
            rgb_next = COLOR_BLACK;
        end else begin
            rgb_next = COLOR_BLACK;

            // Draw paddles
            if (left_paddle_on || right_paddle_on) begin
                rgb_next = COLOR_WHITE;
            end

            // Draw ball
            if (ball_on) begin
                rgb_next = COLOR_YELLOW;
            end

            // Draw score (corrected to use score_on)
            if (score_on) begin
                rgb_next = COLOR_WHITE;
            end
        end
    end
    //---------------------------------------------------------
    // 8) Latch Color on p_tick
    //---------------------------------------------------------
    always @(posedge clk) begin
        if (p_tick)
            {r, g, b} <= rgb_next;
    end
endmodule