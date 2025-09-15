Write-Host "=== INICIANDO SISTEMA DE MICROSERVICIOS COMPLETO ===" -ForegroundColor Cyan

# Terminar procesos Java existentes
Write-Host "Limpiando procesos Java existentes..." -ForegroundColor Yellow
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3

# Función para verificar puerto
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

# 1. Iniciar Eureka Service
Write-Host "`n1. Iniciando Eureka Service..." -ForegroundColor Green
Set-Location "Eureka_Service"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run" -WindowStyle Minimized
Set-Location ".."

# Esperar Eureka
Write-Host "Esperando Eureka..." -ForegroundColor Yellow
$eurekaReady = $false
for ($i = 0; $i -lt 30; $i++) {
    if (Test-Port -Port 8761) {
        $eurekaReady = $true
        break
    }
    Start-Sleep -Seconds 2
    Write-Host "." -NoNewline -ForegroundColor Gray
}

if ($eurekaReady) {
    Write-Host "`n✓ Eureka Service iniciado en puerto 8761" -ForegroundColor Green
} else {
    Write-Host "`n✗ Error: Eureka no se inició" -ForegroundColor Red
    exit 1
}

# 2. Iniciar Usuario Service
Write-Host "`n2. Iniciando Usuario Service..." -ForegroundColor Green
Set-Location "usuario-microservice"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run" -WindowStyle Minimized
Set-Location ".."

# 3. Iniciar Carro Service
Write-Host "`n3. Iniciando Carro Service..." -ForegroundColor Green
Set-Location "CarroMicroservicio"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run" -WindowStyle Minimized
Set-Location ".."

# 4. Iniciar Moto Service
Write-Host "`n4. Iniciando Moto Service..." -ForegroundColor Green
Set-Location "motoMicroservicio"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mvn spring-boot:run" -WindowStyle Minimized
Set-Location ".."

# Esperar a que todos los servicios se registren
Write-Host "`nEsperando 45 segundos para que todos los servicios se registren..." -ForegroundColor Cyan
Start-Sleep -Seconds 45

# Verificar estado final
Write-Host "`n=== VERIFICACIÓN FINAL ===" -ForegroundColor Cyan

$services = @{
    8761 = "Eureka Service"
    8001 = "Usuario Service"
    8002 = "Carro Service"
    8003 = "Moto Service"
}

foreach ($port in $services.Keys) {
    if (Test-Port -Port $port) {
        Write-Host "✓ $($services[$port]) ejecutándose en puerto $port" -ForegroundColor Green
    } else {
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

Write-Host "`n=== SISTEMA COMPLETADO ===" -ForegroundColor Green
Write-Host "Eureka Server: http://localhost:8761" -ForegroundColor White
Write-Host "Usuario Service: http://localhost:8001" -ForegroundColor White
Write-Host "Carro Service: http://localhost:8002" -ForegroundColor White
Write-Host "Moto Service: http://localhost:8003" -ForegroundColor White

Write-Host "`n=== ENDPOINTS DISPONIBLES ===" -ForegroundColor Cyan
Write-Host "GET http://localhost:8001/usuario - Listar usuarios" -ForegroundColor White
Write-Host "POST http://localhost:8001/usuario - Crear usuario" -ForegroundColor White
Write-Host "GET http://localhost:8001/usuario/{id}/carros - Carros del usuario" -ForegroundColor White
Write-Host "GET http://localhost:8001/usuario/{id}/motos - Motos del usuario" -ForegroundColor White
Write-Host "GET http://localhost:8001/usuario/todo/{id} - Usuario con todos sus vehículos" -ForegroundColor White
