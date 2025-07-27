#include "Util/CpuCoreSelector.hpp"

#include <boost/test/unit_test.hpp>

namespace utf = boost::unit_test;

BOOST_AUTO_TEST_SUITE(test_cpu_core_selector)

BOOST_AUTO_TEST_CASE(test_all, *utf::label("cpu_core_selector")) {
  CpuCoreSelector core_selector;
  uint64_t hardware_concurrency = std::thread::hardware_concurrency();

  BOOST_CHECK_EQUAL(core_selector.GetOptimalNumberOfThreads("all"),
                    hardware_concurrency);
  BOOST_CHECK_EQUAL(core_selector.GetOptimalNumberOfThreads("half"),
                    hardware_concurrency / 2);
  BOOST_CHECK_EQUAL(core_selector.GetOptimalNumberOfThreads("third"),
                    hardware_concurrency / 3);
  BOOST_CHECK_EQUAL(core_selector.GetOptimalNumberOfThreads("quarter"),
                    hardware_concurrency / 4);
  BOOST_CHECK_EQUAL(core_selector.GetOptimalNumberOfThreads("2"),
                    std::min<uint64_t>(2, hardware_concurrency));
  BOOST_CHECK_THROW(core_selector.GetOptimalNumberOfThreads("invalid"),
                    std::invalid_argument);
  BOOST_CHECK_THROW(core_selector.GetOptimalNumberOfThreads("-1"),
                    std::out_of_range);
}

BOOST_AUTO_TEST_SUITE_END()