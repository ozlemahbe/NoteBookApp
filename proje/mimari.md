# Cute Notes — Mimari

Tarih: 8 Ekim 2026 · Durum: hedef mimari / uygulama sözleşmesi.

## 1. Dayanak ve sınırlar

Mevcut yapı bilgisi `project_structure.md` dosyasından alınmıştır. Flutter, modeller/ekranlar/servisler/tema/widgetlar ayrımı, Firebase yapılandırması ve auth dosyaları bildirilmiştir. Kaynak kod ve paketler incelenmemiştir; çalışan Firebase senkronizasyonu, yerel veritabanı, state yönetimi veya güvenlik kuralları mevcut kabul edilmez.

Bu belgedeki yollar hedef dosyalardır. Agent önce gerçek dosyalara bakar; çalışan mimariyi sebepsiz değiştirmeden bu sözleşmeleri uygular. Firebase mevcut entegrasyon nedeniyle önerilir; başka çalışan backend bulunduğunda önce uyarlama değerlendirilir.

## 2. Ana kararlar

| Konu | Karar | Gerekçe / sınır |
| --- | --- | --- |
| Uygulama | Flutter; ilk doğrulama Android telefon/tablet | Mevcut projeyle uyum |
| Mimari | UI → controller → repository → veri kaynakları | Widgetlar veri ve güvenlik işlerini taşımaz |
| Veri yaklaşımı | Önce atomik yerel kayıt, sonra bulut eşitleme | İnternet kesilince çalışma sürer |
| Hesap | Mevcut Firebase Auth akışını doğrula ve genişlet | Parolalar uygulamanın kendi tablolarına yazılmaz |
| Yerel kayıt | Mevcut uygun DB korunur; yoksa Drift/SQLite adayı | Transaction, migration ve outbox gerekir |
| State | Mevcut tutarlı çözüm korunur; yoksa Riverpod adayı | Test edilebilir bağımlılıklar; iki sistem kurulmaz |
| Bulut | Firestore küçük metadata/envelope; Storage büyük şifreli dosya | PDF/stroke yığınları tek Firestore dokümanına konmaz |
| PDF | Motor adapter arkasında; ilk prototip adayı `pdfrx` | Sürümde gerçek import/render/export kanıtı şart |
| Çizim | Paylaşılan `CustomPainter` + vektör stroke formatı | PDF overlay ve bağımsız çizim aynı veriyi kullanır |
| Gizlilik | AES-256-GCM ile hassas payload istemcide şifrelenir | SHA, geri açılabilir içerik şifrelemesi değildir |
| Kurtarma | Auth parolasından ayrı kasa parolası + kurtarma kodu | Yeni cihazda aynı içerik anahtarına erişim gerekir |
| Çatışma | Revizyon kontrolü; çatışan sürümleri ayrı koru | Sessiz son-yazan-kazan kaybını engelle |

Drift, Riverpod ve PDF paketi burada kurulu kabul edilmez. Agent `pubspec.yaml`, bakım durumu, lisans ve Flutter uyumunu denemeden eklemez. Belge paket sürümü sabitlemez; uygulanırken test edilen sürüm `pubspec.lock` ve karar kaydına yazılır.

## 3. Katmanlar ve kademeli klasör yapısı

Mevcut `lib/models`, `screens`, `services`, `theme`, `widgets` dizinleri korunur. İlk iş bütün projeyi başka klasör düzenine taşımak değildir. Yeni sınırlar eklenir; mevcut ekranlar ilgili özelliğe dokunuldukça bu sınırlara bağlanır.

```text
lib/
  main.dart
  firebase_options.dart
  models/                  # mevcut modeller + document/page/stroke/envelope
  screens/                 # mevcut ekranlar + defter detayı/belge/çizim editörleri
  widgets/                 # ortak yüzey, araç çubuğu, belge satırı
  theme/                   # mevcut tema, tasarım tokenları
  controllers/             # ekran state'i ve kullanıcı komutları
  repositories/            # arayüzler ve yerel öncelikli uygulamalar
  services/
    auth_service.dart      # mevcut servis
    sync_service.dart      # kuyruk, revizyon, retry
    vault_service.dart     # kasa yaşam döngüsü
    backup_service.dart    # sürümlü şifreli yedek
  data/
    local/                 # veritabanı, outbox, migration
    remote/                # Firestore/Storage kaynakları
  core/
    config/                # breakpoint, autosave, import sınırları
    security/              # crypto/secure key store adapterları
    storage/               # özel dosya alanı ve atomik dosya işlemleri
    pdf/                   # PDF adapter ve export bileşimi
    drawing/               # stroke, viewport, hit-test, painter, komutlar
    errors/                # tipli hatalar ve kullanıcı mesajları
test/
integration_test/
firebase/                  # öneri; mevcut Firebase dosya konumuna uyarlanır
```

