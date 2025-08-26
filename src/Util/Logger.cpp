#include "Util/Logger.hpp"

std::ostream& operator<<(std::ostream& os, const TableCell& cell) {
  if (cell.content_.size() > cell.width_) {
    throw std::runtime_error("TableCell content size exceeds corresponding width.");
  } else {
    os << std::setw(cell.width_) << cell.content_;
    return os;
  }
}

TableCell::TableCell(std::string content, uint64_t width){
  this->content_ = content;
  if(content_.size() < width) {
    std::string withespaces(width-content.size(), ' ');
    this->content_.insert(0, withespaces);
  }
  this->width_ = this->content_.size();
}

Logger::Logger(uint64_t padding_length, uint64_t max_width, uint64_t normal_width) :
  padding_(std::string(padding_length, ' ')), max_width_(max_width), normal_width_(normal_width){}

TableCell Logger::GetMemoryCell(uint64_t mem_in_kb, uint64_t width){
  uint64_t bytes = mem_in_kb * 1024ULL;

  constexpr std::uint64_t BYTES_PER_TB = 1'000'000'000'000ULL;
  constexpr std::uint64_t BYTES_PER_GB = 1'000'000'000ULL;
  constexpr std::uint64_t BYTES_PER_MB = 1'000'000ULL;

  std::uint64_t tb = bytes / BYTES_PER_TB;
  bytes          %= BYTES_PER_TB;

  std::uint64_t gb = bytes / BYTES_PER_GB;
  bytes          %= BYTES_PER_GB;

  std::uint64_t mb = bytes / BYTES_PER_MB;

  std::ostringstream oss;
  oss << std::setw(3) << tb << "TB "
      << std::setw(4) << gb << "GB "
      << std::setw(3) << std::setfill('0') << mb << "MB";
  return TableCell(oss.str(), width);
}

TableCell Logger::GetTimeCell(const double & seconds_total, uint64_t width){
  uint64_t total = static_cast<uint64_t>(seconds_total + 0.5);
  uint64_t days = total / 86'400;
  total %= 86'400;

  uint64_t hours = total / 3'600;
  total %= 3'600;

  uint64_t mins = total / 60;
  uint64_t secs = total % 60;

  std::ostringstream oss;
  oss << std::setw(3) << days << "-"
    << std::setw(2) << std::setfill('0') << hours << ":"
    << std::setw(2) << std::setfill('0') << mins << ":"
    << std::setw(2) << std::setfill('0') << secs;

  return TableCell(oss.str(), width);
}

uint64_t Logger::DetermineRowWidth(const std::vector<TableCell>& row){
  uint64_t width = 1;
  for (const TableCell& cell : row) {
    width += cell.width_ + (2*this->padding_.size()) + 1;
  }
  return width;
}

void Logger::PrintRow(const std::vector<TableCell>& row) {
  std::ostringstream oss;
  oss << "|";
  for (const TableCell &cell : row) {
      oss << padding_ << cell << padding_ << "|";
  }
  BOOST_LOG_TRIVIAL(info) << oss.str();
}

void Logger::PrintRowWithSeparation(const std::vector<TableCell>& row, bool spacing) {
  Logger::PrintRow(row);
  const uint64_t width = Logger::DetermineRowWidth(row);
  Logger::PrintHorizontalTableLine(width, spacing);
}

void Logger::PrintHeader(const std::vector<TableCell>& row){
  const uint64_t width = Logger::DetermineRowWidth(row);
  Logger::PrintHorizontalTableLine(width);
  Logger::PrintRow(row);
  Logger::PrintHorizontalTableLine(width);
}

void Logger::PrintHorizontalTableLine(uint64_t width, bool spacing) {
  if (!spacing) {
    BOOST_LOG_TRIVIAL(info) << std::string(width,'-');
  } else {
    BOOST_LOG_TRIVIAL(info) << std::string(width,'-') << "\n";
  }
}

void Logger::PrintInitialMessage(const std::string& message){
  Logger::PrintMajorRule();
  BOOST_LOG_TRIVIAL(info) << message;
}

void Logger::PrintFinalMessage(const std::string& message){
  BOOST_LOG_TRIVIAL(info) << message;
  Logger::PrintMajorRule();
}

void Logger::PrintInfoMessage(const std::string& message){
  BOOST_LOG_TRIVIAL(info) << message;
}

void Logger::PrintMajorRule(){
  BOOST_LOG_TRIVIAL(info) << std::string(this->max_width_, '-');
}

void Logger::PrintMinorRule(){
  BOOST_LOG_TRIVIAL(info) << std::string(this->normal_width_, '-');
}

void Logger::InitLogging(){
  boost::log::add_common_attributes();
  boost::log::add_console_log(
    std::clog,
    boost::log::keywords::format =
      boost::log::expressions::stream
        << "[" << boost::log::expressions::format_date_time<boost::posix_time::ptime>(
          "TimeStamp", "%Y-%m-%d %H:%M:%S") << "] "
        // NOTE:: uncomment to get default behavior
        // << "[" << boost::log::expressions::attr<boost::log::attributes::current_thread_id::value_type>("ThreadID") << "] "
        // << "[" << boost::log::trivial::severity << "] "
        << boost::log::expressions::smessage
  );
  boost::log::core::get()->set_filter(boost::log::trivial::severity >= boost::log::trivial::info);
}
