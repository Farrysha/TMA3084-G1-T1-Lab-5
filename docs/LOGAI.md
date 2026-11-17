# AI Usage Log

**Project:** StudentHub — TMA3084 Software Engineering Laboratory, Lab Exercise 5.1
**Component:** Home page (`Screen1`), student list (`Screen2`), student details (`Screen2_1`),student records (`Screen3`), About page (`about.dart`), navigation host (`main.dart`), image assets, GitHub Actions CI
**Date:** 15 November 2026

This log records AI assistance used while building StudentHub. Each entry states the prompt given, what the tool proposed, and which suggestions were accepted or rejected, with reasons.

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

# Amirul Asyraf bin Abdullah Yusup (103295) - SCREEN 2: STUDENT LIST & FILTERING
## 1. Refactoring Student Detail Navigation to Match Team Boundaries — Claude

- **AI Tool:** Claude
- **Prompt Used:**
  > "Add navigation to Student Details without building the entire details page (no pop-up dialog), and then remove the inline `Navigator.push` stub code since navigation is handled via `import 'screen2_1.dart';`."
- **Generated Suggestions:**
  - Initially suggested an `AlertDialog` pop-up, then provided a minimal `Navigator.push` stub (`StudentDetailPage`), and finally removed the inline navigation stub and `onTap` handler once `screen2_1.dart` was imported.
- **Accepted Changes:**
  - Removed the `AlertDialog` and inline `StudentDetailPage` stub from `screen2.dart` while keeping `import 'screen2_1.dart';`.
- **Rejected Changes:**
  - The `AlertDialog` pop-up and inline `StudentDetailPage` class were rejected because the student details screen is maintained separately in `screen2_1.dart`.
- **Reasons for Decisions:**
  - Keeps module boundaries clean between Screen 2 and Screen 2.1 for team integration.

## 2. Cleaning Up Student Map Fields and ListTile Layout — Claude

- **AI Tool:** Claude
- **Prompt Used:**
  > "Remove the unnecessary email field from the student dataset and `ListTile` subtitle in `screen2.dart` so only the profile icon, student name, matric number, and programme are displayed."
- **Generated Suggestions:**
  - Suggested removing the `'email'` key-value pairs from every map entry in `_allStudents`.
  - Recommended simplifying the `ListTile` `subtitle` `Column` to render only `'Matric No: ${student['id']}'` and `'Programme: ${student['programme']}'`.
- **Accepted Changes:**
  - Removed all `'email'` fields from `_allStudents` and updated the `ListTile` subtitle layout accordingly.
- **Rejected Changes:**
  - None.
- **Reasons for Decisions:**
  - Keeps the list cards clean, readable, and aligned with the required data attributes for Screen 2.

## 3. Refining UI Visuals and Modernizing Color Opacity in Screen 2 — Claude

- **AI Tool:** Claude
- **Prompt Used:**
  > "improvised or refine my code to make it visually better"
- **Generated Suggestions:**
  - Suggested adding dynamic, color-coded programme badge tags and matching `CircleAvatar` icons for each academic category (Software Engineering, Data Networking, Computer Science).
  - Recommended polishing the search bar with subtle background container styling, rounded borders, and an icon-backed empty state placeholder.
  - Advised replacing deprecated `.withOpacity()` method calls with modern `.withValues(alpha:)` syntax to prevent precision loss warnings in current Flutter analyzers.
- **Accepted Changes:**
  - Added department-specific color styling and visible programme badge tags inside the student cards.
  - Upgraded all opacity modifier calls to use `.withValues(alpha:)`.
  - Implemented the polished search bar container and `Icons.search_off_rounded` empty state view.
- **Rejected Changes:**
  - None.
- **Reasons for Decisions:**
  - Elevates the visual polish and user experience of the student directory while maintaining a clean codebase free of deprecation warnings.
---
# Ellyanaironie (106980) - SCREEN 2_1: STUDENT DETAILS
## 1. Matching Student List - Claude

- **AI Tools:** Claude
- **Prompt Used:**
  > "Can you help me so that student list page can open the student detail? The is the code for student list screen : [full file pasted]"
- **Generated Suggestions:**
   - Explained that student list screen stores each student as a `Map` with the keys `name`, `id` and `programme`, and already calls `StudentDetailPage(student: student)`.
   - The page was changed to take `final Map student` and to use the same class name, so their `onTap` works unchanged.
   - Null-safe reads such as `student['name']?.toString() ?? 'Unknown'`, so a missing key shows "-" instead of crashing.
   - Because there is no `email` key in their data, the email is generated from the matric number when it is missing.
- **Accepted Changes:**
   - Taking `Map student`, keeping the class name `StudentDetailPage`, the null-safe reads and the generated email fallback.
