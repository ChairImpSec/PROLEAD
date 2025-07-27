
#pragma once

/**
 * @brief The Gate class represents a gate with a name, type, and bounding box.
 */
#include "BoundingBox.hpp"
#include "gdstk/reference.hpp"
#include <string>

class Gate {
private:
    static std::string ExtractNameFromProperty(gdstk::Reference * reference);

public:
    std::string name;
    std::string type;
    BoundingBox bbox;

    Gate(std::string _name, std::string _type, double minx, double miny, double maxx, double maxy);
    static Gate CreateGateFromReference(gdstk::Reference * reference);

    friend std::ostream& operator<<(std::ostream &out, Gate const& gate);
};
