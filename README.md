# HomeLibrary - README

## Project Tree:
```
.
├── docs
├── gradle
│   └── wrapper
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── .kotlin
│   └── sessions
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── alexschexc
│   │   │           └── HomeLibrary
│   │   ├── kotlin
│   │   │   └── com
│   │   │       └── alexschexc
│   │   │           └── HomeLibrary
│   │   │               └── HomeLibraryApplication.kt
│   │   └── resources
│   │       ├── static
│   │       ├── templates
│   │       └── application.properties
│   └── test
│       └── kotlin
│           └── com
│               └── alexschexc
│                   └── HomeLibrary
│                       └── HomeLibraryApplicationTests.kt
├── build.gradle.kts
├── .gitattributes
├── .gitignore
├── gradlew
├── gradlew.bat
├── HELP.md
├── README.md
├── settings.gradle.kts
└── shell.nix
```

## Why This Project Uses Both Kotlin and Java

This project intentionally mixes Kotlin and Java in a single Gradle build to demonstrate comfort with both languages on the JVM, and to apply each where its strengths are the clearest fit — rather than mixing them arbitrarily.

### Kotlin — Data Layer (`Book`, `Person`, `Loan`)

The JPA entity classes are written in Kotlin to take advantage of `data class`, which generates `equals()`, `hashCode()`, `toString()`, and constructor-based properties automatically. In Java, the same entities would require substantially more boilerplate to achieve equivalent correctness and readability.

Because JPA requires entities to have a no-arg constructor and non-`final` classes/properties — constraints Kotlin classes don't satisfy by default — this project applies the `kotlin("plugin.jpa")` and `kotlin("plugin.spring")` Gradle plugins, which generate the necessary scaffolding automatically at compile time.

### Java — Service Layer (`LibraryService`)

The business logic layer — lending books, processing returns, enforcing copy-availability rules, and searching the catalog — is written in Java. This layer contains the project's actual decision-making logic (for example, rejecting a loan request when all copies of a title are already checked out), and is kept separate from the data model it operates on.

### How the Interop Works

Gradle compiles Kotlin sources before Java sources by default, which means Java code can freely reference already-compiled Kotlin classes with zero additional build configuration. This project's language split (Kotlin entities → Java service layer) follows that natural compilation order intentionally: `LibraryService` (Java) depends on `Book`, `Person`, and `Loan` (Kotlin), not the other way around, so no custom `dependsOn` task wiring is required in `build.gradle.kts`.

| Layer | Language | Reasoning |
|---|---|---|
| Entities (`Book`, `Person`, `Loan`) | Kotlin | Concise `data class` syntax; less boilerplate for equality, hashing, and immutability |
| Service (`LibraryService`) | Java | Explicit, verbose business logic is easier to review and test; demonstrates traditional Spring service-layer conventions |

This structure reflects a deliberate architectural choice, not a limitation of either language — both are fully interoperable on the JVM, and the split here is meant to showcase idiomatic use of each.
