Write-Host "=== VERIFICACIÓN FINAL DEL SISTEMA ===" -ForegroundColor Cyan

# Verificar puertos
$services = @{
    8761 = "Eureka Service"
    8001 = "Usuario Service" 
    8002 = "Carro Service"
    8003 = "Moto Service"
}

Write-Host "`nVerificando servicios..." -ForegroundColor Yellow
foreach ($port in $services.Keys) {
    try {
        $connection = New-Object System.Net.Sockets.TcpClient
        $connection.Connect("localhost", $port)
        $connection.Close()
        Write-Host "✓ $($services[$port]) ejecutándose en puerto $port" -ForegroundColor Green
    } catch {
        Write-Host "✗ $($services[$port]) NO ejecutándose en puerto $port" -ForegroundColor Red
    }
}

# Verificar Eureka específicamente
Write-Host "`n=== VERIFICANDO EUREKA ===" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761" -UseBasicParsing -TimeoutSec 5
    Write-Host "✓ Eureka Server respondiendo correctamente" -ForegroundColor Green
    
    # Contar instancias registradas
    $appsResponse = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -UseBasicParsing -TimeoutSec 5
    $content = $appsResponse.Content
    $instanceCount = ($content | Select-String -Pattern "<instance>" -AllMatches).Matches.Count
    Write-Host "✓ NÚMERO DE INSTANCIAS REGISTRADAS EN EUREKA: $instanceCount" -ForegroundColor Yellow
    
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

Write-Host "`n=== RESUMEN ===" -ForegroundColor Green
Write-Host "Eureka Server: http://localhost:8761" -ForegroundColor White
Write-Host "Usuario Service: http://localhost:8001" -ForegroundColor White
Write-Host "Carro Service: http://localhost:8002" -ForegroundColor White
Write-Host "Moto Service: http://localhost:8003" -ForegroundColor White