Önerilen yeni ekranlar: `notebook_detail_screen.dart`, `documents_screen.dart`, `pdf_editor_screen.dart`, `drawing_editor_screen.dart`. Dosya adları mevcut adlandırmayla uyumlu uyarlanabilir. Mevcut `main_navigation_screen.dart` ve `floating_bottom_bar.dart` yeni hedefi sunar; ayrı gezinme sistemi kurulmaz.

| Bileşen | Sorumluluk | Yapmaması gereken |
| --- | --- | --- |
| Screen / widget | Görünüm, kullanıcı girdisi, loading/error/empty | Firebase sorgusu, parola/anahtar işlemi |
| Controller | Komutlar, taslak state'i, tool/selection state'i | Dosya sistemine veya SDK'ya doğrudan bağlanma |
| Repository | Yerel kaydı ve domain tutarlılığını yönetme | Widget context veya görsel hesap taşıma |
| Local data source | Transaction, migration, query, outbox | Cloud istekleri |
| Remote data source | SDK çağrıları, DTO dönüştürme | Çatışmada kullanıcı sürümünü sessiz ezme |
| Sync service | Hesaba bağlı kuyruk, upload/download, revizyon | UI başarı mesajını erken üretme |
| Vault / crypto | Açma/kilitleme, anahtar erişimi, AEAD | Özel kripto algoritması veya loglama |
| PDF adapter | Render/geometri/dışa aktarma yetenekleri | UI veya Firebase bağımlılığı |

Repository'ler testte fake implementasyonla değiştirilebilir. Tüm özellikler için boş soyut katmanlar üretmek gerekmez; karmaşık import/export/sync işleri gerektiğinde ayrı use case olabilir.

## 4. Gezinti ve uyarlanabilir UI

Ana hedefler: Ana Sayfa, Defterler, Belgeler ve Çizim, Ayarlar. Gerçek mevcut sırayı F0'da doğrula; yeni hedefi Ayarlar önüne ekle. Index'i sayfa kimliği yerine kullanma; enum/kararlı route ID kullan ki sekme eklemek eski state'i yanlış sayfaya bağlamasın.

`LayoutBuilder` ile kullanılabilir alana göre önerilen başlangıç eşikleri:

| Kullanılabilir genişlik | Düzen |
| --- | --- |
| `< 600 dp` | Mevcut stile uygun dört hedefli alt çubuk; tek editör |
| `600–839 dp` | Alan elveriyorsa rail; tek editör ve açılır araç paneli |
| `>= 840 dp` | Rail; isteğe göre liste + detay / editör + araç paneli |

Eşikler tasarım başlangıç kararıdır, Flutter zorunluluğu değildir. Bölünmüş ekran ve yazı büyütmede görünüm içerik sığıp sığmadığına göre uyarlanır. Fiziksel piksel çözünürlüğü, model adı veya sabit `isTablet` boolean'ı ana ölçüt olmaz.

Belgeler ekranında önce PDF/Belgeler listesi, sonra Çizim Defterleri bölümü vardır. Sağ üst ekleme menüsü her iki türü de oluşturur. İki bölüm tek scroll akışıyla ve lazy satırlarla çalışır; iç içe kontrolsüz listeler kurulmaz. Arama her iki bölümün sonuçlarını kendi başlıkları altında gösterir.

Mevcut tema tokenları kullanılır. Dokunma alanları en az 48 dp hedeflenir; araç ikonlarının Semantics/tooltip açıklaması olur. Font büyütme, klavye, SafeArea ve screen reader sırası sınanır. Yön/sekme değişikliği taslağı temizlemez; editör state'i route ömründen gerektiği kadar bağımsız tutulur.

## 5. Veri modeli

Alanlar kavramsal sözleşmedir. Mevcut not içeriği düz metin, HTML veya Delta olabilir; agent bunu denetler, var olan formatı kayıpsız migrate etmeden değiştirmez.

### 5.1 Ortak kimlik ve revizyon

Senkronize nesnelerde: `id` (kararlı rastgele ID), `schemaVersion`, `ownerScopeId`, `createdAt`, `updatedAt`, `deletedAt`, `localRevision`, `remoteRevision`, `syncState` bulunur. Yerel zamanlar UI içindir; çatışma çözümü yalnız cihaz saatine dayanmaz. `ownerScopeId` misafir alanı veya Auth UID kapsamıdır; uzak yol sahipliği UID'ye bağlanır.

