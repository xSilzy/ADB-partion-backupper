@echo off
chcp 65001 >NUL
setlocal enabledelayedexpansion

if exist "%~dp0adb.exe" (
    echo ✅¦ adb.exe found
) else (
    pause | echo ❌¦ adb.exe not found, please move the file into the same directory as your Android Debug Bridge installation.
	goto end 
)

cls

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmm"') do set dt=%%i

set date=!dt:~0,4!.!dt:~4,2!.!dt:~6,2!
set time=!dt:~9,2!!dt:~11,2!

set backup_name=backup_!date!_!time!

set /P C=Enter the full directory path for the backup:

set fileDir[boot_a]=
set fileDir[boot_b]=
set fileDir[init_boot_a]=
set fileDir[init_boot_b]=
set fileDir[vendor_boot_a]=
set fileDir[vendor_boot_b]=
set fileDir[vendor_kernel_boot_a]=
set fileDir[vendor_kernel_boot_b]=
set fileDir[super]=
set fileDir[userdata]=
set fileDir[efs]=
set fileDir[efs_backup]=

echo.
echo ========================================
echo 💾 Preparing Android Partition Backup...
echo ========================================
echo.

for /f "delims=" %%a in ('adb shell getprop ro.boot.slot_suffix') do set currentPartion=%%a
echo Current Partition: %currentPartion%.


echo 📂¦ Creating backup folder...
mkdir %C%\%backup_name%
echo 🔍¦ Locating img directories...
adb shell ls -la /dev/block/by-name > "%C%\%backup_name%\temp.txt"

if %currentPartion% == _a (
	for /f "skip=1 delims=" %%G IN (%C%\%backup_name%\temp.txt) DO (
		for %%i in (boot_a init_boot_a vendor_boot_a vendor_kernel_boot_a super userdata efs efs_backup) do (
			echo "%%G" | findstr /r /c:" %%i " >nul && (
				for /f "tokens=2 delims=>" %%H IN ("!%%G!") DO (
					for /f "tokens=1,2,3 delims= " %%J IN ("%%H") DO (
						echo ✅¦ %%i = %%J
						set fileDir[%%i]=%%J
					)
				)
			)
		)
	)
) else (
	if %currentPartion% == _b (
		for /f "skip=1 delims=" %%G IN (%C%\%backup_name%\temp.txt) DO (
			for %%i in (boot_b init_boot_b vendor_boot_b vendor_kernel_boot_b super userdata efs efs_backup) do (
				echo "%%G" | findstr /r /c:" %%i " >nul && (
					for /f "tokens=2 delims=>" %%H IN ("!%%G!") DO (
						for /f "tokens=1,2,3 delims= " %%J IN ("%%H") DO (
							echo ✅¦ %%i = %%J
							set fileDir[%%i]=%%J
						)
					)
				)
			 )
		)
	)
)

cls
echo.
echo ========================================
echo 💾 Starting Android Partition Backup...
echo ========================================
echo.

echo 📂¦ Backing up to %C%\%backup_name%

if %currentPartion% == _a (
	for %%i in (boot_a init_boot_a vendor_boot_a vendor_kernel_boot_a super userdata efs efs_backup) do (
	echo ⏳¦ Backing up %%i...
	adb exec-out su -c "dd if='!fileDir[%%i]!'" > "%C%\%backup_name%\%%i.img"
	for %%S in ("%C%\%backup_name%\%%i.img") do set "size=%%~zS"
		if "!size!" == "0" (
			echo ❌¦ ERROR: %%i failed to backup.
		) else (
			echo ✅¦ %%i backed up successfully.
		)
		echo.

	)
) else (
	if %currentPartion% == _b (
		for %%i in (boot_b init_boot_b vendor_boot_b vendor_kernel_boot_b super userdata efs efs_backup) do (
		echo ⏳¦ Backing up %%i...
		adb exec-out su -c "dd if='!fileDir[%%i]!'" > "%C%\%backup_name%\%%i.img"
		
		for %%S in ("%C%\%backup_name%\%%i.img") do set "size=%%~zS"
			if "!size!" == "0" (
				echo ❌¦ ERROR: %%i failed to backup.
			) else (
				echo ✅¦ %%i backed up successfully.
			)
			echo.
		
		)
	)
)

echo 🧹¦ cleaning up | if exist "%C%\%backup_name%\temp.txt" del "%C%\%backup_name%\temp.txt" >nul 2>&1
pause | echo ✅¦ Process finished...
:end