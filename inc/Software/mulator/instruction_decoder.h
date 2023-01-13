#pragma once

#include "Software/mulator/instruction.h"
#include "Software/mulator/return_codes.h"
#include <tuple>

namespace mulator
{

    class InstructionDecoder
    {
    public:
        /*
         * Returns the size (2 or 4 bytes) of the instruction starting with the given bytes.
         * The supplied array has to be at least 2 bytes long.
         */
        static u8 get_instruction_size(const u8* bytes);

        /*
         * Constructs a new decoder for the given architecture.
         */
        InstructionDecoder(Architecture arch);

        /*
         * Get the architecture this decoder was instantiated for.
         */
        Architecture get_architecture() const;

        /*
         * Decodes an instruction from the byte stream.
         * If decoding was not successful, the returned instruction will still be filled with as much correct information as possible.
         *
         * @param[in] address - the logical address of the current instruction
         * @param[in] bytes - a pointer to the first byte of the instruction
         * @param[in] code_size - the number of remaining bytes in the byte stream
         * @param[in] in_IT_block - indicates whether the instruction is to be decoded as if execution is currently in an If-Then (IT) block
         * @param[in] last_in_IT_block - indicates whether the instruction is the last one in an If-Then (IT) block
         *
         * @returns A pair of return code and decoded instruction. Only for return code "OK" the instruction was decoded from valid Assembly.
         */
        std::pair<ReturnCode, Instruction> decode_instruction(u32 address, const u8* bytes, u32 code_size, bool in_IT_block, bool last_in_IT_block);

    private:
        Architecture m_arch;
        std::string m_error_message;
    };

} // namespace mulator
