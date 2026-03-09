#include <stdlib.h>
#include <string.h>

#include "swe/swephexp.h"

#ifdef __cplusplus
extern "C" {
#endif

// ------------------------------------------------------------
// Set ephemeris path
// ------------------------------------------------------------
int hm_swe_set_ephe_path(const char* path) {
    if (path == NULL) return -1;
    swe_set_ephe_path(path);
    return 0;
}

// ------------------------------------------------------------
// Longitude only
// ------------------------------------------------------------
int hm_swe_calc_lon_ut(double jd_ut, int planet, double* out_lon_deg) {
    if (out_lon_deg == NULL) return -2;

    double xx[6];
    char serr[256];
    serr[0] = 0;

    int flags = SEFLG_SWIEPH | SEFLG_SPEED;

    int ret = swe_calc_ut(jd_ut, planet, flags, xx, serr);

    if (ret < 0) {
        flags = SEFLG_MOSEPH | SEFLG_SPEED;
        ret = swe_calc_ut(jd_ut, planet, flags, xx, serr);
    }

    if (ret < 0) return -3;

    *out_lon_deg = xx[0];
    return 0;
}

// ------------------------------------------------------------
// Longitude + speed (deg/day)
// ------------------------------------------------------------
int hm_swe_calc_lon_speed_ut(double jd_ut, int planet, double* out_lon, double* out_speed) {
    if (out_lon == NULL || out_speed == NULL) return -2;

    double xx[6];
    char serr[256];
    serr[0] = 0;

    int flags = SEFLG_SWIEPH | SEFLG_SPEED;

    int ret = swe_calc_ut(jd_ut, planet, flags, xx, serr);

    if (ret < 0) {
        flags = SEFLG_MOSEPH | SEFLG_SPEED;
        ret = swe_calc_ut(jd_ut, planet, flags, xx, serr);
    }

    if (ret < 0) return -3;

    *out_lon = xx[0];
    *out_speed = xx[3];  // longitude speed (deg/day)

    return 0;
}

// ------------------------------------------------------------
// Batch planets calculation
// ------------------------------------------------------------
int hm_swe_calc_planets_lon_ut(double jd_ut, const int* planets, int count, double* out_lon) {

    if (planets == NULL || out_lon == NULL) return -2;

    double xx[6];
    char serr[256];

    int flags = SEFLG_SWIEPH | SEFLG_SPEED;

    for (int i = 0; i < count; i++) {

        int p = planets[i];

        int ret = swe_calc_ut(jd_ut, p, flags, xx, serr);

        if (ret < 0) {
            flags = SEFLG_MOSEPH | SEFLG_SPEED;
            ret = swe_calc_ut(jd_ut, p, flags, xx, serr);
        }

        if (ret < 0) return -3;

        out_lon[i] = xx[0];
    }

    return 0;
}

// ------------------------------------------------------------
// Ascendant (kept for compatibility)
// ------------------------------------------------------------
int hm_swe_calc_asc_ut(double jd_ut, double geo_lat, double geo_lon, double* out_asc_deg) {

    if (out_asc_deg == NULL) return -2;

    double cusp[13];
    double ascmc[10];
    char serr[256];

    int hsys = 'P'; // Placidus

    int flags = SEFLG_SWIEPH;

    int ret = swe_houses_ex2(jd_ut, flags, geo_lat, geo_lon, hsys, cusp, ascmc, NULL, NULL, serr);

    if (ret < 0) {
        flags = SEFLG_MOSEPH;
        ret = swe_houses_ex2(jd_ut, flags, geo_lat, geo_lon, hsys, cusp, ascmc, NULL, NULL, serr);
    }

    if (ret < 0) return -3;

    *out_asc_deg = ascmc[0];

    return 0;
}

// ------------------------------------------------------------
// Full Houses Calculation
// out_cusps: array of 13 doubles (index 1 to 12 are houses 1 to 12)
// out_ascmc: array of 10 doubles (index 0=Asc, 1=MC, 2=ARMC, 3=Vertex, etc.)
// ------------------------------------------------------------
int hm_swe_calc_houses_full_ut(double jd_ut, double geo_lat, double geo_lon, int hsys, double* out_cusps, double* out_ascmc) {
    if (out_cusps == NULL || out_ascmc == NULL) return -2;

    char serr[256];
    int flags = SEFLG_SWIEPH;

    int ret = swe_houses_ex2(jd_ut, flags, geo_lat, geo_lon, hsys, out_cusps, out_ascmc, NULL, NULL, serr);

    if (ret < 0) {
        flags = SEFLG_MOSEPH;
        ret = swe_houses_ex2(jd_ut, flags, geo_lat, geo_lon, hsys, out_cusps, out_ascmc, NULL, NULL, serr);
    }

    if (ret < 0) return -3;

    return 0;
}

#ifdef __cplusplus
}
#endif