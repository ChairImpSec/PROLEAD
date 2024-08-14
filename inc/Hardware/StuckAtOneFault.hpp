#pragma once

#include "Hardware/Fault.hpp"

class StuckAtOneFault : public Fault {
public:
    /**
     * @brief Constructor of StuckAtOneFault.
     *
     * @param signal_index The index of the signal/the position, which is faulted.
     * @param clock_cycle The clock cycle in which the Fault is injected.
     * @param fault_probability The probability with that the fault is induced.
     */
    StuckAtOneFault(unsigned int signal_index, unsigned int clock_cycle,
                    double fault_probability)
        : Fault(signal_index, clock_cycle, fault_probability, FaultType::stuck_at_1) {}

    /**
     * @brief Computes the effect of this fault on a given fault-free computation of a signal.
     *
     * @param fault_free_computation The fault-free computation computed by the simulator.
     * @return One is returned since for StuckAtZero fault, the signal is always set to 0.
     */
    virtual uint64_t ComputeFaultEffect(uint64_t /*fault_free_computation*/) const override {
        return 0xffffffffffffffff;
    }
};
