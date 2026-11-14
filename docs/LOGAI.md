# AI Usage Log

**Project:** StudentHub — TMA3084 Software Engineering Laboratory, Lab Exercise 5.1
**Component:** Home page (`Screen1`), navigation host (`main.dart`), image assets
**Date:** 15 November 2026

This log records AI assistance used while building the StudentHub home page and its supporting navigation and assets. Each entry states the prompt given, what the tool proposed, and which suggestions were accepted or rejected, with reasons.

---
# Farrysha (107018) - HOME PAGE & BOTTOM DRAWER NAVIGATION
## 1. Redesigning the Home Page (`Screen1`) — Claude

- **AI Tool:** Claude
- **Prompt Used:**
  > "Can you help refine my coding according into a better homepage? Icons and images provided as png. The following here is my coding, do NOT change the class name."

- **Generated Suggestions:**
  - Replaced the single `Text` widget with a portal layout: gradient background, logo, title and subtitle header, hero illustration, and three tappable "Quick Access" cards.
  - Extracted a private `_MenuCard` widget for the repeated card row, instead of copying the same `Row` three times.
  - Wrapped the body in `SafeArea` + `SingleChildScrollView` so the content cannot overflow on small screens.
  - Added an `errorBuilder` to every `Image.asset` call so a missing PNG falls back to a Material icon rather than throwing.
  - Declared brand colours as `static const Color` fields rather than repeating hex literals.
  - Deliberately omitted a `Scaffold` inside `Screen1` so the parent's AppBar and BottomNavigationBar keep control.
- **Accepted Changes:**
  - The full layout rewrite, the `_MenuCard` extraction, the scroll/safe-area wrapper, the `errorBuilder` fallbacks, and the named colour constants.
  - The no-`Scaffold` decision, which later proved necessary when the widget was mounted as a tab body.
- **Rejected Changes:**
  - The first generated version contained an invalid expression, `MediaQuery.of(context).size.height * 0.22 clampedTo: 0`, which is not Dart. It was corrected to `(MediaQuery.of(context).size.height * 0.22).clamp(140.0, 220.0)` before the file was used.
  - The generated file was re-indented to match the project's existing formatting.
- **Reasons for Decisions:**
  - The class name constraint was non-negotiable because `main.dart` already imports and instantiates `Screen1`; renaming it would break the tab list.
  - `_MenuCard` removes triplicated markup, so a styling change is made in one place — relevant to the maintainability criteria of the exercise.
  - The invalid `clampedTo` expression confirms that AI output must be compiled before it is trusted; it would have failed `flutter analyze` in the CI step of this lab.

---

## 2. Fixing the Disappearing Bottom Navigation Bar — Claude

- **AI Tool:** Claude
- **Prompt Used:**
  > "It's missing the bottom navigation drawer when i navigate to other pages. here is my main.dart: [full file pasted]"
- **Generated Suggestions:**
  - Diagnosed the cause: `Navigator.push` places a new route on top of the existing `Scaffold`, and the `BottomNavigationBar` belongs to that Scaffold, so it is covered along with everything else.
  - Replaced push navigation with tab switching: restored the `onNavigate` callback on `Screen1` and had each card call `_go(context, index, label)`.
  - Added `_goToTab(int)` to `_MyAppState`, holding the `setState`, and reused it for both the cards and the `BottomNavigationBar`'s `onTap`.
  - Moved the `tabs` list from a `final` field on the State into `build()`, so `Screen1(onNavigate: _goToTab)` could be constructed.
  - Replaced `body: tabs[_currentIndex]` with an `IndexedStack`, keeping all four tabs mounted.
  - Removed the `Center()` wrappers around each tab.
  - Changed the View Students item's icon from `Icons.access_alarm` to `Icons.people_alt_rounded`, and set `unselectedItemColor: Colors.white70`.
- **Accepted Changes:**
  - All of the above, including the `IndexedStack` and the removal of the `Center()` wrappers.
- **Rejected Changes:**
  - No suggestions from this iteration were rejected; this entry instead records the reversal of the push-navigation code accepted in entry 3.
- **Reasons for Decisions:**
  - The three card destinations are already tabs, so a drill-down route duplicated content that the bottom bar could already reach. Switching the index keeps one navigation model instead of two.
  - `tabs` as a `final` field was constructed before `_goToTab` was reachable, so the callback could not have been passed from there.
  - `IndexedStack` keeps each tab's state alive, so scroll position and the sort order on the records table survive a tab switch — a visible improvement over rebuilding the tab each time.
  - `Center` shrink-wraps its child, which prevented the home page's gradient background from filling the body.
  - `Icons.access_alarm` on a "View Students" item was left over from the lab template and did not describe the destination; the default unselected label colour is dark grey, which is illegible on a blue bar.

---

## 3. Fitting the Hero Image — Claude

- **AI Tool:** Claude
- **Prompt Used:** three prompts across one iteration —
  > "my image is too small for a hero image for students.png"

  > "it doesnt show the face. can you help generate a real life diversity of university students for this image?"

  > "here's the image, please work around it"
- **Generated Suggestions:**
  - Diagnosed the first problem: `BoxFit.contain` on a portrait image inside a short box shrinks it to a narrow strip. Changed to `BoxFit.cover` with `width: double.infinity`, wrapped in a `ClipRRect` with a 20px radius, and raised the box height.
  - Added `alignment: Alignment(0, -0.2)` to bias the crop upward after faces were still being cut off.
  - Stated plainly that it cannot generate photographs, and listed properly licensed sources (Pexels, Unsplash, Pixabay) plus search terms for landscape group shots.
  - Once a photograph was supplied, cropped the 852×1846 source to 1200×1211 so all five faces sit in frame, and rewrote `_buildHero` to use `AspectRatio(aspectRatio: 1.0)` instead of a clamped pixel height.
  - Supplied a JPEG alternative at 228 KB against the PNG's 1.6 MB.
- **Accepted Changes:**
  - The cropped 1200×1211 image, the `AspectRatio` rewrite, and the `ClipRRect` rounding.
- **Rejected Changes:**
  - The `alignment: Alignment(0, -0.2)` crop-biasing approach was abandoned. Tuning the alignment treated the symptom; cropping the source file removed the mismatch entirely.
  - The clamped `MediaQuery` height calculation from entry 1 was removed once the image and its box shared an aspect ratio.
- **Reasons for Decisions:**
  - A square image in a square box crops nothing, so the layout scales to any phone width without alignment tuning. Fixing the asset was simpler than compensating for it in code.
  - Photographs compress far better as JPEG; a 1.6 MB home-page image is hard to defend in a code review. PNG was retained only for the flat-colour logo, where it genuinely wins.
  - The AI declined to generate a photograph rather than producing something unusable, which saved an iteration.
  - Provenance was noted for the report: the supplied photograph appears to be AI-generated, which should be stated rather than left for an examiner to infer.

---

# Screen 2