| Model | Hassas payload içindeki alanlar | Teknik ilişki / alanlar |
| --- | --- | --- |
| `Note` | Başlık, mevcut zengin içerik, renk, kişisel etiketler | `notebookId?`, içerik format sürümü |
| `Notebook` | Ad, kapak/desen/ikon, varsayılan kağıt ayarı | İçeriklerin bağlandığı kararlı ID |
| `Document` | Başlık, orijinal dosya adı, açıklama, küçük önizleme referansı | `kind: importedPdf / drawing / imageDocument`, `notebookId?` |
| `DocumentPage` | Kağıt türü, metin kutuları, çizim segment referansları | `documentId`, kararlı `pageId`, `order`, genişlik/yükseklik |
| `Stroke` | Araç, renk, kalınlık, noktalar ve basınç | `strokeId`, `pageId`, stroke format sürümü |
| `TextAnnotation` | Metin, font/stil, konum ve kutu boyutu | `annotationId`, `pageId` |
| `Attachment` | PDF/görsel/kapak/çizim segmenti içeriği | `attachmentId`, sürümlü nesne yolu, byte sayısı |
| `OutboxOperation` | Şifreli veri veya şifreli yerel referans | `operationId`, nesne ID, base revizyon, retry state |
| `VaultEnvelope` | Kullanıcı veri anahtarının sarılmış hali | `keyId`, KDF/salt parametreleri, wrap türü |

ID'ler ve bağlar kişisel adlardan türetilmez. Başlık/dosya adı bulut nesne yoluna yazılmaz. `notebookId` ilişkisi kimliktir; defter adını değiştirmek bütün notları yeniden yazmayı gerektirmez. Çöp kutusu not, belge ve defter için ortak soft-delete yaklaşımı kullanır.

### 5.2 PDF ve çizim sayfaları

İçe alınmış PDF orijinal şifreli attachment olarak korunur. Her kaynak sayfa bir `DocumentPage` kimliği alır; source page index, MediaBox/CropBox ve rotation referansı vardır. İlk sürüm kaynak sayfaları yeniden sıralamaz. Çizimlerin sayfa kimliği ve sıra numarası ayrıdır; sayfa sıralaması stroke sahipliğini değiştirmez.

Vektör stroke noktaları belge uzayında tutulur; ekran pikseli kaydedilmez. Kağıt genişliği/yüksekliği ve stroke kalınlığı aynı kanonik birim sistemine bağlıdır. Basınç yalnız cihaz bildiriyorsa, normalize edilmiş değer olarak saklanır; destek yoksa sabit kalınlık kullanılır.

Kayıt biçimi JSON veya eşdeğer sürümlü ikili format olabilir. Bütün stroke'ları sınırsız tek JSON'a/Firestore dokümanına yazma. Sayfa bazında, ölçülmüş boyut sınırına göre immutable segment dosyaları üret; manifest bu segmentleri referanslasın. Undo/redo ilk sürümde oturum komut geçmişidir; geçmişin yeniden açılışta devam etmesi ayrıca uygulanmadıkça vaat edilmez, son çizim verisi kalıcıdır.

## 6. Yerel kayıt, otomatik kayıt ve migration

UI veriyi repository üzerinden yerelden izler. Kullanıcı değişikliği önce transaction ile yerel kayıt + outbox olarak yazılır. PDF/görsel gibi ekler önce uygulamanın özel alanında geçici şifreli dosyaya yazılır, doğrulanır ve atomik final yola taşınır; metadata buna sonra bağlanır. Dosya ve SQLite ayrı sistemler olduğundan açılış recovery'si yarım import/yetim geçici dosya durumlarını uzlaştırır.

Kaydetme davranışı:

- Metin için başlangıç debounce hedefi 500 ms; stroke için `pointerUp` sonrası tamamlanan stroke kaydı. Son parametreler cihaz ölçümlerine göre merkezi config'de tutulur.
- Büyük işlemlerde UI thread bloklanmaz; ağır serileştirme/crypto işleri gerektiğinde isolate/stream yaklaşımıyla yapılır.
- Back/route değişiminde bekleyen editör kaydı flush edilir. Lifecycle callback'leri ek korumadır; OS'nin her zaman callback vereceği varsayılmaz.
- `Cihaza kaydedildi`, ancak atomik yerel yazma tamamlanınca gösterilir. `Senkronize edildi`, bulut commit'i tamamlanınca gösterilir. `Çevrimdışı`, `Bekliyor`, `Hata`, `Çatışma` ayrıca görünür.
- Disk dolu veya crypto/yazma hatasında taslak mümkün olduğunca bellekte korunur ve kullanıcıya yeniden deneme verilir.

