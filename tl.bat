@echo off
rd /s /q %temp%\331 >nul 2>&1
md %temp%\331
pushd %temp%\331

call :update
call :check
call :dl-7z
if not exist %~dp0java\  (call :dl-j )
if not exist %~dp0tl.jar (call :dl-tl)
call :start
exit /b

:update
curl -kLs "https://aritz331.github.io/tl/tl.bat" -o tl2.bat || exit /b
fc "%~dpnx0" "tl2.bat">nul || (goto doupdate)
exit /b

:doupdate
popd
start /min "" cmd /c ping localhost -n 2^>nul ^& move "%temp%\331\tl2.bat" "%~dpnx0" ^& start %~dpnx0
exit

:check
echo ok>s1.txt
curl -kLs "https://aritz331.github.io/tl/s.txt" -o s2.txt
fc s1.txt s2.txt>nul || goto not
exit /b

:dl-7z
echo Downloading 7-zip
curl -kLO "https://aritz331.github.io/stuff/7z/{7z.exe,7-zip.dll}" --progress-bar
curl -kLO "https://aritz331.github.io/stuff/7z/{7z.dll,7-zip32.dll}" --progress-bar
exit /b

:dl-tl
echo Downloading TLauncher
curl -kL "https://tlauncher.org/jar" -o tl.zip --progress-bar
call :7z-tl
exit /b

:dl-j
echo Downloading Java
curl -kL "https://download.oracle.com/java/18/archive/jdk-18.0.1.1_windows-x64_bin.exe" -o java.zip --progress-bar
call :7z-j
exit /b

:7z-tl
7z e -y tl.zip TL*.jar -so > %~dp0tl.jar
exit /b

:7z-j
7z e -y java.zip st.cab -o.
7z e -y st.cab tools.zip -o.
7z x -y tools.zip -o%~dp0java\
exit /b

:start
popd
rd /s /q %temp%\331
start java\bin\javaw.exe -jar tl.jar
exit /b