- **Rejected Changes:**
   - Passing name, matric number, programme and email as four separate constructor parameters: it would not match student list screen's existing call.
   - Hardcoded default values inside the page: it would show the same student every time, and the lab requires the details to change for the selected student.
- **Reasons for Decisions:**
   - Matching the existing call means no change is needed in student list screen's code.
   - A `Map` read with `?? '-'` cannot throw on a missing key, which covers the null safety point in the lab.
   - The generated email is a placeholder, not stored data. This is stated here so it is not mistaken for real student data.

## 2. Connecting Student List to Student Details - Claude

- **AI Tools:** Claude
- **Prompt Used:**
  > "How can i make sure so that my student details page is not missing?"
- **Generated Suggestions:**
  - Screen 2's list already navigates with `StudentDetailPage(student: student)`, not need to write the navigation again.
  - Two small changes were needed in Member 2's file: delete their placeholder `StudentDetailPage` class at the bottom, and add `import 'screen2_1.dart';` at the top.
  - The `ListTile` needed its `onTap` and `trailing` so the import is actually used.
- **Accepted Changes:**
  - Requesting Member 2 to remove their placeholder and add `import 'screen2_1.dart';`.
- **Rejected Changes:**
  - Editing `screen2.dart` myself inside my own PR: it is Member 2's file, and doing so would risk a merge conflict and mix our contributions.
-**Reasons for Decisions:**
  - My class name and `Map student` parameter match what Member 2 already calls, so only the import and the placeholder removal were needed on their side.
  - Each file stays with its owner to avoid conflicts.
  - After Member 2's change the list opens my page.

---
# Muhammad Daniel (102730) - SCREEN 3: STUDENT RECORDS & SORTING
## 1. Evaluating the Sort Helper and the Map-Based Data — Claude

- **AI Tool:** Claude
- **Prompt Used:**
  > "Evaluate my `_sort` function and the way I store the students as a list of maps? Is there any risk? Here is my screen3.dart: [full file pasted]"
- **Generated Suggestions:**
  - Confirmed that `a[key].compareTo(b[key])` works for every column because `String` and `double` both implement `compareTo`, and that negating the result is a valid way to reverse the order.
  - Pointed out that the map is `Map<String, dynamic>`, so `a[key]` is checked at runtime, not compile time: a mistyped key such as `'programe'` would compile and then crash when a header is tapped.
  - Suggested replacing the maps with a small `Student` class (`name`, `id`, `programme`, `cgpa` as typed final fields) so the compiler catches wrong keys and wrong types.
  - Noted that Dart's `List.sort` is not guaranteed to be stable, so students with the same programme may swap places between sorts, and suggested an optional tie-break on `name`.
  - Noted that `compareTo` on strings is case-sensitive; this is harmless here because every name starts with a capital letter, but it would matter if lowercase names were entered.
- **Accepted Changes:**
  - The evaluation of `_sort` was kept as writtens.
- **Rejected Changes:**
  - The `Student` class was rejected. All four keys are used only inside `Screen3`, and the six records carried over from Screen 2.
  - The `name` tie-break was not added since it's uneccessary
- **Reasons for Decisions:**
  - Every key string appears in exactly one place per column (`'name'`, `'id'`, `'programme'`, `'cgpa'`), so the typo risk is trivial.
  - The `Student` class is recorded as the first thing to do if the data later moves.
 
## 2. Improving Structure and Comments (`_sort` vs `_onSort`) — Claude

- **AI Tool:** Claude
- **Prompt Used:**
  > "Can you review how I organise the sorting code in `_Screen3State` and suggest improvements to readability? I want it easy to explain in my report."
- **Generated Suggestions:**
  - Keep `_sort` (the pure list ordering) separate from `_onSort` (the tap handler that calls `setState`), so `initState()` can call `_sort` directly without `setState`, which is unnecessary before the first build.
  - Keep `_sortColumnIndex` and `_sortAscending` as the only sort state, since the `DataTable` needs exactly those two values to draw the arrow.
  - Add short comments above `_sort`, `_onSort` and the `DataTable` sort arguments, describing what each does rather than restating the code.
  - Leave a comment above the data list explaining that the first six records came from Screen 2, the next five are new, and the last two were added later.
- **Accepted Changes:**
  - The `_sort` / `_onSort` split, the two state fields, and the explanatory comments.
- **Rejected Changes:**
  - No suggestions were rejected.
- **Reasons for Decisions:**
  - Calling `_sort` from `initState` means the first frame is already sorted and the arrow on the Name column consistent with the row order.
  - One handler that updates the state and re-sorts in a single `setState` stops the arrow and the rows from falling out of sync.
  - Comments that explain intent make the code easier to defend in a code review than comments that just repeat the line below them.

## 3. Keeping the Sort Order When Switching Tabs — Claude

