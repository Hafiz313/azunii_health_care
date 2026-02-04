# Build Compressed APK Script
# Run this to create optimized, compressed single APK

Write-Host "🚀 Building Compressed APK..." -ForegroundColor Green
Write-Host ""

# Clean previous builds and caches
Write-Host "🧹 Cleaning previous builds and caches..." -ForegroundColor Yellow
flutter clean
Remove-Item -Path "build" -Recurse -Force -ErrorAction SilentlyContinue

# Get dependencies
Write-Host "📦 Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Build single release APK with optimizations
Write-Host "🔨 Building single release APK..." -ForegroundColor Yellow
flutter build apk --release --no-tree-shake-icons

Write-Host ""
Write-Host "✅ Build Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 APK file location:" -ForegroundColor Cyan
Write-Host "   build/app/outputs/flutter-apk/app-release.apk" -ForegroundColor White
Write-Host ""
Write-Host "📊 Optimizations Applied:" -ForegroundColor Cyan
Write-Host "   • Code shrinking (minify)" -ForegroundColor White
Write-Host "   • Resource shrinking" -ForegroundColor White
Write-Host "   • ProGuard optimization" -ForegroundColor White
Write-Host ""
Write-Host "💡 APK is ready for distribution!" -ForegroundColor Yellow
