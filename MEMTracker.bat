@echo off
title Memory Usage Tracker
setlocal enabledelayedexpansion

:: Pobierz aktualną datę i czas z sekundami
for /f "skip=1" %%a in ('wmic os get localdatetime') do (
    set currentDateTime=%%a
    goto :break
)
:break

:: Zmiana formatu daty i czasu do użycia w nazwie pliku
set fileNameTime=!currentDateTime:~0,4!!currentDateTime:~4,2!!currentDateTime:~6,2!_!currentDateTime:~8,2!!currentDateTime:~10,2!!currentDateTime:~12,2!

:: Użyj zmiennej do tworzenia pliku logu
set logFileName=memory_usage_!fileNameTime!.txt

:: Utwórz lub wyczyść plik tekstowy do logowania wyników
echo Memory Usage Log > !logFileName!
echo ================== >> !logFileName!

:loop
:: Zainicjalizuj zmienną do sumowania pamięci
set totalMemory=0

:: Pobierz aktualną datę i czas z sekundami
for /f "skip=1" %%a in ('wmic os get localdatetime') do (
    set currentDateTime=%%a
    goto :break2
)
:break2

:: Sformatuj ciąg daty i czasu
set currentDate=!currentDateTime:~0,8!
set currentTime=!currentDateTime:~8,6!
:: Wyświetl komunikat
echo Calculating total memory usage by all processes...
echo.

:: Użyj tasklist do pobrania listy procesów i ich zużycia pamięci
for /f "skip=3 tokens=1,2 delims=," %%a in ('tasklist /FO CSV ^| findstr /V "INFO"') do (
    set /a memUsage=%%b
    set /a totalMemory+=memUsage
)

:: Przekonwertuj zużycie pamięci na MB
set /a totalMemoryMB=totalMemory / 1024

:: Wyświetl wynik
echo Total memory usage as of YYYYMMDD: !currentDate! HHMMSS: !currentTime! MemUsage: !totalMemoryMB! MB

:: Dodaj wynik do pliku tekstowego
echo Total memory usage as of YYYYMMDD: !currentDate! HHMMSS: !currentTime! MemUsage: !totalMemoryMB! MB >> !logFileName!

:: Czekaj 5 sekund przed powtórzeniem
timeout /t 5 /nobreak > nul
goto loop
