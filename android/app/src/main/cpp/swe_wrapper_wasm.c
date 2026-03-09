#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#else
#define EMSCRIPTEN_KEEPALIVE
#endif

#include <stdlib.h>
#include "swe/swephexp.h"

#if defined(__GNUC__) || defined(__clang__)
#define USED __attribute__((used))
#else
#define USED
#endif

// Forçar a exportação das funções para o JS
EMSCRIPTEN_KEEPALIVE USED
void hm_swe_set_ephe_path(const char* path) {
    swe_set_ephe_path((char*)path);
}

EMSCRIPTEN_KEEPALIVE USED
double hm_swe_calc_lon_ut_wasm(double jd_ut, int planet) {
    double xx[6];
    char serr[256];
    int flags = SEFLG_SWIEPH | SEFLG_SPEED;
    if (swe_calc_ut(jd_ut, planet, flags, xx, serr) < 0) {
        swe_calc_ut(jd_ut, planet, SEFLG_MOSEPH | SEFLG_SPEED, xx, serr);
    }
    return xx[0];
}

EMSCRIPTEN_KEEPALIVE USED
double hm_swe_calc_asc_ut_wasm(double jd_ut, double lat, double lon) {
    double cusp[13], ascmc[10];
    char serr[256];
    int flags = SEFLG_SWIEPH;
    if (swe_houses_ex2(jd_ut, flags, lat, lon, 'P', cusp, ascmc, NULL, NULL, serr) < 0) {
        swe_houses_ex2(jd_ut, SEFLG_MOSEPH, lat, lon, 'P', cusp, ascmc, NULL, NULL, serr);
    }
    return ascmc[0];
}
