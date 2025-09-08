# TaskManagerOOP_Omar
SwiftUI task manager demonstrating **OOP + Protocol‑Oriented Design + MVVM** with error handling, unit tests, and lightweight persistence.

---

## 🚀 What this app does
A clean task manager with three task types—**Work**, **Personal**, and **Shopping**—each with slightly different fields. You can:
- Add / edit / delete tasks
- Mark tasks as completed
- Filter by type (tabs: All, Work, Personal, Shopping)
- Set **priority** and an optional **due date**
- Persist data locally (UserDefaults)
- Run unit tests for core logic

---

## 🧭 App Tour (How to use)
### Tabs
- **All**: Every task across categories.
- **Work**: Tasks with an optional **Project** field.
- **Personal**: Tasks with an optional **Tag** (e.g., Health, Family).
- **Shopping**: Items with **Quantity** and **Unit** (e.g., 2 L milk).

### Create a Task
1. Open the tab where you want to add the task (or stay on **All**).
2. Tap **＋** (top-right).
3. Fill in:
   - **Title** (required) & **Notes** (optional)
   - **Priority**: Low / Medium / High
   - **Has due date** → pick a date/time (optional)
   - **Kind**: Work / Personal / Shopping
     - **Work** → add **Project**
     - **Personal** → add **Tag**
     - **Shopping** → set **Quantity** and **Unit**
4. Tap **Save**.

> ⚠️ Validation
> - Empty title is not allowed.
> - Two tasks cannot share the **same title** (duplicate protection).
> - Due date cannot be **before** the creation date.

### Edit a Task
- Tap a row to open its details in the form, adjust fields, **Save**.

### Complete / Reopen a Task
- Tap the **circle** icon to toggle completion. Completed tasks show a **checkmark** and **strikethrough** title.

### Delete a Task
- Swipe row **left** → **Delete**.

### Sorting
Tasks are sorted by:
1. **Priority** (High first)
2. **Due date** (earliest first)
3. **Last updated** (most recent first)

---

## 🧩 Architecture (What to mention in your report)
- **OOP:** 
  - Base class: `BaseTask`
  - Subclasses: `WorkTask`, `PersonalTask`, `ShoppingTask`
- **Protocols:** 
  - `Completable` (toggle complete)
  - `Schedulable` (due date)
  - `Prioritizable` (priority)
  - `DTOConvertible` (persistence bridge)
- **MVVM:**
  - `TaskListViewModel` mediates between `TaskStore` and views.
  - Views: `ContentView`, `TaskListScreen`, `TaskRow`, `TaskForm`.
- **Persistence:** 
  - `PersistedTaskDTO` encodes to JSON in **UserDefaults** via `TaskStore`.
- **Error handling:** 
  - `TaskError` covers empty title, duplicate title, invalid date, persistence failures.
  - User‑facing alerts appear for failures in add/update/delete.

---

## 🧪 Running Tests
1. Ensure the test file is in the **Tests target**.
2. If your app target name differs, update the line in tests:
   ```swift
   @testable import <YourAppTargetName>
   ```
3. Run tests with **⌘U**.

### What’s tested
- Duplicate title rejection
- Completion toggling updates timestamps
- DTO round‑trip rebuilds the right concrete type

---

## 🛠 Developer Notes
- **Seeding:** On first launch, a few demo tasks are inserted.
- **State updates:** Mutations go through `TaskStore.update(_:mutate:)` so we can validate, stamp `updatedAt`, and then persist.
- **Date helper:** `Date.days(_:)` for simple relative dates.

---

## 🧯 Troubleshooting
- **“Invalid redeclaration of ContentView”**: Remove Xcode’s template `ContentView.swift` (keep this project’s version).
- **“Cannot find ‘TaskListScreen’ in scope”**: Check **Target Membership** for `TaskListScreen.swift` (should be in the **app target**).
- **“No such module ‘XCTest’”**: Ensure tests are **not** in the app target; they belong to the **Tests** target.
- **“Multiple commands produce …”**: Remove duplicate files in **Build Phases → Compile Sources/Copy Bundle Resources**.
- **Development assets path error**: Either remove the non‑existent `Preview Content` from **Build Settings**, or create a *Preview Content* group with an asset catalog.
- **Text/Date compile error in row**: The due date label uses `Text(due, style: .date)`.

---

## 📦 Project Structure
```
Domain/            // protocols, enums, errors, BaseTask + subclasses
Persistence/       // DTO + TaskStore (UserDefaults)
ViewModels/        // TaskListViewModel
Views/             // ContentView, TaskListScreen, TaskRow, TaskForm
Utilities/         // Date+Extensions
Tests/             // Unit tests
```

---

##Github Link
- https://github.com/ramomarar/TaskManagerOOP_Omar-main/edit/main/README.md
