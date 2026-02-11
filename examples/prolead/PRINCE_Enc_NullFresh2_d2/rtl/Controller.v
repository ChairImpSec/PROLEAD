/*
* -----------------------------------------------------------------
* COMPANY : Ruhr University Bochum
* AUTHOR  : Amir Moradi amir.moradi@rub.de Aein Rezaei Shahmirzadi aein.rezaeishahmirzadi@rub.de
* DOCUMENT: "Second-Order SCA Security with almost no Fresh Randomness" TCHES 2021, Issue 3
* -----------------------------------------------------------------
*
* Copyright c 2021, Amir Moradi, Aein Rezaei Shahmirzadi
*
* All rights reserved.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTERS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* INCLUDING NEGLIGENCE OR OTHERWISE ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* Please see LICENSE and README for license and further instructions.
*/

module Controller(
    input clk,
    input reset,
    output reg [3:0] round,
    output roundStart_Select,
    output reg roundHalf_Select,
    output reg roundEnd_Select,
    output reg done
    );
    
    reg [3:0] PerRoundCounter;
    reg [3:0] RoundCounterMux;
    reg [3:0] RoundCounterPlusOne;
    reg [3:0] RoundCounterReg;
    reg  RoundCounterEN;
    

    reg [3:0] PerRoundCounterMux;
    reg [3:0] PerRoundCounterPlusOne;
    reg [3:0] PerRoundCounterReg;
    
    always @(*) begin
        
        if(reset) begin
            RoundCounterMux = 1;
        end
        else begin
            RoundCounterMux = RoundCounterReg;
        end

        if((RoundCounterPlusOne != 7 && PerRoundCounterPlusOne == 4'h7) || reset == 1 || (RoundCounterPlusOne == 7 && PerRoundCounterPlusOne == 4'd14)) begin
            RoundCounterEN = 1;
        end
        else begin
            RoundCounterEN = 0;
        end

        
        RoundCounterPlusOne = RoundCounterMux + 1;
        round = RoundCounterPlusOne;
    end
    
    always @(posedge clk) begin
        if(RoundCounterEN) begin
            RoundCounterReg <= RoundCounterPlusOne;
        end
    end
    
    //-------------------------------------------
    
    always @(*) begin
        
        if(reset) begin
            PerRoundCounterMux = 4'd15;
        end
        else begin
            PerRoundCounterMux = PerRoundCounterReg;
        end
        
        PerRoundCounterPlusOne = PerRoundCounterMux + 1;

    end
    
    always @(posedge clk) begin
        if((RoundCounterPlusOne != 7 && PerRoundCounterPlusOne == 4'd7) || (RoundCounterPlusOne == 7 && PerRoundCounterPlusOne == 4'd14))
            PerRoundCounterReg <= 0;
        else 
            PerRoundCounterReg <= PerRoundCounterPlusOne;
    end
    
    
    assign roundStart_Select = reset;
    
    always @(posedge clk) begin

        roundHalf_Select <= 0;
        roundEnd_Select <= 0;

        if((RoundCounterPlusOne >= 7 && PerRoundCounterPlusOne >= 7)) begin
            roundHalf_Select <= 1;
        end
        if(RoundCounterPlusOne >= 8 || (RoundCounterPlusOne >= 7 && PerRoundCounterPlusOne == 14)) begin
            roundEnd_Select <= 1;
            roundHalf_Select <= 1;
        end

    end
    always @(*) begin
        done = 0;
        if(RoundCounterPlusOne == 4'hd) begin
            done = 1;
        end
    end
endmodule
