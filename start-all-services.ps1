Write-Host "=== INICIANDO SISTEMA DE MICROSERVICIOS ===" -ForegroundColor Cyan

Write-Host "`n1. Iniciando Config Service..." -ForegroundColor Yellow
& .\start-config-service.ps1
Start-Sleep -Seconds 10

Write-Host "`n2. Iniciando Eureka Service..." -ForegroundColor Yellow
& .\start-eureka-service.ps1
Start-Sleep -Seconds 15

Write-Host "`n3. Iniciando Usuario Service..." -ForegroundColor Yellow
& .\start-usuario-service.ps1
Start-Sleep -Seconds 10

Write-Host "`n4. Iniciando Carro Service..." -ForegroundColor Yellow
& .\start-carro-service.ps1
Start-Sleep -Seconds 10

Write-Host "`n5. Iniciando Moto Service..." -ForegroundColor Yellow
& .\start-moto-service.ps1
Start-Sleep -Seconds 10

Write-Host "`n=== TODOS LOS SERVICIOS INICIADOS ===" -ForegroundColor Green
Write-Host "Config Service: http://localhost:8081" -ForegroundColor White
Write-Host "Eureka Server: http://localhost:8761" -ForegroundColor White
Write-Host "Usuario Service: http://localhost:8001" -ForegroundColor White
Write-Host "Carro Service: http://localhost:8002" -ForegroundColor White
Write-Host "Moto Service: http://localhost:8003" -ForegroundColor White

Write-Host "`nEsperando 30 segundos para que todos los servicios se registren..." -ForegroundColor Cyan
Start-Sleep -Seconds 30

Write-Host "`nVerificando estado de Eureka..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761" -UseBasicParsing -TimeoutSec 5
    Write-Host "✓ Eureka Server está ejecutándose" -ForegroundColor Green
    
    # Contar instancias registradas
    $appsResponse = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -UseBasicParsing -TimeoutSec 5
    $content = $appsResponse.Content
    $instanceCount = ([regex]::Matches($content, "<instance>")).Count
    Write-Host "✓ Instancias registradas en Eureka: $instanceCount" -ForegroundColor Green
    
    if ($instanceCount -gt 0) {
        Write-Host "`nAplicaciones registradas:" -ForegroundColor Cyan
        $content | Select-String -Pattern "<name>(.*?)</name>" | ForEach-Object {
            $appName = $_.Matches[0].Groups[1].Value
            Write-Host "  - $appName" -ForegroundColor White
        }
    }
} catch {
    Write-Host "✗ Error al verificar Eureka: $($_.Exception.Message)" -ForegroundColor Red
}