Migration sırası: eski şemayı algıla → korumalı yedek oluştur → yeni sürüme transaction/copy ile taşı → öğe sayıları/ID ilişkilerini doğrula → başarılı sürümü işaretle → eski kopyayı belirlenen saklama politikasına göre temizle. Başarısız migration sıfırdan veritabanı yaratıp eski dosyayı silmez. Şifreleme geçişinde oluşan düz metin geçici kopyalar uygulama özel alanında tutulur ve başarıdan sonra temizlenir; flash depolamada adli düzeyde silme garantisi verilmez.

## 7. PDF adapter ve çizim motoru

### 7.1 PDF yetenek sözleşmesi

`PdfEngine` veya aynı sorumlulukta adapter şu işleri sunar: `open`, sayfa bilgisi, lazy render, viewport/sayfa dönüşümleri, engine kaynaklarını kapatma ve işaretlemeli kopya export'u. Export ayrı adapter olabilir; paketlerin tüm API'yi tek başına sağladığı varsayılmaz. Yetenekler açık bildirilir: parola korumalı açma, gerçek annotation yazma, sayfa manipülasyonu, düzleştirme.

İlk aday `pdfrx`tir; resmi paket kaydı görüntüleme ve sayfa manipülasyonu özellikleri bildirmektedir. Bu, uygulamanın ihtiyaç duyduğu tüm ink/text export yeteneklerinin seçilecek sürümde doğrulandığı anlamına gelmez. F0 denemesi aynı içerikle şu zinciri kanıtlar: render → overlay → yeniden açılış → export → ikinci görüntüleyici. Başarısızsa adapter altında alternatif motor değerlendirilir; lisans/maliyet ve sürüm uyumu karar kaydına yazılır.

Export sözleşmesi:

1. Orijinal PDF üzerine uygulamanın katmanlarını birleştiren **yeni dosya** üret.
2. Tercih edilen yol kaynak sayfaları ve mevcut metni koruyarak yeni vektör çizim/metin eklemektir.
3. Yalnız raster export mümkünse çözünürlük, dosya büyüklüğü ve metin arama/seçme kaybını UI'da belirt; bu kısıtı tamamlanmış export kararında kaydet. Sessizce kalite düşürme.
4. Flat export'u yeniden düzenlenebilir kaynak gibi kullanma; uygulamadaki orijinal + vektör model kalır.
5. Dijital imzalı PDF'ye değişiklik eklemek imzanın durumunu etkileyebilir; orijinali koru ve çıktıdaki durumu ilgili örnekle doğrula.

### 7.2 Koordinatlar

Ekran → viewport → kaynak sayfa → kanonik belge uzayı dönüşümlerini tek bileşen yönetir. PDF motorunun y-eksen yönü, rotation ve CropBox offset'i normalize edilir. Dokunma noktası ters viewport matrisiyle belge uzayına çevrilir; render sırasında ileri dönüşüm uygulanır. Export aynı sayfa geometri bilgisini kullanır.

`pageId`, zoom seviyesi, scroll ve sayfa rotation'ı birbirine karıştırılmaz. 90/180/270 derece, karma sayfa boyutları ve kırpılmış sayfa örnekleri konum testi içerir. Bir sayfadaki çizim diğer sayfa overlay'ine eklenemez.

### 7.3 Ortak çizim yüzeyi

`DrawingController` aktif aracı, rengi, kalınlığı, seçili sayfayı ve undo/redo komutlarını yönetir. `DrawingCanvas` / painter yalnız çizim yapar. `ViewportController` pan/zoom yönetir. `StrokeStore` repository üzerinden kalıcı kayıt yapar.

Başlangıç araçları: kalem, yarı saydam fosforlu kalem, tüm stroke'u kaldıran silgi, metin kutusu, undo/redo. Nokta bazında silgi ve gelişmiş seçim sonraki sürümdür. Çizgi smoothing ekran görüntüsünü iyileştirebilir; saklanan noktalar ve export görünümü tutarlı kalmalıdır.

Stylus modu: kalem çizim, parmak pan/zoom; finger-drawing modu ayrı seçilir. Pointer türü ve varsa basınç verisi kullanılır. Yazılım filtresi tam donanım avuç içi reddi yerine geçmez; gerçek cihazın verdiği sinyallerle sınanır. Ekran yeniden çizimleri sadece etkilenen canvas bölgesinde sınırlandırılır; uzun çizimler profil ölçümüyle segmentlenir.

## 8. Güvenlik, şifreleme ve kurtarma

