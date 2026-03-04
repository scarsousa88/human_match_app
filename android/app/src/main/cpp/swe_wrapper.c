#include <stdlib.h>
#include <string.h>

#include "swe/swephexp.h"

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
int hm_swe_calc_lon_ut(double jd_ut, int planet, double* out_lon_deg) {
    if (out_lon_deg == NULL) return -2;

    double xx[6];
    char serr[256];
    serr[0] = 0;

    // Tenta usar Swiss Ephemeris (precisa de ficheiros)
    int flags = SEFLG_SWIEPH | SEFLG_SPEED;
    int ret = swe_calc_ut(jd_ut, planet, flags, xx, serr);

    if (ret < 0) {
        // Fallback automático para Moshier (não precisa de ficheiros)
        flags = SEFLG_MOSEPH | SEFLG_SPEED;
        ret = swe_calc_ut(jd_ut, planet, flags, xx, serr);
    }

    if (ret < 0) {
        return -3; // Erro fatal
    }

    *out_lon_deg = xx[0];
    return 0;
}

// Calculate Ascendant (ecliptic longitude degrees) at Julian Day UT for given geo coords.
// Uses houses calculation. Returns ASC in out_asc_deg (0..360).
int hm_swe_calc_asc_ut(double jd_ut, double geo_lat, double geo_lon, double* out_asc_deg) {
    if (out_asc_deg == NULL) return -2;

    double cusp[13];
    double ascmc[10];
    char serr[256];
    serr[0] = 0;

    // Placidus (padrão “mais comum” em apps). Podes trocar para 'W' (Whole Sign) etc.
    int hsys = 'P';

    // Tenta com SWIEPH; se falhar, tenta MOSEPH.
    int flags = SEFLG_SWIEPH;
    int ret = swe_houses_ex2(jd_ut, flags, geo_lat, geo_lon, hsys, cusp, ascmc, NULL, NULL, serr);

    if (ret < 0) {
        flags = SEFLG_MOSEPH;
        ret = swe_houses_ex2(jd_ut, flags, geo_lat, geo_lon, hsys, cusp, ascmc, NULL, NULL, serr);
    }

    if (ret < 0) {
        return -3;
    }

    // ascmc[0] = Ascendant
    *out_asc_deg = ascmc[0];
    return 0;
}

#ifdef __cplusplus
}
#endif