#include "p3_functions_back_to_cell_average_impl.hpp"
#include "share/scream_types.hpp"

namespace scream {
namespace p3 {

/*
 * Explicit instantiation for translating quantities to cell averages using the
 * default device.
 */

template struct Functions<Real,DefaultDevice>;

} // namespace p3
} // namespace scream
