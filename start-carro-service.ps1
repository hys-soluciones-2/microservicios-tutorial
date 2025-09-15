Write-Host "Iniciando Carro Service..." -ForegroundColor Green
cd CarroMicroservicio
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run"
cd ..
