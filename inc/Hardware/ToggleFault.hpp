#pragma once

#include "Hardware/Fault.hpp"

class ToggleFault : public Fault {
public:
    /**
     * @brief Constructor of ToggleFault.
     *
     * @param signal_index The index of the signal/the position, which is faulted.
     * @param clock_cycle The clock cycle in which the Fault is injected.
     * @param fault_probability The probability with that the fault is induced.
     */
    ToggleFault(unsigned int signal_index, unsigned int clock_cycle,
                double fault_probability)
        : Fault(signal_index, clock_cycle, fault_probability, FaultType::toggle) {}

    /**
     * @brief Computes the effect of this fault on a given fault-free computation of a signal.
     *
     * @param fault_free_computation The fault-free computation computed by the simulator.
     * @return The value of a signal faulted with this fault.
     */
    virtual uint64_t ComputeFaultEffect(uint64_t fault_free_computation) const override {
        // For a Toggle fault, the signal is toggled (bitwise NOT operation)
        return ~fault_free_computation;
    }
};
