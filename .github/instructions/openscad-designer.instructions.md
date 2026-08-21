---
description: "Use when designing, creating, or modifying OpenSCAD 3D models. Covers parametric design patterns, module usage from ./modules, file structure, naming conventions, and gridfinity/BOSL2 integration. Apply for any .scad file creation, editing, or review."
applyTo: "**/*.scad"
---

# OpenSCAD 3D Modelling Guidelines

Du bist ein 3D-Modelling-Spezialist für OpenSCAD. Alle Modelle müssen vollständig parametrisierbar sein und die nachfolgenden Konventionen einhalten.

---

## Projektstruktur

```
models/          ← Fertige Modelle, thematisch gruppiert
modules/
  scad/          ← Hilfmodule: roundedcube, hinge, text_on, hex_grid, din_clip, BOSL2/
  gridfinity/    ← Gridfinity-Rebuilt-Bibliothek
```

Alle Modellpfade zu Modulen sind **relativ**: `../../modules/scad/roundedcube.scad`.

---

## Dateistruktur (Pflicht)

Jede `.scad`-Datei folgt dieser Reihenfolge:

```scad
// ============================================================
// <Modellname>
// <Kurzbeschreibung>
// ============================================================

// --- Render Settings ----------------------------------------
$fn = 60;  // or $fs = 0.15 for curved surfaces

// --- Parameters ---------------------------------------------
_param_one  = 10;   // Beschreibung [mm]
_param_two  = true; // Beschreibung [bool]

// --- Computed Values ----------------------------------------
_computed = _param_one * 2;  // Abgeleitete Größe

// --- Main Model ---------------------------------------------
main_module();

// --- Modules ------------------------------------------------
module main_module() {
    // ...
}
```

---

## Namenskonventionen

| Typ | Stil | Beispiel |
|-----|------|---------|
| Dateiparameter (top-level) | `_snake_case` | `_wall_thickness`, `_inner_size` |
| Modulparameter | `snake_case` | `width`, `height_internal` |
| Öffentliche Konstanten | `SCREAMING_SNAKE_CASE` | `GRID_DIMENSIONS_MM` |
| Berechnete Werte | `_snake_case` | `_outer_radius`, `_total_height` |
| Hilfsvariablen | `_eps = 0.01` | Kleine Toleranz für Überschneidungen |

---

## Parametrisierung (Pflicht)

- Alle Maße **immer als benannte Parameter** oben in der Datei definieren – **nie** als Magic Numbers im Code.
- Inline-Kommentare mit Einheit: `= 20; // Wandstärke [mm]`
- Boolesche Optionen klar benennen: `_enable_drain_holes = false;`
- Abgeleitete Werte berechnen statt hardcoden: `_outer = _inner + 2 * _wall;`

---

## Module includieren

### Verfügbare Module in `./modules`

| Modul | `use`/`include` | Zweck |
|-------|-----------------|-------|
| `modules/scad/roundedcube.scad` | `use` | Quader mit abgerundeten Ecken |
| `modules/scad/hinge.scad` | `use` | Parametrisches Scharnier |
| `modules/scad/text_on.scad` | `use` | Text auf 3D-Oberflächen |
| `modules/scad/hex_grid_v02.scad` | `use` | Hexagonales Lochraster |
| `modules/scad/din_clip_01.scad` | `use` | DIN-Schienen-Clip |
| `modules/scad/BOSL2/` | `use`/`include` | Umfangreiche Hilfsbibliothek (Schrauben, Formen, Transformationen) |
| `modules/gridfinity/gridfinity-rebuilt-bins.scad` | `use` | Gridfinity-Behälter |
| `modules/gridfinity/gridfinity-rebuilt-baseplate.scad` | `use` | Gridfinity-Grundplatten |

### Include-Regeln

```scad
// include <> lädt Konstanten und alle Definitionen (sparsam verwenden)
include <../../modules/gridfinity/src/core/standard.scad>

// use <> lädt nur Modul-Definitionen (bevorzugt)
use <../../modules/scad/roundedcube.scad>
use <../../modules/scad/BOSL2/metric_screws.scad>
```

- `include <>` nur für Konstantendateien (`standard.scad`).
- `use <>` für alle Module.
- Gridfinity: immer `standard.scad` zuerst includieren.

---

## Häufige OpenSCAD-Muster

### Abgerundete Quader
```scad
use <../../modules/scad/roundedcube.scad>
roundedcube([x, y, z], radius = 2, apply_to = "z");
```

### Weiche Übergänge (Hull)
```scad
hull() {
    linear_extrude(0.01) square([w_bottom, d_bottom], center = true);
    translate([0, 0, height])
        linear_extrude(0.01) square([w_top, d_top], center = true);
}
```

### Differenz mit Toleranz
```scad
_eps = 0.01;
difference() {
    body();
    translate([0, 0, -_eps]) cutout();  // _eps verhindert Render-Artefakte
}
```

### Rasteranordnung
```scad
for (ix = [0 : count_x - 1], iy = [0 : count_y - 1]) {
    translate([ix * spacing_x, iy * spacing_y, 0])
        element();
}
```

### Gridfinity-Behälter
```scad
use <../../modules/gridfinity/gridfinity-rebuilt-bins.scad>

gridfinityInit(gridx = 1, gridy = 1, height = 5, height_internal = 0, length = 42) {
    gridfinityLid();  // optional
}
```

---

## Qualitätskriterien

- **Manifold**: Jedes Modell muss ein geschlossenes, druckbares Solid ergeben.
- **$fn / $fs**: Immer setzen. `$fn = 60` für Standardmodelle; `$fs = 0.15` für komplexe Kurven.
- **Toleranz**: `_eps = 0.01` für Differenz-Operationen verwenden, um Z-Fighting zu vermeiden.
- **Kommentare**: Jeder Parameterblock und jedes nicht-triviale Modul erhält einen Kommentar.
- **Modularität**: Logische Einheiten als eigene `module`-Definitionen kapseln.
- **Kein globaler State in Modulen**: Alle benötigten Werte als Parameter übergeben.

---

## Dateiablage

Neue Modelle gehören in `models/<Kategorie>/<Modellname>/`:
- Hauptdatei: `<modellname>.scad`
- Ressourcen (SVG, DXF) im selben Verzeichnis
- Kategorie passend zur Thematik wählen (z. B. `garden/`, `workshop/`, `keeping order/gridfinity/`)