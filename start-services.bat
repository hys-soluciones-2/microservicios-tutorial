@echo off
echo === INICIANDO SISTEMA DE MICROSERVICIOS ===

echo Limpiando procesos Java existentes...
taskkill /f /im java.exe >nul 2>&1
timeout /t 3 /nobreak >nul

echo.
echo 1. Iniciando Eureka Service...
start "Eureka Service" cmd /k "cd Eureka_Service && mvn spring-boot:run"
timeout /t 30 /nobreak >nul

echo.
echo 2. Iniciando Usuario Service...
start "Usuario Service" cmd /k "cd usuario-microservice && mvn spring-boot:run"
timeout /t 15 /nobreak >nul

echo.
echo 3. Iniciando Carro Service...
start "Carro Service" cmd /k "cd CarroMicroservicio && mvn spring-boot:run"
timeout /t 15 /nobreak >nul

echo.
echo 4. Iniciando Moto Service...
start "Moto Service" cmd /k "cd motoMicroservicio && mvn spring-boot:run"
timeout /t 15 /nobreak >nul

echo.
echo Esperando 30 segundos para que todos los servicios se registren...
timeout /t 30 /nobreak >nul

echo.
echo === VERIFICANDO SERVICIOS ===
echo Eureka Server: http://localhost:8761
echo Usuario Service: http://localhost:8001
echo Carro Service: http://localhost:8002
echo Moto Service: http://localhost:8003

echo.
echo === SISTEMA INICIADO ===
echo Puedes verificar Eureka en: http://localhost:8761
echo.
pause
