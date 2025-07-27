
#pragma once

#include <string>
#include "gdstk/library.hpp"
#include "gdstk/reference.hpp"

/**
 * @brief Namespace for utilities related to GDSTK library
 */
namespace util {

/**
 * @brief Prints all cells in a given GDSTK library.
 *
 * @param lib The GDSTK library.
 */
void print_all_cells(const gdstk::Library& lib);

/**
 * @brief Prints all references for the top-level cell in a GDSTK library.
 *
 * @param lib The GDSTK library.
 * @param top_level_name Name of the top-level cell to be printed.
 */
void print_all_references(const gdstk::Library& lib, const std::string top_level_name);

/**
 * @brief Prints all properties of a given GDSTK reference.
 *
 * @param reference The GDSTK reference.
 */
void print_all_properties_of_reference(const gdstk::Reference* reference);


gdstk::Library ParseGDS(const std::string & path);
} // utils
