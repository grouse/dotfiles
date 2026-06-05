@echo off
setlocal enabledelayedexpansion

:: ============================================================
:: configure.bat — configuration-only port of install.sh
:: Requires Administrator privileges (or Developer Mode) for
:: mklink to work without elevation.
:: ============================================================

if "%~1"=="" (
    echo Usage: %~0 all ^| [-p^|--package ^<name^>]...
    exit /b 1
)

set "ROOT=%~dp0"
:: Strip trailing backslash
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"

set "HOME_DIR=%USERPROFILE%"

:: Neovim on Windows uses %LOCALAPPDATA%\nvim
set "NVIM_CONFIG=%LOCALAPPDATA%\nvim"

:: ---- Collect packages ----------------------------------------
set "PACKAGES="

if /i "%~1"=="all" (
    set "PACKAGES=git neovim"
    goto :configure
)

:parse_args
if "%~1"=="" goto :configure
if /i "%~1"=="-p" (
    set "PACKAGES=!PACKAGES! %~2"
    shift
    shift
    goto :parse_args
)
if /i "%~1"=="--package" (
    set "PACKAGES=!PACKAGES! %~2"
    shift
    shift
    goto :parse_args
)
set "PACKAGES=!PACKAGES! %~1"
shift
goto :parse_args

:: ---- Helper: create a symlink --------------------------------
:: Usage: call :symlink <link_path> <target_path>
:: Uses /D for directories, file symlink otherwise.
:symlink
    set "_target=%~1"
    set "_link=%~2"
    if exist "%_target%\" (
        echo mklink /D "%_link%" "%_target%"
        if exist "%_link%" ( rmdir "%_link%" 2>nul )
        mklink /D "%_link%" "%_target%"
    ) else (
        echo mklink "%_link%" "%_target%"
        if exist "%_link%" ( del /f /q "%_link%" 2>nul )
        mklink "%_link%" "%_target%"
    )
    exit /b 0

:: ---- Configuration -------------------------------------------
:configure

for %%P in (%PACKAGES%) do (
    if /i "%%P"=="neovim" (
        call :symlink "%ROOT%\neovim" "%NVIM_CONFIG%"
    )
    if /i "%%P"=="git" (
        echo git config --global merge.tool meld
        git config --global merge.tool meld
        echo git config --global pull.rebase true
        git config --global pull.rebase true
        echo git config --global init.defaultBranch main
        git config --global init.defaultBranch main
        echo git config --global url.ssh://git@github.com/.insteadOf https://github.com/
        git config --global url.ssh://git@github.com/.insteadOf https://github.com/
    )
)

echo.
echo Configuration complete.
endlocal
