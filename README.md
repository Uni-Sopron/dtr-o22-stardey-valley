# Termelésirányítás beadandó feladat

## Feladatleírás

A Stardew Valley egy farmépítős játék, amelyben lehetőségünk van a nagyapánktól örökölt farmon különböző fajtájú növényeket termeszteni és azokat eladni. A feladat célja a játékban elérhető eszközökkel, valamint a GLPK segítségével optimálisan megtervezni a termelésünket, hogy a lehető legtöbb hasznot érjük el egy játékbeli évszak alatt.

<https://www.stardewvalley.net/>

Az alapjátékot bővítjük 2 további követelménnyel:

- Egy-egy növény elültetése és learatása különböző mennyiségű időbe telik (növényfajtától függően)
- Rendelkezésünkre áll 5 munkatárs, akik a mezőgazdasági munkálatokat végzik

## Szabályok

### Kiindulási feltételek

- Rendelkezünk egy adott mennyiségű kezdőtőkével
- Rendelkezünk egy adott méretű (10x10 plotból álló) mezőgazdasági területtel
- Rendelkezünk 5 mezőgazdasági munkatárssal

### Növények tulajdonságai

- Ültetési idő
- Érési idő
- Aratási idő
- Beszerzési költség
- Értékesítési ár

### Munkatársak tulajdonságai

- Akciók:
  - pontosan 1 növény elültetése
  - pontosan 1 növény learatása
- Egy munkatárs egyszerre csak egy akciót tud végrehajtani
- Egy megkezdett akciót nem lehet félbeszakítani

### Termelési életciklus

Egy növény életciklusa a következő lépésekből áll:

1. Palánta beszerzése
    - Egy adott napon legfeljebb annyi palántát tudunk beszerezni, amennyi pénzünk aznap van (hitel nincs)
2. Ültetés
    - A beszerzett palántát egy munkatárs tudja elültetni, az adott növény ültetési idejétől függ, hogy ez a munkafolyamat mennyi ideig tart a munkatársnak
    - Egy ültetendő palánta ültetési idejének kezdetétől fogva elfoglal a mezőgazdasági területen pontosan 1 plotot
    - Legfeljebb annyi palántát tudunk elültetni, amennyi üres plotunk van még a földterületen
3. Érés
    - Amint az ültetés befejeződött, a növény elkezd érni
4. Aratás
    - Az érési idő lejárta után minden növényt pontosan egyszer tud learatni egy munkatárs, az adott növény ültetési idejétől függ, hogy ez a munkafolyamat mennyi ideig tart az adott munkatársnak
    - Amint az aratási idő lejárt, felszabadul a növény által elfoglalt plot
5. Értékesítés
    - A learatott növényeket értékesíteni tudjuk az aratásukat követő napon

- Minden lépés előfeltétele az előző lépés befejezte
- Az egyes lépéseket nem lehet félbeszakítani
- A növényeket nem lehet aratás előtt semmilyen módon értékesíteni

## Cél

Az elért profit maximalizálása a rendelkezésre álló 28 nap alatt

Output:

- Maximálisan elérhető profit
- termelési terv (a munkatársaink adott napokon mit csinálnak)