### 8.1 Ayrı güvenlik hedefleri

| Hedef | Uygulama |
| --- | --- |
| Hesaba giriş | Firebase Auth; SDK oturumu, doğrulama ve reset |
| Başka hesabın verisine erişimi engelleme | Firestore ve Storage sunucu kuralları |
| Dosya/içerik gizliliği | İstemcide AES-256-GCM; özel yerel dosya alanı |
| Cihazda anahtar koruma | Android Keystore / iOS Keychain temelli secure storage adapterı |
| Cihazlar arası kasa açma | Ayrı kasa parolası veya kurtarma koduyla sarılmış anahtar |
| Yanlışlıkla kaybı azaltma | Çöp kutusu, revizyonlar, şifreli yedek ve restore testi |
| UI kilidi | İsteğe bağlı biyometri/PIN; veri şifrelemesinin yerine geçmez |

SHA-256 tek yönlü hash'tir; notları şifreleyip sonradan açma işini yapmaz. Bütünlük hash'i olarak kullanılabilir fakat gizlilik veya saldırgana karşı kimlik doğrulama sağlamaz. AEAD tag'i ciphertext bütünlüğünü doğrular. Firebase Auth parolasını kendi SHA tablosunda tutma; özel parola backend'i bu projede kurulmaz.

### 8.2 Anahtar yaşam döngüsü

Bu planın gizlilik hedefi: içerik ve dosya başlıkları cloud'a istemcide şifrelenerek gönderilsin. Backend yalnız teknik metadata ve ciphertext görsün. Bu hedefin maliyeti yeni cihazda hesap girişinden sonra kasanın ayrıca açılmasıdır.

1. Kasa kurulunca kriptografik güvenli rastgele 256-bit kullanıcı veri anahtarı üret; `keyId` ver.
2. Cihazdaki kullanım kopyasını platform güvenli depolama adapterıyla koru. DB, SharedPreferences, kaynak kod, log veya cloud'a çıplak anahtar yazma.
3. Ayrı kasa parolasından, salt ve sürümlü parametrelerle standart KDF kullanarak wrapping key türet. Başlangıç adayı Argon2id'dir; destek/parametreler gerçek mobil cihazda doğrulanır, güvenilir kütüphane kullanılır. Yalnız SHA(parola) veya kısa PIN anahtar türetimi olamaz.
4. Veri anahtarını wrapping key ile authenticated encryption kullanarak sar; buluta yalnız envelope ve gerekli KDF metadata'sını koy.
5. Yüksek entropili rastgele kurtarma kodu üret. Ayrı wrap envelope oluştur; ham kodu sunucuya/loga gönderme. Kullanıcıya güvenli saklama ve deneme akışı sun.
6. Yeni cihaz Firebase hesabını doğrular, envelope'u indirir ve kasa parolası veya recovery koduyla açar. Açılana kadar eski şifreli içerik indirilebilir fakat gösterilemez.
7. Kasa parolası değişiminde mevcut veri anahtarı yeni wrapping key ile tekrar sarılır. Firebase giriş parolası reset'i bunu otomatik çözmez.
8. Veri anahtarı yenileme gerekiyorsa `keyId` ile eski/yeni kayıtları ayırt ederek kesintiye dayanıklı yeniden şifreleme yap; eski içerik doğrulanmadan eski anahtarı kaldırma.

Kasa durumları en az `uninitialized`, `locked`, `unlocking`, `unlocked` ve `error` olarak ayrılır. İlk hesap kasası kurulumu çevrimiçi create-if-absent/transaction ile yarışa dayanıklı yapılır; iki cihaz ayrı anahtarları aynı hesaba geçerli anahtar diye yazamaz. Var olan envelope açılamıyorsa yeni kasa otomatik oluşturulmaz. Misafir kurulumu ayrı yerel scope'tadır. Arka plan/kilit zaman aşımı politikası merkezi ayardadır; kilitlenince çözülmüş cache erişimi ve UI önizlemesi kapanır. Bellek temizliği platformun izin verdiği ölçüde yapılır, mutlak zeroization garantisi verilmez.

Kasa parolası ve recovery kodu birlikte kaybolursa, açılmış güvenilir bir cihaz yokken içerik geri getirilemez. UI bu sonucu kurulumda açıkça anlatır. Kurtarma mekanizması tamamlanmadan uçtan uca şifreleme bitmiş sayılmaz. Hesap sahibi, yeni cihazda hem hesap erişimine hem kasa açma yoluna sahip olmalıdır; Auth reset'ini atlatan açık anahtar endpoint'i eklenmez.

