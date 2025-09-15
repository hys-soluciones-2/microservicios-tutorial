Write-Host "Verificando servicios..." -ForegroundColor Green

# Verificar Eureka
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761" -UseBasicParsing -TimeoutSec 3
    Write-Host "✓ Eureka Server funcionando en puerto 8761" -ForegroundColor Green
    
    $appsResponse = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -UseBasicParsing -TimeoutSec 3
    $content = $appsResponse.Content
    $instanceCount = ($content | Select-String -Pattern "<instance>" -AllMatches).Matches.Count
    Write-Host "✓ Instancias registradas en Eureka: $instanceCount" -ForegroundColor Yellow
    
} catch {
    Write-Host "✗ Eureka no disponible" -ForegroundColor Red
}

# Verificar otros servicios
$ports = @(8001, 8002, 8003)
foreach ($port in $ports) {
    try {
        $connection = New-Object System.Net.Sockets.TcpClient
        $connection.Connect("localhost", $port)
        $connection.Close()
        Write-Host "✓ Servicio ejecutándose en puerto $port" -ForegroundColor Green
    } catch {
        Write-Host "✗ No hay servicio en puerto $port" -ForegroundColor Red
    }
}
