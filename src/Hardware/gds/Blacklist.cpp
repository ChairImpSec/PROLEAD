#include "Hardware/gds/Blacklist.hpp"

/**
 * @brief Constructor for Blacklist.
 */
Blacklist::Blacklist(std::initializer_list<std::string>l ) : elements(l) {}
Blacklist::Blacklist() : elements() {}

/**
 * @brief Check if a gate name is in the blacklist.
 */
bool Blacklist::IsInBlacklist(const std::string &name) const {
    return elements.find(name) != elements.end();
}

Gates Blacklist::FilterGates(const gdstk::Library &lib,
                              const std::string & top_level_name) const{

  Gates gates;
  gdstk::Cell * top_module = lib.get_cell(top_level_name.c_str());


  for (size_t i = 0; i < top_module->reference_array.count; ++i) {
    gdstk::Reference * reference = top_module->reference_array[i];

    if(reference->type == gdstk::ReferenceType::Cell){

      if(!Blacklist::IsInBlacklist(std::string(reference->cell->name))){
        // util::print_all_properties_of_reference(reference);

        gates.push_back(Gate::CreateGateFromReference(reference));
        // std::cout << gates.back() << std::endl;
      }
    }
  }

  return gates;
}

Blacklist& Blacklist::operator+=(Blacklist & rhs)& {
  this->elements.merge(rhs.elements);
  return *this;
}

Blacklist operator+(Blacklist lhs, Blacklist & rhs) {
  lhs += rhs;
  return lhs;
}

/**
 * @brief Operator << for Blacklist.
 */
std::ostream& operator<<(std::ostream &out, Blacklist const& blacklist) {
    for (const auto& element : blacklist.elements) {
        out << element << std::endl;
    }
    return out;
}
