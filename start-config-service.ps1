Write-Host "Iniciando Config Service..." -ForegroundColor Green
cd Config-Service
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run"
cd ..
