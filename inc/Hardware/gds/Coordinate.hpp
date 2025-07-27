
#pragma once

#include <iostream>


/**
 * @brief The Coordinate class represents a 2D point with x and y coordinates.
 * It provides methods for printing, addition, subtraction, and stream output.
 */
struct Coordinate {
    double x;
    double y;

    Coordinate(double xx, double yy);
    Coordinate();

    void print() const;

    Coordinate& operator+=(Coordinate const& rhs)&;
    friend Coordinate operator+(Coordinate lhs, Coordinate const& rhs);

    Coordinate& operator-=(Coordinate const& rhs)&;
    friend Coordinate operator-(Coordinate lhs, Coordinate const& rhs);

    Coordinate& operator*=(Coordinate const& rhs)&;
    friend Coordinate operator*(Coordinate lhs, Coordinate const& rhs);

    friend std::ostream& operator<<(std::ostream &out, Coordinate const& coordinate);
};



