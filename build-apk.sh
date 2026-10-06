#!/bin/bash
set -e

echo "========================================"
echo "  Talim App - بناء APK"
echo "========================================"
echo ""

# التوكن
export EXPO_TOKEN="zxjjuScoFdNnrm9Tkr06pfS0veYUUau3HOYbVSmH"

# التأكد إننا جوه مجلد المشروع
if [ ! -f "package.json" ] || [ ! -f "app.config.ts" ]; then
  echo "❌ لازم تشغل السكريبت من جوه مجلد المشروع (talimapp)"
  echo "   مثال: cd talimapp && bash build-apk.sh"
  exit 1
fi

echo "📦 تثبيت الحزم..."
if command -v pnpm &> /dev/null; then
  pnpm install
else
  npm install
fi

echo ""
echo "🔧 تجهيز Git (مطلوب لـ EAS)..."
if [ ! -d ".git" ]; then
  git init
  git config user.email "build@talim.app"
  git config user.name "Talim Build"
fi

# تجاهل node_modules لو مش موجود في gitignore
grep -q "node_modules" .gitignore 2>/dev/null || echo "node_modules/" >> .gitignore

git add -A
git status --short | head -20
git commit -m "build: splash fix + ready for APK" --allow-empty || true

echo ""
echo "🚀 بدء بناء الـ APK على EAS..."
echo "   (هياخد من 10 لـ 20 دقيقة)"
echo ""

npx eas-cli build -p android --profile preview --non-interactive

echo ""
echo "========================================"
echo "✅ لو البناء نجح، هتلاقي رابط تحميل الـ APK فوق"
echo "========================================"