- **AI Tool:** Claude
- **Prompt Used:**
  > "If I sort the table by CGPA, go to the Home tab and come back, will the sort be lost? How do I make Screen3 remember it?"
- **Generated Suggestions:**
  - Explained that the sort order lives in `_Screen3State`, and a State object is only lost if the widget is removed from the tree and rebuilt.
  - Checked `main.dart`: the tabs are shown through an `IndexedStack`, which keeps all four children mounted, so `_students`, `_sortColumnIndex` and `_sortAscending` already survive a tab switch with no code in `Screen3`.
  - Described the alternatives that would be needed if the tabs were swapped with `body: tabs[_currentIndex]`: `AutomaticKeepAliveClientMixin` with `wantKeepAlive => true`, or saving the sort state in the parent.
  - Warned that the sort state would still be lost when the app is fully closed, since nothing is persisted to storage.
- **Accepted Changes:**
  - No change to `screen3.dart`; the behaviour comes from the `IndexedStack` already added in `main.dart`.
- **Rejected Changes:**
  - `AutomaticKeepAliveClientMixin` and storing the sort in the parent were rejected as unnecessary.
  - Persisting the sort order with local storage was rejected as outside the scope.
- **Reasons for Decisions:**
  - Adding keep-alive code to `Screen3` would duplicate what `IndexedStack` already does and would add a second mechanism for the same behaviour.
  - Remembering the sort across app restarts is not part of the lab requirements, and the table opens sorted A–Z by name, which make sense.

---

# Darrel Deo Jaip (106946) - SCREEN 4: ABOUT PAGE & CI

## 1. Matching the About Page Specification — ChatGPT
- **AI Tool:** ChatGPT

- **Prompt Used:**
  > "Adjust accordingly." (with the about.dart attached)

- **Generated Suggestions:**
  - Restructured `about.dart` according to the required document sections: a header containing the logo, StudentHub title, tagline ("Your Student Information, Simplified."), and Version 1.0.0; an About StudentHub description; a Key Features section with icons; Development Information (Group G1-T1, Software Engineering Laboratory, UNIMAS, Flutter, and Dart); and a footer displaying the application version, copyright notice, and "Made with ❤️ using Flutter".
  - Retained the layered `Stack` header required by the lab specification and extracted `_AppHeader`, `_SectionCard`, `_FeatureTile`, `_InfoRow`, and `_Footer` into separate reusable private widgets.
  - Added an `errorBuilder` to the logo's `Image.asset` implementation to display a fallback school icon if the image asset cannot be loaded.
  - Updated `widget_test.dart` to ensure that its text expectations matched the revised About Page content.

- **Accepted Changes:**
  - Adopted the revised section layout, reusable private widgets, logo fallback mechanism, and updated widget test.

- **Rejected Changes:**
  - None

- **Reasons for Decisions:**
  - The widget test relies on matching specific text strings. Therefore, retaining outdated text expectations, such as "About this application" and the previous matriculation checks, could cause the automated tests to fail after the page content was revised.
  - Separating the page into smaller reusable widgets improves code readability and maintainability. It also allows individual sections to be modified without unnecessarily changing the entire page.
  - Retaining the layered `Stack` header ensures compliance with the lab's design requirements while preserving the intended visual appearance.

  ## 2. Building the About Page and CI Workflow – ChatGPT

- **AI Tool:** ChatGPT

- **Prompt Used:**
  > "My task is About Page and CI, help." (with the Lab 5 instruction document attached)

- **Generated Suggestions:**
  - Replaced the placeholder About screen with `Screen4` in `lib/about.dart`, using a `Stack` layout to position the banner, logo, and title together.
  - Developed the initial page content, including an application description and a list of key features.
  - Created `.github/workflows/ci.yml` based on the lab's sample workflow. It automatically runs `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, and `flutter test` whenever code is pushed or a pull request is created.
  - Replaced the original counter widget test with a test that launches the application and checks the About tab.
  - Resolved analyzer issues that could cause the CI workflow to fail, including a string issue on the Home page and a missing `const` constructor on the placeholder student-list page.

- **Accepted Changes:**
  - Implemented the `Stack`-based header, CI workflow, replacement widget test, and necessary analyzer fixes.

- **Rejected Changes:**
  - None.

- **Reasons for Decisions:**
  - The assigned task involved developing the About Page and implementing CI, while the existing branch still contained a placeholder screen displaying only "About" and did not have a CI workflow file.
  - The original counter widget test was intended for the default Flutter demo application and did not reflect the actual StudentHub application. Therefore, it needed to be replaced with a test relevant to the implemented application.
  - Formatting and static analysis checks apply to the entire project. Any formatting or analysis failure could cause the CI workflow to fail, so the identified issues needed to be resolved before the changes could pass the automated checks.

