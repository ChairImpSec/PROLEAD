
#include "Hardware/gds/Gate.hpp"
#include "gdstk/cell.hpp"
#include <iomanip>

/**
 * @brief Static method to extract the name of a gate from its reference.
 */
std::string Gate::ExtractNameFromProperty(gdstk::Reference *reference) {
    gdstk::Property *property = reference->properties;
    if (property == nullptr) {
        throw std::runtime_error("I expected a property for this gate, containing its name");
    }

    if (property->value == nullptr || property->value->next == nullptr) {
        throw std::runtime_error("I expected a property value for this gate, containing its name");
    }

    gdstk::PropertyValue *property_value_containing_name = property->value->next;
    if (property_value_containing_name->type != gdstk::PropertyType::String) {
        throw std::runtime_error("Expect the name to be a string");
    }
    return std::string{(char*)property_value_containing_name->bytes};
}

/**
 * @brief Constructor for Gate.
 */
Gate::Gate(std::string _name, std::string _type, double minx, double miny, double maxx, double maxy)
    : name(_name), type(_type), bbox(Coordinate(minx, miny), Coordinate(maxx, maxy)) {}

/**
 * @brief Static method to create a Gate from a reference.
 */
Gate Gate::CreateGateFromReference(gdstk::Reference *reference) {
    std::string name = Gate::ExtractNameFromProperty(reference);

    gdstk::Vec2 min, max;
    reference->bounding_box(min, max);
    return Gate{name, std::string(reference->cell->name), min.x, min.y, max.x, max.y};
}

std::ostream& operator<<(std::ostream &out, Gate const& gate) {
    out << std::setw(18) << gate.name;
    out << std::setw(36) << gate.type;
    out << gate.bbox;
    return out;
}
