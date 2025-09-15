# Script rápido para verificar servicios
Write-Host "Verificando servicios..." -ForegroundColor Green

# Verificar puertos
$ports = @{8081="Config Service"; 8761="Eureka Service"; 8001="Usuario Service"; 8002="Carro Service"; 8003="Moto Service"}

foreach ($port in $ports.Keys) {
    try {
        $connection = New-Object System.Net.Sockets.TcpClient
        $connection.Connect("localhost", $port)
        $connection.Close()
        Write-Host "✓ $($ports[$port]) ejecutándose en puerto $port" -ForegroundColor Green
    } catch {
        Write-Host "✗ $($ports[$port]) NO ejecutándose en puerto $port" -ForegroundColor Red
    }
}

# Verificar Eureka específicamente
Write-Host "`nVerificando Eureka..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761" -UseBasicParsing -TimeoutSec 3
    Write-Host "✓ Eureka Server respondiendo" -ForegroundColor Green
    
    # Contar instancias
    $appsResponse = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -UseBasicParsing -TimeoutSec 3
    $content = $appsResponse.Content
    $instanceCount = ($content | Select-String -Pattern "<instance>" -AllMatches).Matches.Count
    Write-Host "✓ Instancias registradas: $instanceCount" -ForegroundColor Yellow
    
} catch {
    Write-Host "✗ Eureka no disponible" -ForegroundColor Red
}