Misafir çalışma alanının kendi anahtarı bulunur; varsayılan yalnız cihazda korunur. Kullanıcıya hesaba bağlanmamış/ayrı yedeklenmemiş misafir içeriğin uygulama kaldırılınca kaybolabileceği gösterilir. Hesaba aktarırken hedef kasa anahtarıyla kayıtlar tekrar şifrelenir; değişen sahiplik AAD'ye yansır. Kaynak misafir verisi aktarım ve geri okuma doğrulanmadan silinmez.

### 8.3 Şifreli kayıt biçimi

Envelope: `cryptoVersion`, `keyId`, `algorithm`, `nonce`, `ciphertext`, `tag`. AES-GCM için aynı anahtarla nonce tekrar kullanılmaz; güvenli kütüphanenin nonce politikası uygulanır. AAD; scope/UID, record ID, payload türü ve format sürümünü bağlar. Kimlik/scope değiştirildiğinde AAD de değişeceği için yeniden şifreleme gerekir. Çözme/tag hatası boş notla üzerine yazma sebebi değildir.

Şifrelenen içerik: not başlığı/gövdesi, defter adı ve özel görselleri, belge adı/orijinal PDF, stroke ve metin kutuları, thumbnail'lar, hassas outbox payload'ları ve yedek içeriği. Teknik ID'ler, bağlar, tür, zamanlar ve boyutlar gibi minimum metadata açık kalabilir; bu metadata sızıntısının sınırı belgeye yazılır. Hesap e-postası kimlik sağlayıcı tarafından görülebilir; tam anonimlik iddiası verilmez.

Yerel SQLite yalnız teknik indeksler ve şifreli payload taşıyabilir; tüm veritabanı şifrelemesi ek savunma olarak değerlendirilebilir. Açık başlık/içerik arama indeksi diske yazılmaz. İlk sürüm araması kasa açıkken yerelde çözülmüş veri üzerinde çalışır; locked vault'ta başlık önizlemesi gösterilmez. Bulutta tam metin araması ilk sürümde yoktur.

Viewer sadece dosya yolu kabul ediyorsa PDF çözülmüş kopyasını uygulama özel geçici alanında minimum süre tut; kapanış ve sonraki açılış temizliği uygula. Dışa aktarılan PDF/PNG'nin alıcı tarafından okunabilmesi için açık içerik taşıdığı kullanıcı eyleminde belirtilir. Şifreli yedek seçeneği ayrı tutulur. Açık geçici dosyalar, thumbnail'lar ve debug logları gizlilik testine dahildir.

### 8.4 Sunucu erişimi

Yollar kullanıcı UID kapsamındadır. Hem Firestore hem Storage için `request.auth != null` ve yol UID'sinin `request.auth.uid` ile eşleşmesi gerekir. Sadece giriş yapmış olmak tüm kullanıcı verilerine erişim izni değildir. Sahiplik/değişmez alanlar, izinli türler, schema version, makul envelope boyutu, object size ve content type doğrulanır. Büyük şifreli dosyalar `application/octet-stream` olabilir; orijinal format envelope içinde korunur.

Rules istemci kodundan bağımsız uygulanır. Admin SDK'nin kuralları atladığı sunucu işlerinde UID yetkilendirmesi ayrıca yapılır. Public download URL'leri kalıcı erişim yöntemi olarak kullanılmaz; yetkili SDK erişimi tercih edilir. App Check varsa kötüye kullanım savunmasıdır, kullanıcı sahipliğinin yerine geçmez. Rules örneği görülmeden mevcut üretim kuralları güvenli kabul edilmez.

Bu mimari riskleri azaltır; ele geçirilmiş/açık cihaz, kullanıcının paylaştığı export veya bütün kurtarma yollarının kaybı için mutlak güvence vermez. Ürün metni `asla kaybolmaz/çalınamaz` iddiası kullanmaz.

## 9. Bulut yerleşimi ve senkronizasyon

Önerilen yerleşim; gerçek mevcut veriye migration ile uyarlanır:

| Konum | İçerik |
| --- | --- |
| `users/{uid}` | Minimum profil; hassas not verisi içermez |
| `users/{uid}/notebooks/{id}` | Defter şifreli envelope + teknik revizyon |
| `users/{uid}/notes/{id}` | Not şifreli envelope veya büyük içerik manifest'i |
| `users/{uid}/documents/{id}` | Şifreli belge manifest'i + teknik tür/revizyon |
| `users/{uid}/documents/{id}/pages/{pageId}` | Gerekliyse şifreli sayfa manifest'i |
| `users/{uid}/vault/{keyId}` | Parola/recovery ile sarılmış anahtar envelope'ları |
| `users/{uid}/revisions/{revisionId}` | Politika kapsamında korunan eski şifreli sürümler |
| Storage: `users/{uid}/objects/{objectId}/{versionId}` | Immutable şifreli PDF/görsel/segment/thumbnail |

