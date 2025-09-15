Write-Host "=== INICIANDO SOLO EUREKA SERVER ===" -ForegroundColor Cyan

# Terminar cualquier proceso Java existente
Write-Host "Terminando procesos Java existentes..." -ForegroundColor Yellow
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Esperar un momento
Start-Sleep -Seconds 3

# Iniciar Eureka Service
Write-Host "Iniciando Eureka Service..." -ForegroundColor Green
Set-Location "Eureka_Service"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run" -WindowStyle Normal

# Esperar a que Eureka se inicie
Write-Host "Esperando 30 segundos para que Eureka se inicie..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Verificar Eureka
Write-Host "Verificando Eureka..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761" -UseBasicParsing -TimeoutSec 5
    Write-Host "✓ EUREKA SERVER ESTÁ FUNCIONANDO EN PUERTO 8761" -ForegroundColor Green
    Write-Host "Puedes acceder a: http://localhost:8761" -ForegroundColor White
} catch {
    Write-Host "✗ Eureka no está funcionando. Error: $($_.Exception.Message)" -ForegroundColor Red
}

Set-Location ".."
