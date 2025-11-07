package com.example.basketballapp;

import com.example.basketballapp.model.Role;
import com.example.basketballapp.model.Training;
import com.example.basketballapp.model.User;
import com.example.basketballapp.repository.TrainingRepository;
import com.example.basketballapp.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.OffsetDateTime;

@Configuration
public class DataInitializer {
    private static final Logger log = LoggerFactory.getLogger(DataInitializer.class);

    @Bean
    CommandLineRunner initData(UserRepository userRepository, TrainingRepository trainingRepository, PasswordEncoder encoder) {
        return args -> {
            // ============ СОЗДАНИЕ ПОЛЬЗОВАТЕЛЕЙ ============
            User coach = null;
            if (!userRepository.existsByUsername("coach@gmail.com")) {
                coach = new User("coach@gmail.com", encoder.encode("coach123"), Role.COACH);
                userRepository.save(coach);
                log.info("✅ Создан тренер: coach@gmail.com / coach123");
            } else {
                // username is stored as email (coach@gmail.com) — use the same key
                coach = userRepository.findByUsername("coach@gmail.com").orElseThrow();
                log.info("ℹ️ Тренер уже существует");
            }

            if (!userRepository.existsByUsername("nurali@gmail.com")) {
                User player1 = new User("nurali@gmail.com", encoder.encode("player123"), Role.USER);
                userRepository.save(player1);
                log.info("✅ Создан игрок 1: player1 / player123");
            }

            if (!userRepository.existsByUsername("player@gmail.com")) {
                User player2 = new User("player@gmail.com", encoder.encode("player123"), Role.USER);
                userRepository.save(player2);
                log.info("✅ Создан игрок 2: player2 / player123");
            }

            // ============ СОЗДАНИЕ ТРЕНИРОВОК ============
            if (trainingRepository.count() == 0) {
                OffsetDateTime now = OffsetDateTime.now();

                // 1️⃣ Сегодня - Утренняя тренировка (через 2 часа)
                Training training1 = new Training();
                training1.setTitle("Утренняя тренировка");
                training1.setDescription("Разминка и работа над броском с дальней дистанции. Идеально для совершенствования техники.");
                training1.setStartsAt(now.plusHours(2));
                training1.setEndsAt(now.plusHours(3).withMinute(30));
                training1.setCapacity(12);
                training1.setCoach(coach);
                trainingRepository.save(training1);
                log.info("✅ Тренировка 1: Утренняя тренировка");

                // 2️⃣ Сегодня - Вечерняя тренировка (через 6 часов)
                Training training2 = new Training();
                training2.setTitle("Вечерняя тренировка");
                training2.setDescription("Интенсивная тренировка с акцентом на защиту и быстрый переход в атаку. Уровень сложности: высокий.");
                training2.setStartsAt(now.plusHours(6));
                training2.setEndsAt(now.plusHours(7).withMinute(30));
                training2.setCapacity(15);
                training2.setCoach(coach);
                trainingRepository.save(training2);
                log.info("✅ Тренировка 2: Вечерняя тренировка");

                // 3️⃣ Завтра - Тренировка для новичков
                Training training3 = new Training();
                training3.setTitle("Тренировка для новичков");
                training3.setDescription("Базовые навыки обращения с мячом, стойка, передачи. Идеально подходит для начинающих игроков.");
                training3.setStartsAt(now.plusDays(1).withHour(10).withMinute(0));
                training3.setEndsAt(now.plusDays(1).withHour(11).withMinute(30));
                training3.setCapacity(10);
                training3.setCoach(coach);
                trainingRepository.save(training3);
                log.info("✅ Тренировка 3: Тренировка для новичков");

                // 4️⃣ Послезавтра - Товарищеский матч
                Training training4 = new Training();
                training4.setTitle("Товарищеский матч");
                training4.setDescription("Товарищеский матч между двумя командами. Все уровни подготовки приветствуются. Полноценный 5х5 матч.");
                training4.setStartsAt(now.plusDays(2).withHour(18).withMinute(0));
                training4.setEndsAt(now.plusDays(2).withHour(20).withMinute(0));
                training4.setCapacity(20);
                training4.setCoach(coach);
                trainingRepository.save(training4);
                log.info("✅ Тренировка 4: Товарищеский матч");

                // 5️⃣ Через 3 дня - Интенсивный интервальный тренинг
                Training training5 = new Training();
                training5.setTitle("Интенсивный интервальный тренинг");
                training5.setDescription("Работа над выносливостью и максимальной скоростью. Включает спринты, челночный бег. ОЧЕНЬ ТЯЖЕЛАЯ тренировка!");
                training5.setStartsAt(now.plusDays(3).withHour(19).withMinute(0));
                training5.setEndsAt(now.plusDays(3).withHour(20).withMinute(30));
                training5.setCapacity(8);
                training5.setCoach(coach);
                trainingRepository.save(training5);
                log.info("✅ Тренировка 5: Интенсивный интервальный тренинг");

                // 6️⃣ Через 5 дней - 3х3 баскетбол
                Training training6 = new Training();
                training6.setTitle("Турнир 3х3 баскетбол");
                training6.setDescription("Турнир в формате 3х3. Быстрые экспресс-матчи по 10 минут каждый. Красивый баскетбол на укороченной площадке!");
                training6.setStartsAt(now.plusDays(5).withHour(17).withMinute(0));
                training6.setEndsAt(now.plusDays(5).withHour(19).withMinute(0));
                training6.setCapacity(12);
                training6.setCoach(coach);
                trainingRepository.save(training6);
                log.info("✅ Тренировка 6: Турнир 3х3 баскетбол");

                // 7️⃣ Через 7 дней - Мастер-класс
                Training training7 = new Training();
                training7.setTitle("Мастер-класс: Техника трёхочкового броска");
                training7.setDescription("Специальный мастер-класс от опытного коуча по совершенствованию трёхочковой линии. Группа: не более 6 человек.");
                training7.setStartsAt(now.plusDays(7).withHour(15).withMinute(0));
                training7.setEndsAt(now.plusDays(7).withHour(16).withMinute(30));
                training7.setCapacity(6);
                training7.setCoach(coach);
                trainingRepository.save(training7);
                log.info("✅ Тренировка 7: Мастер-класс");

                // 8️⃣ Прошлая тренировка (закрыта)
                Training training8 = new Training();
                training8.setTitle("Тренировка на выбывание");
                training8.setDescription("Эта тренировка уже прошла. Для нее нельзя записаться.");
                training8.setStartsAt(now.minusDays(1).withHour(18).withMinute(0));
                training8.setEndsAt(now.minusDays(1).withHour(19).withMinute(30));
                training8.setCapacity(10);
                training8.setCoach(coach);
                trainingRepository.save(training8);
                log.info("✅ Тренировка 8: Прошлая тренировка (недоступна)");

                log.info("\n╔════════════════════════════════════════════════════════════╗");
                log.info("║                  🏀 ДАННЫЕ УСПЕШНО ЗАГРУЖЕНЫ 🏀             ║");
                log.info("╠════════════════════════════════════════════════════════════╣");
                log.info("║ УЧЕТНЫЕ ДАННЫЕ ТРЕНЕРА:                                    ║");
                log.info("║   Логин:    coach@gmail.com                                 ║");
                log.info("║   Пароль:   coach123                                       ║");
                log.info("║                                                            ║");
                log.info("║ УЧЕТНЫЕ ДАННЫЕ ИГРОКОВ:                                    ║");
                log.info("║   Логин:    player1 или player2                            ║");
                log.info("║   Пароль:   player123 (для обоих)                          ║");
                log.info("║                                                            ║");
                log.info("║ 📋 СОЗДАНО:                                                ║");
                log.info("║   ✅ 3 пользователя (1 тренер + 2 игрока)                  ║");
                log.info("║   ✅ 8 тренировок с разными сценариями                     ║");
                log.info("║   ✅ Включены: предстоящие, прошлые, полные, пустые        ║");
                log.info("║                                                            ║");
                log.info("║ 💡 КАК ИСПОЛЬЗОВАТЬ:                                       ║");
                log.info("║   1. Залогиньтесь тренером (coach/coach123)               ║");
                log.info("║   2. Создавайте новые тренировки кнопкой +                 ║");
                log.info("║   3. Залогиньтесь игроком (player1/player123)             ║");
                log.info("║   4. Записывайтесь на тренировки                           ║");
                log.info("║   5. Посмотрите статистику на вкладке \"Статистика\"        ║");
                log.info("╚════════════════════════════════════════════════════════════╝\n");
            }
        };
    }
}