Write-Host "=== INICIANDO Y VERIFICANDO MICROSERVICIOS ===" -ForegroundColor Cyan

# Función para verificar si un puerto está en uso
function Test-Port {
    param([int]$Port)
    try {
        $connection = New-Object System.Net.Sockets.TcpClient
        $connection.Connect("localhost", $Port)
        $connection.Close()
        return $true
    } catch {
        return $false
    }
}

# Función para esperar a que un servicio esté disponible
function Wait-ForService {
    param([int]$Port, [string]$ServiceName, [int]$TimeoutSeconds = 60)
    
    Write-Host "Esperando a que $ServiceName esté disponible en puerto $Port..." -ForegroundColor Yellow
    $elapsed = 0
    
    while ($elapsed -lt $TimeoutSeconds) {
        if (Test-Port -Port $Port) {
            Write-Host "✓ $ServiceName está disponible" -ForegroundColor Green
            return $true
        }
        Start-Sleep -Seconds 2
        $elapsed += 2
        Write-Host "." -NoNewline -ForegroundColor Gray
    }
    
    Write-Host "`n✗ $ServiceName no está disponible después de $TimeoutSeconds segundos" -ForegroundColor Red
    return $false
}

# Iniciar Config Service
Write-Host "`n1. Iniciando Config Service..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd Config-Service; mvn spring-boot:run" -WindowStyle Minimized
if (Wait-ForService -Port 8081 -ServiceName "Config Service" -TimeoutSeconds 30) {
    Write-Host "Config Service iniciado correctamente" -ForegroundColor Green
} else {
    Write-Host "Error al iniciar Config Service" -ForegroundColor Red
    exit 1
}

# Iniciar Eureka Service
Write-Host "`n2. Iniciando Eureka Service..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd Eureka_Service; mvn spring-boot:run" -WindowStyle Minimized
if (Wait-ForService -Port 8761 -ServiceName "Eureka Service" -TimeoutSeconds 30) {
    Write-Host "Eureka Service iniciado correctamente" -ForegroundColor Green
} else {
    Write-Host "Error al iniciar Eureka Service" -ForegroundColor Red
    exit 1
}

# Iniciar Usuario Service
Write-Host "`n3. Iniciando Usuario Service..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd usuario-microservice; mvn spring-boot:run" -WindowStyle Minimized
if (Wait-ForService -Port 8001 -ServiceName "Usuario Service" -TimeoutSeconds 30) {
    Write-Host "Usuario Service iniciado correctamente" -ForegroundColor Green
} else {
    Write-Host "Error al iniciar Usuario Service" -ForegroundColor Red
}

# Iniciar Carro Service
Write-Host "`n4. Iniciando Carro Service..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd CarroMicroservicio; mvn spring-boot:run" -WindowStyle Minimized
if (Wait-ForService -Port 8002 -ServiceName "Carro Service" -TimeoutSeconds 30) {
    Write-Host "Carro Service iniciado correctamente" -ForegroundColor Green
} else {
    Write-Host "Error al iniciar Carro Service" -ForegroundColor Red
}

# Iniciar Moto Service
Write-Host "`n5. Iniciando Moto Service..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd motoMicroservicio; mvn spring-boot:run" -WindowStyle Minimized
if (Wait-ForService -Port 8003 -ServiceName "Moto Service" -TimeoutSeconds 30) {
    Write-Host "Moto Service iniciado correctamente" -ForegroundColor Green
} else {
    Write-Host "Error al iniciar Moto Service" -ForegroundColor Red
}

# Esperar a que los servicios se registren en Eureka
Write-Host "`nEsperando 30 segundos para que los servicios se registren en Eureka..." -ForegroundColor Cyan
Start-Sleep -Seconds 30

# Verificar Eureka
Write-Host "`n=== VERIFICANDO EUREKA ===" -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8761" -UseBasicParsing -TimeoutSec 5
    Write-Host "✓ Eureka Server está ejecutándose" -ForegroundColor Green
    
    # Obtener información de aplicaciones
    $appsResponse = Invoke-WebRequest -Uri "http://localhost:8761/eureka/apps" -UseBasicParsing -TimeoutSec 5
    $content = $appsResponse.Content
    
    # Contar instancias
    $instanceCount = ($content | Select-String -Pattern "<instance>" -AllMatches).Matches.Count
    Write-Host "✓ Número de instancias registradas en Eureka: $instanceCount" -ForegroundColor Yellow
    
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
    Write-Host "✗ Error al verificar Eureka: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== RESUMEN DE SERVICIOS ===" -ForegroundColor Cyan
Write-Host "Config Service: http://localhost:8081" -ForegroundColor White
Write-Host "Eureka Server: http://localhost:8761" -ForegroundColor White
Write-Host "Usuario Service: http://localhost:8001" -ForegroundColor White
Write-Host "Carro Service: http://localhost:8002" -ForegroundColor White
Write-Host "Moto Service: http://localhost:8003" -ForegroundColor White

Write-Host "`n=== SISTEMA DE MICROSERVICIOS COMPLETADO ===" -ForegroundColor Green
