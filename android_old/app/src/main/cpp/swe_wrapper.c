#include <stdlib.h>
#include <string.h>

#include "swe/swephexp.h"

// Define flags: ephemeris + tropical + longitude/latitude + speed
// (vamos começar pelo básico: longitude)
#define SEFLG_BASIC (SEFLG_SWIEPH | SEFLG_SPEED)

#ifdef __cplusplus
extern "C" {
#endif

// Set ephemeris path (directory where .se1 files are)
int hm_swe_set_ephe_path(const char* path) {
    if (path == NULL) return -1;
    swe_set_ephe_path(path);
    return 0;
}

// Calculate ecliptic longitude (degrees) for a given planet at Julian Day UT
// planet: SwissEph planet id (e.g., SE_SUN, SE_MOON, etc.)
int hm_swe_calc_lon_ut(double jd_ut, int planet, double* out_lon_deg) {
    if (out_lon_deg == NULL) return -2;

    double xx[6];
    char serr[256];
    serr[0] = 0;

    int flags = SEFLG_BASIC;

    int ret = swe_calc_ut(jd_ut, planet, flags, xx, serr);
    if (ret < 0) {
        return -3; // error
    }

    // xx[0] = ecliptic longitude in degrees
    *out_lon_deg = xx[0];
    return 0;
}

#ifdef __cplusplus
}
#endif