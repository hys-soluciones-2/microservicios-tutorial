# Script para verificar el estado de Eureka y servicios registrados

Write-Host "Verificando estado de Eureka Server..." -ForegroundColor Green

# Verificar si Eureka está ejecutándose
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761" -UseBasicParsing -TimeoutSec 5
    Write-Host "✓ Eureka Server está ejecutándose en puerto 8761" -ForegroundColor Green
    
    # Obtener información de aplicaciones registradas
    try {
        $appsResponse = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -UseBasicParsing -TimeoutSec 5
        $content = $appsResponse.Content
        
        # Contar instancias registradas
        $instanceCount = ([regex]::Matches($content, "<instance>")).Count
        Write-Host "✓ Número de instancias registradas: $instanceCount" -ForegroundColor Yellow
        
        # Mostrar aplicaciones registradas
        if ($instanceCount -gt 0) {
            Write-Host "`nAplicaciones registradas:" -ForegroundColor Cyan
            $content | Select-String -Pattern "<name>(.*?)</name>" | ForEach-Object {
                $appName = $_.Matches[0].Groups[1].Value
                Write-Host "  - $appName" -ForegroundColor White
            }
        } else {
            Write-Host "⚠ No hay instancias registradas en Eureka" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "✗ Error al obtener información de aplicaciones: $($_.Exception.Message)" -ForegroundColor Red
    }
    
} catch {
    Write-Host "✗ Eureka Server no está ejecutándose en puerto 8761" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nVerificando otros servicios..." -ForegroundColor Green

# Verificar otros puertos
$ports = @(8081, 8001, 8002, 8003)
foreach ($port in $ports) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$port" -UseBasicParsing -TimeoutSec 2
        Write-Host "✓ Servicio ejecutándose en puerto $port" -ForegroundColor Green
    } catch {
        Write-Host "✗ No hay servicio en puerto $port" -ForegroundColor Red
    }
}
