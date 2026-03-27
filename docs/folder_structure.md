# System Base Folder Design

This document defines the foundational folder structure for the English learning app.
No business methods/functions are implemented here.

## Root in `lib/`

- `app/`: app-level setup (router, dependency setup, app shell)
- `bootstrap/`: environment/bootstrap entry wiring
- `core/`: global technical layers
  - `constants/`
  - `errors/`
  - `network/`
  - `storage/`
  - `theme/`
  - `utils/`
  - `services/`
- `shared/`: reusable assets across features
  - `widgets/`
  - `models/`
  - `extensions/`
  - `enums/`
- `features/`: all business modules by feature

## Feature Convention

Each feature has 2 layers of decomposition:

1. Main clean-architecture layers:

- `presentation/`
- `domain/`
- `data/`

2. Functional modules for each use case:

- `modules/<function_name>/presentation/`
- `modules/<function_name>/domain/`
- `modules/<function_name>/data/`

## Implemented Feature Map

- `features/authentication/`
  - modules: `sign_up`, `sign_in`, `forgot_password`, `session`

- `features/home/`
  - modules: `banner`, `search`, `topic_dictionary`, `review_notification`, `featured_words`

- `features/listening/`
  - modules: `podcast`, `interview`

- `features/reading/`
  - modules: `articles`, `fairy_tales`, `books`, `shadowing`

- `features/dictionary/`
  - modules: `saved_words`, `flashcard`, `quiz`, `spaced_repetition`, `statistics`

- `features/gamification/`
  - modules: `xp_level`, `achievements`, `streak`

- `features/entertainment/`
  - modules: `guess_word`, `matching_game`, `ai_mini_games`

- `features/ai_scanner/`
  - modules: `camera_permission`, `object_detection`, `object_detail`

- `features/ai_chatbot/`
  - modules: `chat`, `conversation_practice`, `history`

- `features/profile/`
  - modules: `account`, `learning_stats`, `badges`, `activity_history`

- `features/settings/`
  - modules: `preferences`, `notifications`, `theme`

## Notes

- This structure is intentionally prepared for scalability and independent feature delivery.
- You can implement each module independently without coupling unrelated folders.
- If needed later, add subfolders such as `bloc/`, `cubit/`, `providers/`, `dto/`, `mappers/`, `local/`, `remote/` inside each module layer.
