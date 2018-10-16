`timescale 1 ns / 1 ps

module fsm
(
    input clk,		// State updates and output transitions are synchronous
    input negativeedge_sclk,
    input positiveedge_sclk,
    input cs,
    input mosi,
    output reg MISO_BUF,
    output reg ADDR_WE,
    output reg DM_WE,
    output reg SR_WE
);

    // State encoding (one-hot)
    reg [4:0] state;
    localparam  IDLE = 5'd0,
		ACTIVE = 5'd1,
    FIND_ADDR0 = 5'd2,
    FIND_ADDR1 = 5'd3,
    FIND_ADDR2 = 5'd4,
    FIND_ADDR3 = 5'd5,
    FIND_ADDR4 = 5'd6,
    FIND_ADDR5 = 5'd7,
    FIND_ADDR6 = 5'd8,

    READ_STATE = 5'd9,
    DM_LOAD_TO_SR = 5'd10,
    DISEN_SR_WE = 5'd11,
    READ0 = 5'd12,
    READ1 = 5'd13,
    READ2 = 5'd14,
    READ3 = 5'd15,
    READ4 = 5'd16,
    READ5 = 5'd17,
    READ6 = 5'd18,
    READ7 = 5'd19,

    WRITE_STATE = 5'd20,
    LOAD_RW = 5'd21,
    WRITE0 = 5'd22,
    WRITE1 = 5'd23,
    WRITE2 = 5'd24,
    WRITE3 = 5'd25,
    WRITE4 = 5'd26,
    WRITE5 = 5'd27,
    WRITE6 = 5'd28,
    WRITE7 = 5'd29;


    // State update logic
    always @(posedge clk) begin
        // Begin in OFF state out of reset (synchronous reset)
        if (cs) begin
            state <= IDLE;
        end

        else begin
            case (state)
                IDLE: begin
                    if (cs==0)
                        state <= ACTIVE;
                    else
                        state <= IDLE;
                end

                ACTIVE: begin
                    if (positiveedge_sclk)
                        state <= FIND_ADDR0;
                    else
                        state <= ACTIVE;
                end

                FIND_ADDR0: begin
                    if (positiveedge_sclk)
                        state <= FIND_ADDR1;
                    else
                        state <= FIND_ADDR0;
                end

                FIND_ADDR1: begin
                    if (positiveedge_sclk)
                        state <= FIND_ADDR2;
                    else
                        state <= FIND_ADDR1;
                end

                FIND_ADDR2: begin
                    if (positiveedge_sclk)
                        state <= FIND_ADDR3;
                    else
                        state <= FIND_ADDR2;
                end

                FIND_ADDR3: begin
                    if (positiveedge_sclk)
                        state <= FIND_ADDR4;
                    else
                        state <= FIND_ADDR3;
                end

                FIND_ADDR4: begin
                    if (positiveedge_sclk)
                        state <= FIND_ADDR5;
                    else
                        state <= FIND_ADDR4;
                end

                FIND_ADDR5: begin
                    if (positiveedge_sclk)
                        state <= FIND_ADDR6;
                    else
                        state <= FIND_ADDR5;
                end

                FIND_ADDR6: begin
                    if (negativeedge_sclk == 1 && mosi == 1)
                        state <= READ_STATE;
                    else if (negativeedge_sclk == 1 && mosi == 0)
                        state <= WRITE_STATE;
                    else
                        state <= FIND_ADDR6;
                end

                READ_STATE: begin
                    if (positiveedge_sclk)
                        state <= DM_LOAD_TO_SR;
                    else
                        state <= READ_STATE;
                end

                DM_LOAD_TO_SR: begin
                    if (negativeedge_sclk)
                        state <= DISEN_SR_WE;
                    else
                        state <= DM_LOAD_TO_SR;
                end

                DISEN_SR_WE: begin
                    if (positiveedge_sclk)
                        state <= READ0;
                    else
                        state <= DISEN_SR_WE;
                end

                READ0: begin
                    if (positiveedge_sclk)
                        state <= READ1;
                    else
                        state <= READ0;
                end

                READ1: begin
                    if (positiveedge_sclk)
                        state <= READ2;
                    else
                        state <= READ1;
                end

                READ2: begin
                    if (positiveedge_sclk)
                        state <= READ3;
                    else
                        state <= READ2;
                end

                READ3: begin
                    if (positiveedge_sclk)
                        state <= READ4;
                    else
                        state <= READ3;
                end

                READ4: begin
                    if (positiveedge_sclk)
                        state <= READ5;
                    else
                        state <= READ4;
                end

                READ5: begin
                    if (positiveedge_sclk)
                        state <= READ6;
                    else
                        state <= READ5;
                end

                READ6: begin
                    if (positiveedge_sclk)
                        state <= READ7;
                    else
                        state <= READ6;
                end

                READ7: begin
                    if (positiveedge_sclk)
                        state <= FIND_ADDR0;
                    else
                        state <= READ7;
                end

                WRITE_STATE: begin
                    if (positiveedge_sclk)
                        state <= LOAD_RW;
                    else
                        state <= WRITE_STATE;
                end

                LOAD_RW: begin
                    if (positiveedge_sclk)
                        state <= WRITE0;
                    else
                        state <= LOAD_RW;
                end

                WRITE0: begin
                    if (positiveedge_sclk)
                        state <= WRITE1;
                    else
                        state <= WRITE0;
                end

                WRITE1: begin
                    if (positiveedge_sclk)
                        state <= WRITE2;
                    else
                        state <= WRITE1;
                end

                WRITE2: begin
                    if (positiveedge_sclk)
                        state <= WRITE3;
                    else
                        state <= WRITE2;
                end

                WRITE3: begin
                    if (positiveedge_sclk)
                        state <= WRITE4;
                    else
                        state <= WRITE3;
                end

                WRITE4: begin
                    if (positiveedge_sclk)
                        state <= WRITE5;
                    else
                        state <= WRITE4;
                end

                WRITE5: begin
                    if (positiveedge_sclk)
                        state <= WRITE6;
                    else
                        state <= WRITE5;
                end

                WRITE6: begin
                    if (positiveedge_sclk)
                        state <= WRITE7;
                    else
                        state <= WRITE6;
                end

                WRITE7: begin
                    if (positiveedge_sclk)
                        state <= FIND_ADDR0;
                    else
                        state <= WRITE7;
                end

            endcase
        end

    end	// @(posedge clk)


    // Output logic (depends only on state - Moore machine)
    always @(state) begin
        case (state)
            IDLE: begin
                MISO_BUF = 0;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            ACTIVE: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            FIND_ADDR0: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            FIND_ADDR1: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            FIND_ADDR2: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            FIND_ADDR3: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            FIND_ADDR4: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            FIND_ADDR5: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            FIND_ADDR6: begin
                MISO_BUF = 1;
                ADDR_WE = 1;
                DM_WE = 0;
                SR_WE = 0; end

            READ_STATE: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 1; end
            DM_LOAD_TO_SR: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            DISEN_SR_WE: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end

            READ0: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            READ1: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            READ2: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            READ3: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            READ4: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            READ5: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            READ6: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            READ7: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end

            WRITE_STATE: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            LOAD_RW: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end

            WRITE0: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            WRITE1: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            WRITE2: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            WRITE3: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            WRITE4: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            WRITE5: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            WRITE6: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 0;
                SR_WE = 0; end
            WRITE7: begin
                MISO_BUF = 1;
                ADDR_WE = 0;
                DM_WE = 1;
                SR_WE = 0; end
        endcase
    end


endmodule
