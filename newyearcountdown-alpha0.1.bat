@echo off
setlocal enabledelayedexpansion

:start
:: Fungsi untuk menghitung jumlah hari dalam bulan
set "days_in_month[1]=31"
set "days_in_month[2]=28"
set "days_in_month[3]=31"
set "days_in_month[4]=30"
set "days_in_month[5]=31"
set "days_in_month[6]=30"
set "days_in_month[7]=31"
set "days_in_month[8]=31"
set "days_in_month[9]=30"
set "days_in_month[10]=31"
set "days_in_month[11]=30"
set "days_in_month[12]=31"

:loop
cls
:: Ambil tanggal dan waktu saat ini
for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
    set tanggal_sekarang=%%a
    set bulan_sekarang=%%b
    set tahun_sekarang=%%c
)

for /f "tokens=1-3 delims=:,." %%a in ("%time%") do (
    set jam_sekarang=%%a
    set menit_sekarang=%%b
    set detik_sekarang=%%c
)

:: Hilangkan leading zero pada tanggal, bulan, dan waktu
set /a tanggal_sekarang=1%tanggal_sekarang%-100
set /a bulan_sekarang=1%bulan_sekarang%-100
set /a tahun_sekarang=%tahun_sekarang%+0
set /a jam_sekarang=1%jam_sekarang%-100
set /a menit_sekarang=1%menit_sekarang%-100
set /a detik_sekarang=1%detik_sekarang%-100

:: Tambahkan kembali leading zero untuk jam, menit, dan detik jika diperlukan
if %jam_sekarang% lss 10 set jam_sekarang=0%jam_sekarang%
if %menit_sekarang% lss 10 set menit_sekarang=0%menit_sekarang%
if %detik_sekarang% lss 10 set detik_sekarang=0%detik_sekarang%

:: Hitung apakah tahun adalah kabisat
set /a is_leap_year=0
set /a leap_div4=%tahun_sekarang% %% 4
set /a leap_div100=%tahun_sekarang% %% 100
set /a leap_div400=%tahun_sekarang% %% 400

if %leap_div4%==0 (
    if %leap_div100%==0 (
        if %leap_div400%==0 (
            set /a is_leap_year=1
        ) else (
            set /a is_leap_year=0
        )
    ) else (
        set /a is_leap_year=1
    )
) else (
    set /a is_leap_year=0
)

if %is_leap_year%==1 set "days_in_month[2]=29"

:: Hitung total hari dari tanggal sistem hingga akhir tahun
set /a total_days_current_year=0
for /l %%m in (%bulan_sekarang%,1,12) do (
    set /a total_days_current_year+=!days_in_month[%%m]!
)
set /a total_days_current_year-=%tanggal_sekarang%

:: Menghitung sisa waktu (jam, menit, detik) hingga akhir hari
set /a sisa_jam=23-%jam_sekarang%
set /a sisa_menit=59-%menit_sekarang%
set /a sisa_detik=59-%detik_sekarang%

:: Tambahkan leading zero untuk sisa waktu juga
if %sisa_jam% lss 10 set sisa_jam=0%sisa_jam%
if %sisa_menit% lss 10 set sisa_menit=0%sisa_menit%
if %sisa_detik% lss 10 set sisa_detik=0%sisa_detik%

:: Total jam, menit, dan detik yang tersisa hingga akhir tahun
set /a total_jam=total_days_current_year*24+sisa_jam
set /a total_menit=total_jam*60+sisa_menit
set /a total_detik=total_menit*60+sisa_detik

:: Tampilkan hasil dengan dekorasi
echo =================================================
echo               NEW YEAR COUNTDOWN                 
echo =================================================
echo.
echo Sisa waktu:
echo %total_days_current_year% Day(s)
echo %sisa_jam% Hour(s)
echo %sisa_menit% Minute(s)
echo %sisa_detik% Second(s)
echo.
echo Total hour(s) until end of year: %total_jam%
echo Total minute(s) until end of year: %total_menit%
echo Total second(s) until end of year: %total_detik%
echo.
echo =================================================
echo.
echo According to www.timeanddate.com
:: Tunggu selama 1 detik sebelum memperbarui lagi
timeout /t 1 /nobreak >nul

goto loop