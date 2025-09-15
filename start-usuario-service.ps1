Write-Host "Iniciando Usuario Service..." -ForegroundColor Green
cd usuario-microservice
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run"
cd ..
