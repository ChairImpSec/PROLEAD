#include "Hardware/gds/Coordinate.hpp"

#include <iomanip>
#include <iostream>

Coordinate::Coordinate(double xx, double yy) : x(xx), y(yy) {}
Coordinate::Coordinate(){}

void Coordinate::print() const {
    std::cout << *this;
}

Coordinate& Coordinate::operator+=(Coordinate const& rhs)& {
    this->x += rhs.x;
    this->y += rhs.y;
    return *this;
}

Coordinate operator+(Coordinate lhs, Coordinate const& rhs) {
    lhs += rhs;
    return lhs;
}

Coordinate& Coordinate::operator-=(Coordinate const& rhs)& {
    this->x -= rhs.x;
    this->y -= rhs.y;
    return *this;
}

Coordinate operator-(Coordinate lhs, Coordinate const& rhs) {
    lhs -= rhs;
    return lhs;
}

Coordinate& Coordinate::operator*=(Coordinate const& rhs)& {
    this->x *= rhs.x;
    this->y *= rhs.y;
    return *this;
}

Coordinate operator*(Coordinate lhs, Coordinate const& rhs) {
    lhs *= rhs;
    return lhs;
}

std::ostream& operator<<(std::ostream &out, Coordinate const& coordinate) {
    out << "(";
    out << std::setw(7) << std::right << std::fixed << std::setprecision(3) << coordinate.x;
    out << ", ";
    out << std::setw(7) << std::right << std::fixed << std::setprecision(3) << coordinate.y;
    out << ")";
    out << std::left;
    return out;
}
