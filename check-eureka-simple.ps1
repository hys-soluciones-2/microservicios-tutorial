Write-Host "Verificando Eureka Server..." -ForegroundColor Green

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761" -UseBasicParsing -TimeoutSec 5
    Write-Host "✓ Eureka Server está ejecutándose en puerto 8761" -ForegroundColor Green
    
    # Obtener información de aplicaciones
    $appsResponse = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -UseBasicParsing -TimeoutSec 5
    $content = $appsResponse.Content
    
    # Contar instancias
    $instanceCount = ($content | Select-String -Pattern "<instance>" -AllMatches).Matches.Count
    Write-Host "✓ Número de instancias registradas: $instanceCount" -ForegroundColor Yellow
    
    if ($instanceCount -gt 0) {
        Write-Host "`nAplicaciones registradas:" -ForegroundColor Cyan
        $content | Select-String -Pattern "<name>(.*?)</name>" | ForEach-Object {
            $appName = $_.Matches[0].Groups[1].Value
            Write-Host "  - $appName" -ForegroundColor White
        }
    }
    
} catch {
    Write-Host "✗ Eureka Server no está disponible" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
