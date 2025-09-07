# Smart Trip Planner (Flutter)

A natural-language trip planning app built with **Flutter 3.x**.  
Users can describe a trip (e.g., *“5 days in Kyoto next April, solo, mid-range budget”*), and the app generates a **day-by-day itinerary** with activities, maps, and dining suggestions.  
Supports real-time refinement, offline storage, and web search integration for up-to-date info.

---

# 🎥 Demo
https://www.loom.com/share/d3809d7100d34e81b7d8733fff6284cf?sid=c49a97ed-ea7d-4ecb-9668-3d20e3b6951f
---


## ✨ Features
- **Create Trip via Chat**: Generate itineraries in natural language with AI (OpenAI, Gemini, or Ollama).
- **Refine Plans**: Modify itineraries via follow-up chat; UI highlights changes.
- **Save**: Store itineraries locally using Hive and access offline.
- **Streaming UI**: Chat-like typing effect for AI responses.
- **Web Search Integration**: Enrich itineraries with real-time restaurant, hotel, or activity data.
- **Maps Integration**: Tap any itinerary location to open Google/Apple Maps.

---

## 🧩 Core User Stories (MVP)

| ID  | Story              | Acceptance Criteria |
|-----|-------------------|----------------------|
| S-1 | Create trip via chat | From chat screen, prompt generates structured JSON itinerary (Spec A) rendered as cards |
| S-2 | Refine itinerary | Follow-up chat updates JSON + highlights changes |
| S-3 | Save & revisit | Save button writes itinerary to DB; home list shows trips |
| S-4 | Offline view | Cached trips open; new chat fails gracefully offline |
| S-5 | Basic metrics | Log tokens per request; show overlay |

---

🚀 Setup
Prerequisites
Flutter 3.x
Dart SDK (bundled with Flutter)
Android Studio / Xcode

Install & Run
# Clone the repo
cd smart_trip_planner_flutter

# Install dependencies
flutter pub get

# Run
flutter run

# Firebase 
flutterfire configure

# 🏗 Architecture

lib/
 ┣ Src/        
   ┣ core/      # Entities, use-cases, validators
   ┣ features/  #BLoC, UI widgets, screens


# 🔗 Agent Chain (How It Works)
User sends: prompt + previous itinerary JSON 
Agent calls LLM with calling schema for Spec A
Response is validated against JSON schema; retries if invalid
Client renders new itinerary + logs token metrics


# Architecture
Flutter App
├── Agent Wrapper ──> LLM (Gemini)
│ └── JSON Validator
│
├── Local DB (Hive) ← Save & offline access
├── Maps Intent ← Open coordinates
└── Chat + Itinerary UI ← Streams responses, highlights changes

