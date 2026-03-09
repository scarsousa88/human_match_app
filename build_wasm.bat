@echo off
set EMSDK_PATH=C:\Users\o.pinto\emsdk
set PROJECT_ROOT=%~dp0
set CPP_DIR=%PROJECT_ROOT%android\app\src\main\cpp
set ASSETS_DIR=%PROJECT_ROOT%assets\ephe

echo [1/3] Ativando Emscripten...
call %EMSDK_PATH%\emsdk_env.bat

echo [2/3] Entrando na pasta C++...
cd /d %CPP_DIR%

echo [3/3] Compilando para WebAssembly...

:: Verifica se a pasta de assets existe e tem ficheiros
dir /b /a-d "%ASSETS_DIR%" | findstr /R "." >nul
if %errorlevel% neq 0 (
    echo [AVISO] Pasta assets\ephe vazia ou inexistente. Compilando sem preload.
    set PRELOAD_CMD=
) else (
    echo [INFO] Ficheiros encontrados em assets\ephe. Ativando preload.
    set PRELOAD_CMD=--preload-file ..\..\..\..\..\assets\ephe@/assets/ephe
)

:: Removidos swevents.c e swephgen4.c pois causam erro de 'duplicate symbol: main'
call emcc ^
  swe_wrapper_wasm.c ^
  swe\swecl.c swe\swedate.c swe\swehel.c swe\swehouse.c swe\swejpl.c ^
  swe\swemmoon.c swe\swemplan.c swe\sweph.c swe\swephlib.c ^
  swe\sweephe4.c ^
  -I. -Iswe ^
  -s WASM=1 ^
  -s MODULARIZE=1 ^
  -s EXPORT_NAME="Module" ^
  -s EXPORTED_FUNCTIONS="['_hm_swe_set_ephe_path','_hm_swe_calc_lon_ut_wasm','_hm_swe_calc_asc_ut_wasm','_malloc','_free']" ^
  -s EXPORTED_RUNTIME_METHODS="['ccall','cwrap']" ^
  -s ALLOW_MEMORY_GROWTH=1 ^
  %PRELOAD_CMD% ^
  -o ..\..\..\..\..\web\swisseph.js

echo.
if %errorlevel% neq 0 (
    echo [ERRO] A compilacao falhou. Verifique as mensagens acima.
) else (
    echo [SUCESSO] swisseph.js e swisseph.wasm gerados em /web/
)
pause
