
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <stdio.h>
#include <string>

#include "gdstk/array.hpp"
#include "gdstk/library.hpp"
#include "gdstk/reference.hpp"
#include "Hardware/gds/utils/gdstk/gdstk_utils.hpp"

namespace util {

// TODO: incorperate somehow the logger.
void print_all_cells(const gdstk::Library& lib) {
    BOOST_LOG_TRIVIAL(trace) << "Parsed cells: ";
    for (size_t i = 0; i < lib.cell_array.count; ++i) {
        gdstk::Vec2 min;
        gdstk::Vec2 max;
        lib.cell_array[i]->bounding_box(min, max);
        BOOST_LOG_TRIVIAL(trace) << std::setw(4) << i <<
          std::setw(36) << lib.cell_array[i]->name <<
          std::setw(10) << " - BBox: ((" << min.x << ", " << min.y << "), (" << max.x << ", " << max.y << "))";
    }
}

void print_all_references(const gdstk::Library& lib, const std::string top_level_name) {
    for (size_t i = 0; i < lib.cell_array.count; ++i) {
        gdstk::Cell* cell = lib.cell_array[i];

        if (cell->name == top_level_name) {
            std::cout << "--------------------------------------------------------------------------------\n";
            std::cout << "Toplevel Cell";
            std::cout << "\n\t" << std::left << std::setw(8) << "Index:" << std::setw(4) << i;
            std::cout << "\n\t" << std::left << std::setw(8) << "Name:" << std::left << std::setw(36) << cell->name;
            std::cout << "\n\t" << std::left << std::setw(8) << "Childs:" << std::setw(4) << cell->reference_array.count;
            std::cout << "\n--------------------------------------------------------------------------------" << std::endl;

            for (size_t j = 0; j < cell->reference_array.count; ++j) {
                if (cell->reference_array[j]->type != gdstk::ReferenceType::Cell) {
                    break;
                }

                gdstk::Vec2 min;
                gdstk::Vec2 max;
                cell->reference_array[j]->bounding_box(min, max);

                std::cout << std::setw(4) << j << "/";
                std::cout << std::setw(4) << cell->reference_array.count - 1;
                std::cout << std::setw(36) << cell->reference_array[j]->cell->name;
                std::cout << std::setw(10) << " - BBox: ((" << min.x << ", " << min.y << "), (" << max.x << ", " << max.y << "))";
                std::cout << std::endl;
            }
        }
    }
}

void print_all_properties_of_reference(const gdstk::Reference* reference) {
    gdstk::Property* property = reference->properties;
    while (property != nullptr) {
        std::cout << property->name << std::endl;

        gdstk::PropertyValue* property_value = property->value;
        size_t ctr{0};
        while (property_value) {
            std::cout << ctr << " ";
            switch (property_value->type) {
                case gdstk::PropertyType::UnsignedInteger:
                    std::cout << "<ui>" << property_value->unsigned_integer << std::endl;
                    break;
                case gdstk::PropertyType::Integer:
                    std::cout << "<i>" << property_value->integer << std::endl;
                    break;
                case gdstk::PropertyType::Real:
                    std::cout << "<r>" << property_value->real << std::endl;
                    break;
                case gdstk::PropertyType::String:
                    std::cout << std::string((char*)property_value->bytes);
                    std::cout << "\n" << std::endl;
                    break;
            }
            property_value = property_value->next;
            ++ctr;
        }

        property = property->next;
    }
}

gdstk::Library ParseGDS(const std::string & path){
  double unit = 0;
  double precision = 0;

  gdstk::ErrorCode error_code = gdstk::gds_units(path.c_str(), unit, precision);
  if(error_code != gdstk::ErrorCode::NoError) {exit(EXIT_FAILURE);}


  gdstk::Library lib = read_gds(path.c_str(), unit, precision, nullptr, &error_code);
  if(error_code != gdstk::ErrorCode::NoError) {exit(EXIT_FAILURE);}


  return lib;
}

} // namespace gdstk_utils