Firestore payload sınırlarına yaklaşmadan büyük içeriği Storage'a taşı; agent seçilen ürün/SDK'nın güncel sınırlarını doğrular. Boyut sınırları tek config'den gelir. Storage ve Firestore arasında tek atomik transaction yoktur.

### 9.1 Push akışı

1. Kullanıcı düzenlemesi yerel transaction ile kayıt + outbox üretir. Her işlem kararlı `operationId`, nesne ID ve `baseRemoteRevision` taşır.
2. Hesap ve kasa uygunsa worker sıradaki işlemi alır. Çevrimdışıyken transaction çalıştırmaya kalkmaz; yerel kuyruk bekler.
3. Değişen dosyaları immutable Storage yollarına yükler, hash/tag/boyut doğrulamasını yapar. İptal veya hata yerel orijinali silmez.
4. Online Firestore transaction'ında remote revizyonu okur. Beklenen base eşleşirse yeni manifest ve revizyonu yazar; operation ID ile tekrarları ayırt eder.
5. Eşleşmezse yerel ve remote sürümleri korur, çatışma işaretler. Kullanıcı iki sürümü görüp seçebilir veya birleştirebilir. İlk sürüm otomatik stroke/CRDT birleştirme yapmaz.
6. Bulut commit'inden sonra aynı işlem yerelde ack edilir. Ağ sonucu belirsizse operation ID ile kontrol edip güvenli retry yapar.

SDK offline cache'i ek kolaylıktır; uygulama yerel DB/outbox'ını tek doğruluk kaynağı olarak kullanır. Firestore varsayılan offline tekrarlarının çakışmayı kendiliğinden kayıpsız çözdüğü varsayılmaz. Transaction callback'i tekrar çalışabilir; dosya upload, anahtar üretimi veya UI yan etkisi callback içine konmaz.

### 9.2 Pull, silme ve hesap değişimi

Pull edilen revizyon yerelde dirty/outbox varsa üzerine yazılmaz; çatışma olarak ele alınır. Aynı ID yeniden indirilince çift not oluşturulmaz. Belgelerin metadata'sı öncelikli, ağır attachment'ları gerektiğinde indirilir; offline kullanılabilir durum açık gösterilir.

Silme tombstone ile eşitlenir; eski offline cihaz silinmiş notu sessiz diriltmez. Not düzenleme ile remote silme çatışırsa kullanıcının düzenlemesi kurtarılabilir kopya olarak korunur. Saklama süresi merkezi politikadır; ilk sürüm otomatik hard delete kapalı tutulur, süre ve GC ölçütleri kesinleşince etkinleştirilir. Hard delete sonrası revizyon/attachment temizliği tek geçişte çocuk koleksiyonların da silindiği varsayımına dayanmaz.

Hesap değişiminde worker, listener ve local scope kapatılır; devam eden sonuç eski UID scope'una bağlı kalır ve yeni UI'ı etkilemez. Çıkışta bekleyen kayıtlar yerelde güvenli tutulur, durum gösterilir; cihazdan silme isteği ayrı işlemdir. Gönderilmemiş içeriği sırf çıkış yapıldı diye otomatik kaldırma.

Storage upload tamamlanıp Firestore commit'i başarısız olursa nesne yetim olabilir. Temizlik worker'ı yalnız referanssız ve güvenli bekleme süresi geçmiş nesneleri kaldırır; devam eden upload/retry ve eski cihazların ihtiyaç duyduğu sürümler dikkate alınır.

## 10. Yedek ve geri yükleme

Eşitleme yedek değildir; silme veya bozulmayı başka cihaza yayabilir. Şifreli yedek; format sürümü, öğe manifest'i, ilişki ID'leri, şifreli payload/ekler ve bağımsız açma için gerekli wrap metadata'sını içerir. Kullanıcı yedek parolası/recovery yolunu ayrı saklar; ham içerik anahtarı arşive yazılmaz.

Restore önce test/ayrı alanına doğrulanır; mevcut notların üstüne körlemesine yazılmaz. ID çakışması halinde birleştirme/kopya politikası kullanılır. İçerik sayısı, sayfa sayıları, ilişkiler ve crypto tag'ler kontrol edilir. Yedek varlığı değil başarılı restore testi kabul ölçütüdür. Bulut revizyonları için kapasite/maliyet/saklama politikası ayrıca kaydedilir.

