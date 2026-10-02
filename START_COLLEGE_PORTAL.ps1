$ErrorActionPreference = "Stop"

$Project = "C:\Users\piyus\OneDrive\Pictures\Documents\Documents\CollegeComplaintPortal"
$Tomcat = "C:\Users\piyus\Downloads\apache-tomcat-10.1.60-windows-x64\apache-tomcat-10.1.60"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "     COLLEGE COMPLAINT PORTAL STARTER" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $Project

Write-Host "[1/5] Checking project..." -ForegroundColor Yellow

if (!(Test-Path ".\src")) {
    throw "Project src folder not found."
}

if (!(Test-Path ".\WebContent")) {
    throw "WebContent folder not found."
}

Write-Host "Project OK" -ForegroundColor Green

Write-Host ""
Write-Host "[2/5] Checking MySQL..." -ForegroundColor Yellow

$mysql = Test-NetConnection 127.0.0.1 -Port 3306 -InformationLevel Quiet

if (!$mysql) {
    Write-Host ""
    Write-Host "MySQL port 3306 is not available." -ForegroundColor Red
    Write-Host "Start MySQL 8.0 first, then run this command again." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "MySQL OK" -ForegroundColor Green

Write-Host ""
Write-Host "[3/5] Checking Tomcat..." -ForegroundColor Yellow

if (!(Test-Path "$Tomcat\bin\catalina.bat")) {
    throw "Tomcat installation not found."
}

Write-Host "Tomcat OK" -ForegroundColor Green

Write-Host ""
Write-Host "[4/5] Setting database password..." -ForegroundColor Yellow

$env:MYSQL_PASSWORD = Read-Host "Enter MySQL password"

Write-Host "MYSQL_PASSWORD configured for this Tomcat process." -ForegroundColor Green

Write-Host ""
Write-Host "[5/5] Checking website..." -ForegroundColor Yellow

$website = Test-NetConnection 127.0.0.1 -Port 80 -InformationLevel Quiet

if ($website) {

    Write-Host ""
    Write-Host "Tomcat/HTTP already appears to be running." -ForegroundColor Green
    Write-Host "Opening website..." -ForegroundColor Green

    Start-Process "http://collegeportal"

    Write-Host ""
    Write-Host "SITE: http://collegeportal" -ForegroundColor Cyan
    Write-Host ""

    exit 0
}

Write-Host ""
Write-Host "Starting Tomcat..." -ForegroundColor Green
Write-Host ""
Write-Host "Website will be available at:" -ForegroundColor Cyan
Write-Host "http://collegeportal" -ForegroundColor White
Write-Host ""
Write-Host "Keep this terminal open while using the website." -ForegroundColor Yellow
Write-Host ""

Set-Location $Tomcat

& ".\bin\catalina.bat" run
