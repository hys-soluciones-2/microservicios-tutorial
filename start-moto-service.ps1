Write-Host "Iniciando Moto Service..." -ForegroundColor Green
cd motoMicroservicio
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run"
cd ..
