import os

# Структура проекта
structure = {
    "lib": {
        "main.dart": None,
        "screens": {
            "auth": {
                "login_screen.dart": None,
                "register_screen.dart": None,
            },
            "schedule_screen.dart": None,
            "stats_screen.dart": None,
            "profile_screen.dart": None,
        },
        "widgets": {
            "workout_card.dart": None,
            "stats_row.dart": None,
            "custom_button.dart": None,
        },
        "models": {
            "user_model.dart": None,
            "team_model.dart": None,
            "workout_model.dart": None,
            "stats_model.dart": None,
        },
        "services": {
            "api_service.dart": None,
            "auth_service.dart": None,
            "workout_service.dart": None,
        },
        "providers": {
            "auth_provider.dart": None,
            "user_provider.dart": None,
        },
        "utils": {
            "constants.dart": None,
            "formatters.dart": None,
        },
    }
}


def create_structure(base_path, tree):
    """Рекурсивное создание папок и файлов"""
    for name, content in tree.items():
        path = os.path.join(base_path, name)
        if content is None:
            # Создаем файл
            with open(path, "w", encoding="utf-8") as f:
                f.write("// " + name + "\n")
            print(f"📄 Файл создан: {path}")
        else:
            # Создаем папку
            os.makedirs(path, exist_ok=True)
            print(f"📁 Папка создана: {path}")
            create_structure(path, content)


if __name__ == "__main__":
    base_dir = os.getcwd()  # текущая директория
    print(f"Создание структуры в: {base_dir}")
    create_structure(base_dir, structure)
    print("\n✅ Структура проекта успешно создана!")
