Write-Host "Iniciando Eureka Service..." -ForegroundColor Green
cd Eureka_Service
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run"
cd ..