## 11. Test stratejisi

| Katman | Kritik doğrulama |
| --- | --- |
| Model / migration | Eski içerik formatı, ID/ilişki korunması, bilinmeyen sürüm |
| Yerel repository | Atomik içerik+outbox, disk hatası, soft delete/restore |
| Çizim/geometri | İleri/ters dönüşüm, PDF rotation/crop, stroke undo/redo |
| Güvenlik | Round-trip, yanlış anahtar, bozuk tag, nonce politikası, AAD kimlik bağlama |
| Kasa | Yeni cihaz, parola değişimi, recovery, kayıp anahtar davranışı |
| Senkronizasyon | Offline retry, idempotency, revizyon çatışması, hesap değişimi |
| Firebase kuralları | A'nın B verisine erişim reddi; malformed/oversize payload reddi |
| Widget | Dört hedef, boş/yükleniyor/hata, genişlik ve büyük yazı |
| Entegrasyon | Not/defter/PDF/çizim oluştur-kaydet-aç-export; iki cihaz restore |
| Performans | Profile modunda uzun çizim, sayfalı PDF, lazy cache, bellek |

Kripto testleri yalnız round-trip'ten ibaret olmaz; kullanılan kütüphane standart doğrulama vektörleri ve kurcalama/hata durumlarıyla sınanır. Bu dosyanın hazırlanması uygulamanın test edildiği anlamına gelmez. Gerçek komut ve cihaz sonuçlarını agent yol haritasına kaydeder.

## 12. Açık teknik kararlar

| Konu | Varsayılan yaklaşım | Kesinleştirme noktası |
| --- | --- | --- |
| Gerçek DB / state | Çalışan uygun çözümü koru | F0 kaynak inceleme |
| PDF motoru / export | Adapter; `pdfrx` prototip adayı | F0 başka viewer'da export testi |
| KDF kütüphanesi / maliyeti | Argon2id adayı, sürümlü parametre | F2 düşük/orta sınıf cihaz ölçümü |
| Dosya / sayfa limitleri | 50 MB / 100 sayfa test hedefi | F6 RAM/disk/profile ölçümü |
| Otomatik silme / revizyon süresi | Hard delete otomasyonu kapalı | F7 veri korunumu ve maliyet kararı |
| iOS | Taşınabilir kod, doğrulanmış destek iddiası yok | Gerçek iOS build ve cihaz testi |
| Native PDF annotations | İlk sürüm flat export | Motor desteği ve uyumluluk kanıtı |

Bu başlıklar normal uygulama kararlarıdır; agent kapsam içindeki geri alınabilir kararları test ederek ilerler. Ücretli servis, yeni ürün davranışı veya kullanıcı verisini geri döndürülemez silme gibi etkiler somut gerekçeyle ayrıca ele alınır.

## 13. Teknik kaynaklar

8 Ekim 2026 tarihinde kontrol edilen birincil kaynaklar. Bunlar ürün gereksinimi yerine geçmez; yukarıdaki yapı Cute Notes için önerilen tasarımdır.

- [Flutter adaptive/responsive tasarım](https://docs.flutter.dev/ui/adaptive-responsive): kullanılabilir ekran alanına göre uyarlama.
- [Flutter mimari önerileri](https://docs.flutter.dev/app-architecture/recommendations): UI ve veri sorumluluklarını ayırma.
- [Firebase Flutter parola ile giriş](https://firebase.google.com/docs/auth/flutter/password-auth): Auth entegrasyonu.
- [Firebase Rules ve Authentication](https://firebase.google.com/docs/rules/rules-and-auth): kullanıcıya göre erişim kontrolü.
- [Cloud Storage kuralları](https://firebase.google.com/docs/storage/security/rules-conditions): Storage için UID koşulları.
- [Firestore offline davranışı](https://firebase.google.com/docs/firestore/manage-data/enable-offline): cache/eşitleme davranışı; varsayılan çakışma yaklaşımı.
- [Firestore transactions](https://firebase.google.com/docs/firestore/manage-data/transactions): online transaction, tekrar çalışabilen callback.
- [pdfrx resmi paket sayfası](https://pub.dev/packages/pdfrx): görüntüleme/manipülasyon ve uygulama anında denenecek API/lisans bilgisi.
- [OWASP Cryptographic Storage](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html): authenticated encryption ve anahtar güvenliği.
- [OWASP Password Storage](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html): parola hash/KDF rehberi.
- [OWASP Key Management](https://cheatsheetseries.owasp.org/cheatsheets/Key_Management_Cheat_Sheet.html): anahtar yaşam döngüsü ve kurtarma.
