#include "Util/Util.hpp"

void Util::StartClock(timespec& Begin){
    clock_gettime(CLOCK_REALTIME, &Begin);
}

double Util::EndClock(timespec& Begin){
    struct timespec End;
    clock_gettime(CLOCK_REALTIME, &End);
    long TimeInSeconds = End.tv_sec - Begin.tv_sec;
    long TimeInNanoseconds = End.tv_nsec - Begin.tv_nsec;
    double ElapsedTimePeriod = TimeInSeconds + TimeInNanoseconds*1e-9;
    return ElapsedTimePeriod;
}