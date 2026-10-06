# TalimApp — تطبيق تعليمي متكامل للطلاب

تطبيق تعليمي متعدد المنصات مبني على **React Native + Expo Router + TypeScript + NativeWind**، مع Backend بـ **Express/tRPC** وقاعدة **MySQL/Drizzle** ولوحة إدارة عبر Expo Web.

## ما تم تنفيذه

- تطبيق طالب يعمل من نفس المصدر على Android وiOS وWeb Preview.
- واجهة عربية RTL: الرئيسية، المقررات، الدروس، الاختبارات، المكتبة، الحساب والاشتراكات.
- Backend فعلي على tRPC مع صلاحيات `user/admin`.
- قاعدة بيانات Drizzle تشمل المستخدمين، المقررات، الوحدات، الدروس، الملفات، البث المباشر، الاختبارات، المحاولات، الإجابات، التقدم، الاشتراكات، entitlements، سجلات النشاط والتدقيق.
- فيديو مسجل/مباشر عبر طبقة جلسة تشغيل وروابط موقعة قصيرة العمر عند وجود أصل التخزين.
- حماية PDF عبر `pdf-lib`: الخادم ينزّل المصدر الخاص، يضع watermark متكررًا مرتبطًا بالمستخدم والجلسة والتاريخ، يرفع نسخة مؤقتة خاصة، ولا يعيد رابط المصدر.
- حماية التقاط الشاشة: `expo-screen-capture` مع `FLAG_SECURE` على Android، طبقة إخفاء عند الخروج/التقاط screenshot، وwatermark مرئي دائم.
- اختبارات تفاعلية وحساب نتيجة تلقائي وحفظ المحاولة عند تسجيل الدخول.
- لوحة إدارة محمية بدور `admin` مع إحصاءات، إدارة مقررات أولية وسجل Security Audit.
- أصول علامة Talim مخصصة وإعدادات Android/iOS/Expo.

## التشغيل المحلي/داخل Manus

```bash
pnpm install
pnpm db:push
pnpm db:seed
pnpm check
pnpm test
pnpm dev
```

- Metro/Web: `http://localhost:8081`
- API: `http://localhost:3000`
- أمر بناء Backend: `pnpm build`

يقرأ المشروع المتغيرات من البيئة أو من إعدادات مشروع Webdev. استخدم `.env.example` كمرجع، ولا تضع مفاتيح حقيقية في Git.

## أهم مسارات tRPC

- `catalog.featured`, `catalog.course`
- `dashboard.summary`
- `lessons.detail`, `lessons.markComplete`
- `media.createPlaybackSession`, `media.endSession`
- `documents.open`
- `quizzes.list`, `quizzes.detail`, `quizzes.submit`
- `subscriptions.plans`, `subscriptions.mine`, `subscriptions.entitlements`
- `admin.stats`, `admin.courses.list`, `admin.courses.create`, `admin.audit`

## الحماية — حدود واقعية

لا يعيد التطبيق ملف PDF الأصلي المحمي. عند توفر ملف PDF فعلي في Object Storage، ينشئ `server/protection.ts` نسخة PDF موسومة ديناميكيًا، مرتبطة بجلسة قصيرة، ثم يخزن سجل الإصدار في `watermark_sessions` و`protected_document_variants`.

الفيديو الإنتاجي يحتاج مزود HLS/DRM حقيقيًا: **Widevine** لـAndroid و**FairPlay** لـiOS. البنية الحالية تمنع الروابط العامة وتصدر signed playback session؛ يجب إضافة مفاتيح/URLs مزود DRM قبل الإنتاج. حماية الشاشة تمنع المسارات البرمجية المعتادة، لكنها لا تمنع تصوير الشاشة بكاميرا خارجية أو جهاز معدل بشكل مطلق.

## Android وiOS

```bash
pnpm android
pnpm ios
```

لإخراج APK/AAB وTestFlight يلزم توفير حسابات وشهادات Google Play وApple Developer وبيانات التوقيع. إعدادات `bundleIdentifier` و`android.package` وdeep link موجودة في `app.config.ts`، والكود المشترك يدعم النظامين.

## لوحة الإدارة

المسار: `/admin` داخل Expo Web. كل إجراءات `admin.*` محمية على الخادم عبر `adminProcedure`، ولا تعتمد الحماية على إخفاء الواجهة فقط. استخدم حسابًا يحمل `users.role = 'admin'`.

## بيانات التجربة

`pnpm db:seed` ينشئ مقرر «أساسيات الجبر»، درسين، ملف فيديو/PDF محميًا، اختبارًا وخطط اشتراك. الأمر idempotent للمقرر الأساسي؛ استبدل `storageKey` بأصول حقيقية من Object Storage قبل اختبار تشغيل الفيديو أو توليد PDF فعلي.

## التسليم والحالة

- فحص TypeScript: ناجح.
- اختبارات Vitest الحالية: ناجحة (25 اختبارًا، واختبار logout موجود لكنه متخطى بسبب اعتماد المصادقة).
- `pnpm db:push`: ناجح.
- `pnpm db:seed`: ناجح وقابل لإعادة التشغيل.
- `pnpm build`: ناجح.
- Preview الحالي يستخدم 8081 وAPI يستخدم 3000.
- لم يتم إنشاء APK/IPA موقّع داخل Sandbox لعدم توفر شهادات وحسابات المتاجر؛ المصدر وإعدادات Expo جاهزة لذلك.
