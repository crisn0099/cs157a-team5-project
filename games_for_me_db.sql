CREATE DATABASE  IF NOT EXISTS `games_for_me` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `games_for_me`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: games_for_me
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_action_log`
--

DROP TABLE IF EXISTS `admin_action_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_action_log` (
  `userID` int NOT NULL,
  `reviewID` int NOT NULL,
  `logID` int NOT NULL,
  `actionType` varchar(45) DEFAULT NULL,
  `actionComment` varchar(45) DEFAULT NULL,
  `timestamp` varchar(45) DEFAULT NULL,
  KEY `admin_action_log_ibfk_2_idx` (`reviewID`),
  KEY `admin_action_log_ibfk_1_idx` (`userID`),
  CONSTRAINT `admin_action_log_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `admin_action_log_ibfk_2` FOREIGN KEY (`reviewID`) REFERENCES `game_review` (`reviewID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_action_log`
--

LOCK TABLES `admin_action_log` WRITE;
/*!40000 ALTER TABLE `admin_action_log` DISABLE KEYS */;
INSERT INTO `admin_action_log` VALUES (3,6,1,'delete','Removed due to spam and trolling.','2025-07-07 18:22:33'),(7,3,2,'flag','Flagged for offensive language.','2025-07-07 18:22:33'),(1,10,3,'delete','Review lacked meaningful content.','2025-07-07 18:22:33'),(4,22,4,'flag','Marked as low effort for admin review.','2025-07-07 18:22:33'),(5,15,5,'flag','Contains potentially offensive language.','2025-07-07 18:22:33'),(3,5,6,'approve','No issues found — approved.','2025-07-07 18:22:33'),(9,18,7,'delete','Spammy and toxic language present.','2025-07-07 18:22:33'),(1,2,8,'approve','Review is fair and constructive.','2025-07-07 18:22:33'),(7,21,9,'flag','Marked for moderator second look.','2025-07-07 18:22:33'),(10,9,10,'approve','Genuine opinion, left as-is.','2025-07-07 18:22:33');
/*!40000 ALTER TABLE `admin_action_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game`
--

DROP TABLE IF EXISTS `game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game` (
  `gameID` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text,
  `releaseDate` date DEFAULT NULL,
  `ESRB_rating` varchar(30) DEFAULT NULL,
  `coverArt` varchar(255) DEFAULT NULL,
  `developer` varchar(100) DEFAULT NULL,
  `officialSiteURL` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`gameID`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game`
--

LOCK TABLES `game` WRITE;
/*!40000 ALTER TABLE `game` DISABLE KEYS */;
INSERT INTO `game` VALUES (1,'Grand Theft Auto V','Rockstar Games went bigger, since their previous installment of the series. You get the complicated and realistic world-building from Liberty City of GTA4 in the setting of lively and diverse Los Santos, from an old fan favorite GTA San Andreas. 561 different vehicles (including every transport you can operate) and the amount is rising with every update. \nSimultaneous storytelling from three unique perspectives: \nFollow Michael, ex-criminal living his life of leisure away from the past, Franklin, a kid that seeks the better future, and Trevor, the exact past Michael is trying to run away from. \nGTA Online will provide a lot of additional challenge even for the experienced players, coming fresh from the story mode. Now you will have other players around that can help you just as likely as ruin your mission. Every GTA mechanic up to date can be experienced by players through the unique customizable character, and community content paired with the leveling system tends to keep everyone busy and engaged.\n\nEspañol\nRockstar Games se hizo más grande desde su entrega anterior de la serie. Obtienes la construcción del mundo complicada y realista de Liberty City de GTA4 en el escenario de Los Santos, un viejo favorito de los fans, GTA San Andreas. 561 vehículos diferentes (incluidos todos los transportes que puede operar) y la cantidad aumenta con cada actualización.\nNarración simultánea desde tres perspectivas únicas:\nSigue a Michael, ex-criminal que vive su vida de ocio lejos del pasado, Franklin, un niño que busca un futuro mejor, y Trevor, el pasado exacto del que Michael está tratando de huir.\nGTA Online proporcionará muchos desafíos adicionales incluso para los jugadores experimentados, recién llegados del modo historia. Ahora tendrás otros jugadores cerca que pueden ayudarte con la misma probabilidad que arruinar tu misión. Los jugadores pueden experimentar todas las mecánicas de GTA actualizadas a través del personaje personalizable único, y el contenido de la comunidad combinado con el sistema de nivelación tiende a mantener a todos ocupados y comprometidos.','2013-09-17','Mature','https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg','Rockstar North','http://www.rockstargames.com/V/'),(2,'The Witcher 3: Wild Hunt','The third game in a series, it holds nothing back from the player. Open world adventures of the renowned monster slayer Geralt of Rivia are now even on a larger scale. Following the source material more accurately, this time Geralt is trying to find the child of the prophecy, Ciri while making a quick coin from various contracts on the side. Great attention to the world building above all creates an immersive story, where your decisions will shape the world around you.\n\nCD Project Red are infamous for the amount of work they put into their games, and it shows, because aside from classic third-person action RPG base game they provided 2 massive DLCs with unique questlines and 16 smaller DLCs, containing extra quests and items.\n\nPlayers praise the game for its atmosphere and a wide open world that finds the balance between fantasy elements and realistic and believable mechanics, and the game deserved numerous awards for every aspect of the game, from music to direction.','2015-05-18','Mature','https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg','CD PROJEKT RED','https://thewitcher.com/en/witcher3'),(3,'Portal 2','Portal 2 is a first-person puzzle game developed by Valve Corporation and released on April 19, 2011 on Steam, PS3 and Xbox 360. It was published by Valve Corporation in digital form and by Electronic Arts in physical form. \n\nIts plot directly follows the first game\'s, taking place in the Half-Life universe. You play as Chell, a test subject in a research facility formerly ran by the company Aperture Science, but taken over by an evil AI that turned upon its creators, GladOS. After defeating GladOS at the end of the first game but failing to escape the facility, Chell is woken up from a stasis chamber by an AI personality core, Wheatley, as the unkempt complex is falling apart. As the two attempt to navigate through the ruins and escape, they stumble upon GladOS, and accidentally re-activate her...\n\nPortal 2\'s core mechanics are very similar to the first game\'s ; the player must make their way through several test chambers which involve puzzles. For this purpose, they possess a Portal Gun, a weapon capable of creating teleportation portals on white surfaces. This seemingly simple mechanic and its subtleties coupled with the many different puzzle elements that can appear in puzzles allows the game to be easy to start playing, yet still feature profound gameplay. The sequel adds several new puzzle elements, such as gel that can render surfaces bouncy or allow you to accelerate when running on them.\n\nThe game is often praised for its gameplay, its memorable dialogue and writing and its aesthetic. Both games in the series are responsible for inspiring most puzzle games succeeding them, particularly first-person puzzle games. The series, its characters and even its items such as the portal gun and the companion cube have become a cultural icon within gaming communities.\n\nPortal 2 also features a co-op mode where two players take on the roles of robots being led through tests by GladOS, as well as an in-depth level editor.','2011-04-18','Everyone 10+','https://media.rawg.io/media/games/2ba/2bac0e87cf45e5b508f227d281c9252a.jpg','Valve Software','http://www.thinkwithportals.com/'),(4,'Counter-Strike: Global Offensive','Counter-Strike is a multiplayer phenomenon in its simplicity. No complicated narratives to explain the source of the conflict, no futuristic and alien threats, but counter-terrorists against terrorists. Arena shooter at its core, CS:GO provides you with various methods of disposing enemies and reliant on cooperation within the team. During the round of the classical clash mode, you will gradually receive currency to purchase different equipment. Each player can carry a primary weapon, secondary pistol, knife and a set of grenades, which all can change the battle if wielded by the skilled player. \r\nObjectives are clear and vary from map to map, from game mode to game mode. Stop the terrorists from planting explosives, stop the counter-terrorist from retrieving the hostages, kill everyone who isn’t you and just perform the best with.\r\nCS:GO is one of the major cybersport discipline, which makes playing it more exciting to some players. Aside from purchasing the game, CS:GO is infamous for its loot case system, that requires players to purchase keys, in order to open said cases. Customization items consist of weapon skins, weapon stickers, and sprays that do not affect gameplay and have purely visual value to the player.','2012-08-21','Mature','https://media.rawg.io/media/games/736/73619bd336c894d6941d926bfd563946.jpg','Valve Software','http://blog.counter-strike.net/'),(5,'Tomb Raider (2013)','A cinematic revival of the series in its action third person form, Tomb Rider follows Lara in her least experience period of life – her youth. Heavily influenced by Naughty Dog’s “Uncharted”, the game is a mix of everything, from stealth and survival to combat and QTE action scenes.\r\nYoung Lara Croft arrives on the Yamatai, lost island near Japan, as the leader of the expedition in search of the Yamatai Kingdom, with a diverse team of specialists. But shipwreck postponed the successful arrival and seemingly forgotten island is heavily populated with hostile inhabitants, cultists of Solarii Brotherhood.\r\nThe game will be graphic at times, especially after failed QTE’s during some of the survival scenes, but overall players will enjoy classic action adventure, reminiscent of the beginning of the series. This game is not a direct sequel or continuation of existing sub-series within the franchise, but a reboot, setting up Tomb Raider to represent modern gaming experience.\r\nThe game has RPG elements and has a world, which you can explore during the story campaign and after the completion. As well as multiplayer mode, where 2 teams (4 scavengers and 4 survivors) are clashing in 3 game modes while using weapons and environments from the single-player campaign.','2013-03-05','Mature','https://media.rawg.io/media/games/021/021c4e21a1824d2526f925eff6324653.jpg','Crystal Dynamics','http://www.tombraider.com'),(6,'Portal','Every single time you click your mouse while holding a gun, you expect bullets to fly and enemies to fall. But here you will try out the FPS game filled with environmental puzzles and engaging story. \r\nSilent template for your adventures, Chell, wakes up in a testing facility. She’s a subject of experiments on instant travel device, supervised by snarky and hostile GLaDOS.\r\nPlayers will have to complete the tests, room by room, expecting either reward, freedom or more tests. By using the gun, that shoots portals (Portal-Gun™), players will move blocks, travel great distance quickly and learn about your current situation, which is unraveled through environmental storytelling. What you will be told might be different from what you will see.\r\nWhite environments will guide the player’s portal placement, forcing them to pay attention to the surroundings.  Portal creates tension, allowing either solving puzzles at your own leisure or moving quickly, due to the time limit or threats.','2007-10-09','Teen','https://media.rawg.io/media/games/7fa/7fa0b586293c5861ee32490e953a4996.jpg','Valve Software','http://www.whatistheorangebox.com/'),(7,'Left 4 Dead 2','Cooperative survival continues with a different set of characters. New survivors are making their way through 5 campaigns with an added ability to play through the story of the first game as well, using not only expanded arsenal of 20 ranged and 10 melee weapons but improved AI Director. Your surroundings and weather will change; enemy and item placement will differ from map to map, from difficulty to difficulty. New unique special zombies, placed in the unlucky for the player spot, can end your run.\r\nHigh compatibility with community mods will allow you not only to add user-created maps but player models, enemy models, and even in-game music, which will help any player to create the unique experience on top of solid game mechanics.\r\nCompetitive multiplayer mods from arena survival to a head-on competition with another team of survivors are addictive and, in addition to the campaign, will provide you with hundreds of hours of game content.','2009-11-17','Mature','https://media.rawg.io/media/games/d58/d588947d4286e7b5e0e12e1bea7d9844.jpg','Valve Software','http://www.l4d.com'),(8,'The Elder Scrolls V: Skyrim','The fifth game in the series, Skyrim takes us on a journey through the coldest region of Cyrodiil. Once again player can traverse the open world RPG armed with various medieval weapons and magic, to become a hero of Nordic legends –Dovahkiin, the Dragonborn. After mandatory character creation players will have to escape not only imprisonment but a fire-breathing dragon. Something Skyrim hasn’t seen in centuries.','2011-11-11','Mature','https://media.rawg.io/media/games/7cf/7cfc9220b401b7a300e409e539c9afd5.jpg','Bethesda Game Studios','http://elderscrolls.com/'),(9,'Red Dead Redemption 2','America, 1899. The end of the wild west era has begun as lawmen hunt down the last remaining outlaw gangs. Those who will not surrender or succumb are killed. \r\n\r\nAfter a robbery goes badly wrong in the western town of Blackwater, Arthur Morgan and the Van der Linde gang are forced to flee. With federal agents and the best bounty hunters in the nation massing on their heels, the gang must rob, steal and fight their way across the rugged heartland of America in order to survive. As deepening internal divisions threaten to tear the gang apart, Arthur must make a choice between his own ideals and loyalty to the gang who raised him.\r\n\r\nFrom the creators of Grand Theft Auto V and Red Dead Redemption, Red Dead Redemption 2 is an epic tale of life in America at the dawn of the modern age.','2018-10-26','Mature','https://media.rawg.io/media/games/511/5118aff5091cb3efec399c808f8c598f.jpg','Rockstar Games','https://www.rockstargames.com/reddeadredemption2/'),(10,'BioShock Infinite','The third game in the series, Bioshock takes the story of the underwater confinement within the lost city of Rapture and takes it in the sky-city of Columbia. Players will follow Booker DeWitt, a private eye with a military past; as he will attempt to wipe his debts with the only skill he’s good at – finding people. Aside from obvious story and style differences, this time Bioshock protagonist has a personality, character, and voice, no longer the protagonist is a silent man, trying to survive.\r\nOpen and bright level design of Columbia shows industrial colonial America in a seemingly endless carnival. But Bioshock is not famous for its visuals, but for its story.  Mystery and creative vision of Irrational Games invite players to uncover the secrets of Columbia’s leader - Zachary Comstock and save Elizabeth, the girl, that’s been locked up in the flying city since her birth.\r\nUnique weapons and mechanics of Vigor will make encounters different, helping players to adjust to the new found mobility and hook shot, making fights fast-paced and imaginative.','2013-03-26','Mature','https://media.rawg.io/media/games/fc1/fc1307a2774506b5bd65d7e8424664a7.jpg','Aspyr Media','https://2k.com/en-US/game/bioshock-infinite'),(11,'Half-Life 2','Gordon Freeman became the most popular nameless and voiceless protagonist in gaming history. He is painted as the most famous scientist and a hero within the world of Half-Life, and for a good reason. In the first game he saved the planet from alien invasion, this time, when the invasion is already begun, the world needs his help one more time. And you, as a player, will help this world to survive. This time Gordon arrives in City 17, ravaged and occupied by Combines, where he meets his old Black Mesa friends. \r\nWhat is different, aside from the overall design quality, is the use of Valve’s Source engine that not only expands on the fluidity of character model animations and movement but allows players to interact with a myriad of objects with the advanced and realistic (to an extent) physics. Classic Headcrab Zombies are revamped and have new variants that provide players with different threats. For a story-driven FPS, Half-Life 2 is unique in its plot delivery, and making in-game mechanics feel natural, be it platforming or driving.','2004-11-16','Mature','https://media.rawg.io/media/games/b8c/b8c243eaa0fbac8115e0cdccac3f91dc.jpg','Valve Software','http://www.half-life2.com'),(12,'Borderlands 2','Sequel to the 4-player cooperative FPS RPG Borderlands, where the new team of Vault Hunters arrives on the infamous planet Pandora in order to get the riches, hidden inside the Vault, and help to free the planet from the Handsome Jack, President of Hyperion. Clear out the endless waves and groups and marauders with various weapon types and character abilities.\r\nUnlike the first game, Borderlands 2 provided DLC not only expanding the world of Pandora with stand-alone story campaigns but adding 2 more characters. Now the main cast consists of Gunzerker Salvador(dual-wields guns at command), Siren Maya (holds and paralyzes the enemy), Commando Axton (summons turrets) and Zer0 the Assasin (invisible sniper ninja). But with the DLC players can try out summoning giant flying robots with Gaige the Mechromancer and Krieg the Psycho. \r\nMost of the game charm and popularity of Borderlands 2 comes from the supporting cast and the personalities of the NPC, making this fast-paced shooter with optional cover stand out.','2012-09-18','Mature','https://media.rawg.io/media/games/49c/49c3dfa4ce2f6f140cc4825868e858cb.jpg','Aspyr Media','http://www.borderlands2.com/'),(13,'Life is Strange','Interactive storytelling and plot-heavy games gained popularity, and “Life is Strange” arrived as teen mystery adventure. The plot will go through the life of Maxine, a teenager in possession of curious power, allowing her to stop and rewind time, in order to manipulate her surroundings. Max, after the reunion with her friend Chloe, is on the path to uncovering the secrets of Arcadia Bay. Players will have to deal with puzzle solving through the fetch quests, in order to change the world around them. \nThe game puts players in situations, where they’re forced to make a moral choice, going through the decision which may have short-term or long-term consequences. Every choice made by the player will trigger the butterfly effect, surrounding the first playthrough of the game with a lot of emotional struggle, thoughtfully crafted by the developers at Dontnod Entertainment. Life is Strange is third person adventure game, where players might seem just as an observer of the stories, unfolding in front of them.','2015-01-29','Mature','https://media.rawg.io/media/games/562/562553814dd54e001a541e4ee83a591c.jpg','DONTNOD Entertainment','https://www.lifeisstrange.com/en-us/games/life-is-strange'),(14,'BioShock','FPS with RPG elements, Bioshock invites players to experience horrors of underwater isolation in the city of Rapture, the failed project of the better future. After surviving the plane crash, the protagonist has only one way to go – to the giant lighthouse that opens a way to the underwater utopia. Players will have to unravel the complicated history of Rapture, relying only on themselves, their guns and Plasmids, a mystical substance, that allows it’s user to obtain near magical abilities.\r\nThe atmosphere of isolation and threat is conveyed through the environmental sounds, subtle electrical buzzing and audio logs, telling the story of societal decay and despair. Players will shape the story, making moral choices along their way, saving Little Sisters or extracting ADAM, the mystical fuel for your abilities. While exploring the underwater city, players will complete missions for the last sane inhabitants of Rapture, while fending off the less fortunate ones.','2007-08-21','Mature','https://media.rawg.io/media/games/bc0/bc06a29ceac58652b684deefe7d56099.jpg','Digital Extremes','https://2k.com/en-US/game/bioshock/'),(15,'Destiny 2','Destiny 2 is an online multiplayer first-person shooter. You take on the role of a Guardian that needs to protect the last city on Earth from alien invaders. The game follows its predecessor, Destiny. The goal of the game is to return the Light that was stolen from the Guardians by the aliens.\nDestiny 2 features two main activity types: player versus environment and player versus player. PvE is focused on exploration, story missions interaction with NPCs and side quests. PvP features 4v4 team matches in different modes. The game also allows taking part in group missions, such as three-player strikes and six-player raids.\nDestiny 2 has a strong RPG aspect that includes character customization and development. There are three classes in the game - Warlock, Hunter, and Titan; they provide different playstyles depending on their specialization and unique abilities. To develop the character you can gain experience points completing the story and side missions.','2017-09-06','Teen','https://media.rawg.io/media/games/34b/34b1f1850a1c06fd971bc6ab3ac0ce0e.jpg','Bungie','https://www.bungie.net/7/en/Destiny/NewLight'),(16,'God of War (2018)','Unleash the power of the Gods and embark on a merciless quest as Kratos, an ex-Spartan warrior driven to destroy Ares, the God of War. Armed with lethal double chainblades, Kratos must carve through mythology\'s darkest creatures including Medusa, Cyclops, the Hydra and more, while solving intricate puzzles in breathtaking environments. Driven by pure revenge, nothing can stop Kratos from achieving absolution.','2018-04-20','Mature','https://media.rawg.io/media/games/4be/4be6a6ad0364751a96229c56bf69be59.jpg','SCE Santa Monica Studio','https://www.playstation.com/en-us/games/god-of-war/'),(17,'Fallout 4','The fourth game in the post-apocalyptic action RPG series from Bethesda studious brings players back to the retro-future. After customizing the facial features of the character, players will be admitted to the Vault 111 with their family, and tricked into entering the cryogenic capsule. After the rude awakening after the unknown amount of time has passed, the child is separated from the parents and the loving partner is killed in front of them – the main quest is settled. Now there’s only the giant open world to explore. Fallout 4 introduces the mechanics of settlement building, where players can build their own little town. Gathering material for crafting and building brings more “survival” elements into the old formula. Within their own settlements, players will be able to build all needed utilities, from storage spaces to power armor stations. Visual upgrade from the previous game brings life to what used to be brown wastelands, now filled with details and color.','2015-11-09','Mature','https://media.rawg.io/media/games/d82/d82990b9c67ba0d2d09d4e6fa88885a7.jpg','Bethesda Game Studios','http://www.fallout4.com'),(18,'PAYDAY 2','The gang is back, and they have bigger and better plans. Objective based cooperative FPS became more complicated. The classic group of Hoxton, Dallas, Chains and Wolf got reinforcement, and now Payday Gang consists of 21 heisters, some of which are based on movie characters or even Youtubers. Players will be able to customize their own private arsenal, their masks, and skills, to complete the missions in their own way, be it stealthy sneak-in or full frontal assault. After completing missions, players will receive EXP points, money and a chance to get a special item that can be a gun modification, mask or a safe containing weapon skins.\r\nPayday 2 is a multiplayer game, meaning, that even during offline missions players will be followed by AI characters, whose loadouts, masks and perks can be customized as well. This game has been supported by the developers for many years, and amount of DLC speaks plenty of their dedication to the player base.','2013-08-13','Adults Only','https://media.rawg.io/media/games/73e/73eecb8909e0c39fb246f457b5d6cbbe.jpg','505 Games','http://www.crimenet.info'),(19,'Limbo','This popular 2D puzzle-platformer creates the atmosphere of isolation, where the player alone can guide the nameless protagonist to his destination. Hostile environments and one-hit deaths may seem difficult, but the game implements a fair amount of checkpoints. The monochrome color palette showcases cartoony proportions of every living thing while making lack of details threatening. Limbo shows you exactly what you encounter, but never how it looks.\n\nLimbo uses the atmosphere and sound design of the horror genre while avoiding tropes of the modern horror games. The overarching theme and unique style compensated for the rather short game with an abrupt ending, making Limbo one of the most impactful games for the genre.\n\nThe simple controls and easy-to-pick-up mechanics help to make a clear distinction, which part of the stage players can interact with, and which part can lead to the quick death. Even though the game is in black and white, this separation is intuitive and natural, so the player would know exactly where to go or what to do.','2010-07-21','Teen','https://media.rawg.io/media/games/942/9424d6bb763dc38d9378b488603c87fa.jpg','Double Eleven','http://playdead.com/limbo'),(20,'Team Fortress 2','TF2 is an objective based arena shooter with unique characters, representing different classes, acting as a staple of casual and competitive gaming for Steam. Dozens of different maps and game modes are trying to keep this game alive, after all the years it was available. Each character has a vast arsenal that can be accessed through completing in-game achievements, randomly receiving them from loot-boxes within the game, crafting them or just buying and trading items on the Steam Market. \r\nFor players, that\'s not into the direct clash with players from the enemy team, Team Fortress 2 introduced a PvE mode, which is wave defense from the mirrored robotic opponents that have qualities of some of the playable classes. \r\nEvery update and introduction, made over years, provided a lot of entertainment In the form of comic books an short animated videos, creating and explaining a story behind endless clashes for resources, briefcases or pure domination.','2007-10-10','Mature','https://media.rawg.io/media/games/46d/46d98e6910fbc0706e2948a7cc9b10c5.jpg','Valve Software','http://www.teamfortress.com/'),(21,'DOOM (2016)','Return of the classic FPS, Doom (2016) acts as a reboot of the series and brings back the Doomslayer, protagonist of the original Doom games. In order to solve the energy crisis, humanity learned to harvest the energy from Hell, and when something went wrong and a demon invasion has started, it’s up to the player to control the Doomslayer and destroy the evil.\n\nDoom is a fast-paced game that restores the concept of instant health packs and leaves the player against armies of Hell with no cover, no health regeneration, or help from anyone. After damaging monsters enough, they will start glowing, which will allow players to perform glory kills to restore some health. While exploring the levels, players will come across secrets, collectible items, or upgrade points for the weapons and armor. The single-player campaign silent protagonist has a noticeable personality. He gets visibly annoyed and angry in his actions during expository cutscenes and forces his way through the game. Multiplayer maps gather players in Deathmatch/”king-of-the-hill” type game modes, with all the weapons from the single-player campaign.','2016-05-12','Mature','https://media.rawg.io/media/games/587/587588c64afbff80e6f444eb2e46f9da.jpg','Bethesda Softworks','https://bethesda.net/game/doom'),(22,'Cyberpunk 2077','Cyberpunk 2077 is a science fiction game loosely based on the role-playing game Cyberpunk 2020.\r\n\r\n###Setting\r\nThe game is set in the year 2077 in a fictional futuristic metropolis Night City in California. In the world of the game, there are developed cybernetic augmentations that enhance people\'s strength, agility, and memory. The city is governed by corporations. Many jobs are taken over by the robots, leaving a lot of people poor and homeless. Night City has a roaring underworld, with black markets, underground surgeons, drug dealers, and street gangs abound.\r\n\r\n###Characters\r\nThe main protagonist is fully customizable, including his or her sex and appearance, and goes by the nickname V. He or she is an underground mercenary who does “dirty business” for the various contractors. An NPC companion named Jackie joins the protagonist early at the game, and various other companions may join the player on certain missions as the plot demands. However, the game has no parties and no companion system.\r\n\r\n###Gameplay\r\nThe player controls V from the first person view, with the third-person view used for cutscenes only. The protagonist can travel across the city on feet or using various vehicles, in a manner some observers compared to GTA series. There are many options for the character customization, including three character classes, and a variety of augmentations V can install to enhance his or her abilities.','2020-12-10','Mature','https://media.rawg.io/media/games/26d/26d4437715bee60138dab4a7c8c59c92.jpg','CD PROJEKT RED','https://www.cyberpunk.net/'),(23,'Terraria','Terraria is a 2D action adventure sandbox game, where players create a character and gather resources in order to gradually craft stronger weapons and armor. Players create randomly generated maps that contain different locations within it, and by gathering specific resources and triggering special events, players will fight one of the many in-game bosses. Created characters can be played on different maps.\r\nThe game introduces hundreds of unique items that can be found across the entirety of the map, some of which may not even be encountered. \r\nTerraria have many different Biomes and areas with distinct visuals, containing resources and enemies unique to this biome. After gathering materials, players can craft furniture, and build settlements and houses, since after completing events or finding specific items NPCs will start to arrive, and will require player’s protection. Terraria can be played on three difficulties and has a large modding community.','2011-05-16','Teen','https://media.rawg.io/media/games/f46/f466571d536f2e3ea9e815ad17177501.jpg','Engine Software','http://www.terraria.org/'),(24,'Dota 2','What used to be an unofficial modded map for the Warcraft 3, ended up being the most budgeted cybersport discipline, gathering millions of people to watch annual international championships.\nMOBA genre started with the DOTA, Defense of the Ancients, which can be efficiently described as 5 vs 5 top-down action strategy game, during which players are tasked to destroy the enemy core while protecting their own.\nPlayers can pick out of the roster of 112 heroes and battle on the single map while taking advantage of field vision, resources and item build that can either make heroes stronger or disable the enemy. DOTA 2 is still active, and receives updates weekly, reshaping metas and refreshing game balance, if by any chance some heroes became unreasonably strong. Each hero has not only a unique set of abilities but is fully customizable, through getting items for heroes after matches of through the trade. Not only heroes but terrain, couriers, that deliver items for you and even match announcers, that can be voiced by heroes, professional casters of just memorable characters from other forms of media.','2013-07-09',NULL,'https://media.rawg.io/media/games/6fc/6fcf4cd3b17c288821388e6085bb0fc9.jpg','Valve Software','http://www.dota2.com/'),(25,'Warframe','Warframe is an online free-to-play cooperative third-person looter shooter. In the far future the Orokin had absolute control over the solar system but have since disappeared, now the militaristic Grineer, the money-worshipping Corpus, and the Infested fight for what they left behind. You are a Tenno - a master of gun and blade and user of the Warframes, it is up to you to bring back balance to the system from within, while also fighting a new threat from without: the Sentients.\r\nOver 40 unique Warframes to build, hundreds of guns and melee weapons to utilize, and various pet companions to help you along the way - all of which can be crafted for free and enhanced by an in-depth modding system.\r\nWith constant updates by Digital Extremes, the game now has over six years of updates including new open-world landscapes (Plains of Eidolon-2017, Orb Vallis-2018) and cinematic story expansions (The Second Dream-2015, The War Within-2016, The The Sacrifice-2018) with more content being added every year.','2013-03-25',NULL,'https://media.rawg.io/media/games/f87/f87457e8347484033cb34cde6101d08d.jpg','Digital Extremes','http://www.warframe.com'),(26,'Grand Theft Auto IV','Every crime story is a story of a search for success. The player will become Niko Bellic, immigrant arriving at the Liberty City to reunite with his cousin Roman and find the man that betrayed him and his army unit fifteen years prior to the events of the game. While protecting his cousin, Niko has to deal with loan sharks, Russian mobsters, and other gangs. After the third game, GTA brought more realism to the player, in order to make the city and its people look more believable. Street vendors on every corner will sell food that replenishes health, bars with playable dart boards, bowling alleys and even comedy clubs and movie theatres. Open world will allow players not only hang out with important NPC in order to receive bonuses and unlocks but taking girls on the dates as well, to help Niko settle. Multiplayer mode allows up to 32 players to explore the copy of the single-player city and initiate multiplayer activities, like races or Deathmatches.','2008-04-29','Mature','https://media.rawg.io/media/games/4a0/4a0a1316102366260e6f38fd2a9cfdce.jpg','Rockstar North','http://www.rockstargames.com/iv'),(27,'Rocket League','Highly competitive soccer game with rocket-cars is the most comprehensive way to describe this game. Technically a sequel to Psyonix’ previous game - Supersonic Acrobatic Rocket-Powered Battle-Cars; Rocket League successfully became a standalone sensation, that can be enjoyed by anyone. Easy to learn, hard to master game mechanics are perfect for the tight controls. Players are invited to maneuver the different fields within several game modes, from arcade to ranked game either 1v1, or in 2v2 and 3v3 teams. Using boosters will not only speed up the car but will allow the car to propel itself into the air.\r\nRocket League provides several levels of customization, where not only the color of your car can be adjusted, but the colors and form of the booster flame, different hats, and little flags. Or players can pick a completely different car. Collaboration with different franchises brought not only original transport but some famous cars, including Batmobile or Delorian from Back to the Future.','2015-07-07','Everyone','https://media.rawg.io/media/games/8cc/8cce7c0e99dcc43d66c8efd42f9d03e3.jpg','Psyonix','http://www.rocketleaguegame.com'),(28,'Horizon Zero Dawn','Horizon Zero Dawn is an experiment. A very impressive experiment that actually succeeded. \r\nHaving a very curious mix of cyberpunk and prehistorical styles and esthetic, the game provides us with quite a unique experience. We need to arm ourselves with arrows and a bow, with a spear or any other prehistorical-ish weapon in order to defeat out enemies - dinosaur-mechanisms that are spread around the world. If that wasn\'t enough, Aloy our main protagonist can control an AI named GAIA. What we\'re having here is an exciting connection with \"very old times\" and \"near future\", even though the game is set up in the 31st century. \r\nBeing an outcast with her father Rost, Aloy must restore her position in the tribe and save the world by stopping the Eclipse, a cult that wants to rule the world. Join her on that journey, exploring the world and people that live in such hard surroundings.','2017-02-28','Teen','https://media.rawg.io/media/games/b7d/b7d3f1715fa8381a4e780173a197a615.jpg','Guerrilla Games','https://www.guerrilla-games.com/play/horizon'),(29,'Metro 2033','Not all post-apocalyptic stories begin in the burned wastelands, this time nuclear and chemical locked up survivors in the Moscow Subway, and player will take the place of Artyom, one of the survivors from the VDNKh, adoptive son of the station commander, and taking upon himself the task to deliver information about the Dark Ones to the Polis, the capital of subway, after the special operative from Spartans named Hunter went missing, after he ventured to gather information on the Hive – living space of the Dark Ones.\r\nDark tunnels of broken subway create a claustrophobic atmosphere, where good and bad people alike are forced to bond. Closely following original book, Metro 2033 introducing bullets as currency. Players can exchange one type of bullets for another one, but it’s still ammo and will be wasted with inaccurate aim. It’s a first person shooter that will allow players not only see how broken apart can society become but to explore such society and ruins of the city above the underground settlement. Various monsters and mutants are not the only threat to the players, but humans as well. FPS with some stealth sections, Metro 2033 will show you every historical enemy type: bandits, Communists, and Nazis.','2010-03-16','Mature','https://media.rawg.io/media/games/120/1201a40e4364557b124392ee50317b99.jpg','4A Games','http://metro2033game.com'),(30,'Rise of the Tomb Raider','Rise of the Tomb Raider is the eleventh entry in the franchise, being a sequel to its predecessor, Tomb Raider, a reboot of the franchise. This story follows Lara Croft, one year after battling her supernatural experiences in Yamatai. This time she is trying to find the legendary city of Kitezh in Siberia, Russia. The legend behind the city begins in the 12th century and still comes nowadays, that this ancient city grants with a promise of immortality. While Lara tries to solve the mystery of Siberia, she encounters an organisation called Trinity. They want to retrieve this gift to themselves. Following the notes of her father, Lara tries to discover the secrets of the ancient city and stop Trinity in doing so.\r\n\r\nExploring the Soviet motive, even more, the game has the DLC\'s - Baba Yaga, the Temple of the Witch, which follows Lara in the Soviet mine and confronting the legendary witch of Russian folk-tales, Cold Darkness Awakened, the story about a secret biological weapon and Blood Ties and Lara\'s Nightmare - a fight for ownership of the Croft estate. \r\n\r\nBesides craftmanship and exploring, the game focuses on a very progressive combat system giving a player a wide variety of strategic options. There is a way to evade your opponents in the bushes; stealth kills with bow and arrows or open combat with firearms like shotguns, pistols and other guns. WIth earning experience, you can give Lara new ways of encountering her enemies by three different specialisations - Hunter, Survivor or Brawler. Each skill tree offers various options of combat, for example using Lara\'s surroundings and fauna, traps or better aim. With these options, you can choose how to guide Lara Croft in her adventures.','2015-11-10',NULL,'https://media.rawg.io/media/games/b45/b45575f34285f2c4479c9a5f719d972e.jpg','Feral Interactive','http://www.tombraider.com/us/'),(31,'Batman: Arkham Knight','Batman: Arkham Knight is the final instalment for the Arkham series by now. Joining forces with Bruce Wayne for the last time, we have to oppose Scarecrow and other iconic villains such as The Riddler, Harleen Quinzel a.k.a. Harley Quinn, Penguin and others.\n\nThe story continued after events in Arkham City when Joker died due to infection in his blood. Now, Scarecrow tries to release a new fear toxin, meanwhile new mysterious Arkham Knight plots against Batman as well. Still having consequences after being poisoned by the Joker and seeing visions with him, Bruce has to prevail the death of Gotham City.\n\nThe gameplay mechanics stays the same to the Arkham series. Melee combat system, use of the detective skills to find clues and gadgets still play a major role in Batman\'s fight against evil. Although now you can travel around not only by your grappling hook but a legendary Batmobile as well. Iconic voices of the characters, Kevin Conroy and Mark Hammil once again return to give their voices for the last game in Arkham series.','2015-06-23','Mature','https://media.rawg.io/media/games/310/3106b0e012271c5ffb16497b070be739.jpg','Rocksteady Studios','https://www.batmanarkhamknight.com/'),(32,'Metal Gear Solid V: The Phantom Pain','Metal Gear Solid 5 continues the story of MGS: Peace Walker and MGS V: Ground Zeroes. Snake seeks revenge for the attack on the MSF group 9 years ago, that placed Big Boss into a coma. After the failed assassination attempt, Big Boss takes the code name Venom Snake, delving back into the world of superhumans and espionage.\r\nA large-scale story that includes 5 hours of cinematic cutscenes compliments open world exploration with hundreds of audio logs and side missions, forming the atmosphere of military drama with sci-fi elements. MGS5: Phantom Pain has an advanced AI system that will allow enemy soldiers constantly call for reinforcements if they see that something is wrong, forcing players to take down communications and fight or retreat and try again. \r\nPlayers will manage the base by gathering and managing staff, weaponry, and resources, in order to upgrade their personal arsenal and companions.','2015-09-01','Mature','https://media.rawg.io/media/games/490/49016e06ae2103881ff6373248843069.jpg','Kojima Productions','http://www.metalgearsolid.com'),(33,'Apex Legends','Conquer with character in Apex Legends, a free-to-play* Battle Royale shooter where legendary characters with powerful abilities team up to battle for fame and fortune on the fringes of the Frontier. Master an ever-growing roster of diverse legends, deep tactical squad play, and bold new innovations that level-up the Battle Royale experience—all within a rugged world where anything goes. Welcome to the next evolution of Battle Royale.\n\nCharacters you can play as: Caustic, Bangalore, Bloodhound, Crypto, Gibraltar, Lifeline, Loba, Mirage, Octane, Pathfinder, Rampart, Revenant.','2019-02-04','Teen','https://media.rawg.io/media/games/737/737ea5662211d2e0bbd6f5989189e4f1.jpg','Respawn Entertainment','https://www.ea.com/games/apex-legends'),(34,'The Witcher 2: Assassins of Kings Enhanced Edition','The player is Geralt of Rivia, infamous monster slayer. In the second game of the series, titular witcher is involved in the inner conflicts of Temeria, where he stopped the rebellion and was hired as a bodyguard of Temerian King Foltest. Eventually, Foltest was assassinated by a witcher-like assassin, and the only person fitting the description was Geralt. \r\nThe game combat system was reworked, in order to add traps and ranged throwing weapon, giving players more control over the course of the battle. It’s still a third person action RPG, and the player can upgrade and improve general abilities, swordsmanship, alchemy, and magic. \r\nThe enhanced edition includes additional hours of content, new cinematics, the original soundtrack, game manual and quest handbook, among other things. The new tutorial allows players to spend more time to master new game mechanics and see for themselves visual improvements to the core game.','2012-04-16','Mature','https://media.rawg.io/media/games/6cd/6cd653e0aaef5ff8bbd295bf4bcb12eb.jpg','CD PROJEKT RED','http://www.thewitcher.com'),(35,'The Witcher: Enhanced Edition Director\'s Cut','The Witcher is the very first instalment of the series that follows the story of Geralt from Rivia. Being found unconscious on the battlefield he must retrieve his memory and help the emperor\'s daughter, Adda to stop her from turning in to a feral monster. Facing the biggest enemy, Salamander, Geralt must also help all the fractions around the world to find peace between each other.\n\nThe fighting system is very flexible. Choosing from three different styles, you can adapt Geralt for any kind of a combat situation. Fast style of fighting gives you an opportunity to strike your opponents with your speed. The strong style focuses itself on destroying your enemies with powerful attacks, while sweeping style is very good when facing a number of foes. You can also craft some potions to gain important benefits such as seeing in the dark or having a larger amount HP. Plot style is unique as well. The game never gives a precise definition of evil, which leads the player to convenient situations where the choice is quite bad anyway. Enhanced edition improves every aspect of the game as graphics and the productivity of it, while Director\'s Cut does the same without censorship for North America\'s version.','2008-09-16','Mature','https://media.rawg.io/media/games/ee3/ee3e10193aafc3230ba1cae426967d10.jpg','CD PROJEKT RED','http://www.thewitcher.com'),(36,'Grand Theft Auto: San Andreas','Grand Theft Auto - San Andreas is the seventh entry in the series in the GTA franchise, but only second big title after GTA - Vice City. Setting up in fictional state San Andreas, you follow the story of CJ, a member of one of the multiple gangs in the city. CJ\'s family is being attacked in drive shooting which resulted in the death of CJ\'s mother, so he returns to home from Liberty City. Meeting the rest of the family at his mom\'s funeral, he decides to rebuild the gang and gain control of the state.\r\n\r\nThe game makes a brilliant connection with missions and open world actions that you are able to do around the cities. You can steal cars, buy guns, hunt for collectables and do some side quests, while different characters give you specific missions in order to push the plot forward. Streets are filled with people as well as plenty of vehicles to steal. Fictional brands of cars, tanks, bikes are available to be stolen from any place around the city. Armoury contains pistols, rifles, hand-machine guns or a rocket launcher as well as melee weapons giving player freedom in anything he\'s doing in GTA.','2004-10-26','Mature','https://media.rawg.io/media/games/960/960b601d9541cec776c5fa42a00bf6c4.jpg','Rockstar North','http://www.rockstargames.com/sanandreas/pc'),(37,'Half-Life 2: Lost Coast','Essentially a tech demo, “Half-Life 2: Lost Coast” sole purpose was to show off the new high-dynamic-range-rendering of the Source engine, it was a welcome addition to the franchise. It’s a free addition to the game that can be downloaded through Steam by the owners of Half-Life 2. Gordon Freeman founds himself near a group of decaying piers, fully armed and ready to explore the monastery above him, fighting through the Combine forces.\nHigh-dynamic-range-rendering introduced realistic lighting effects to the game, emulating even camera’s overexposure to the bright light, which was eventually moved to the main game. Lost Coast story is conveyed without cutscenes, every part of the level is tailored specifically to demonstrate the changes, made by developers. Even though it was originally created for the Half-Life 2, it was removed from the main game, alongside some minor story details. It’s not a full standalone game and wasn’t intended as one.','2005-10-27','Mature','https://media.rawg.io/media/games/b7b/b7b8381707152afc7d91f5d95de70e39.jpg','Valve Software','http://www.half-life2.com'),(38,'Middle-earth: Shadow of Mordor','Lord of the rings franchise brought a new title to the collection, an open world action-adventure game, that follows Talion, Gondor captain, that survived the sacrifice that was meant to bring the Elf Lord Celebrimbor as a wraith. Losing his wife and his son, Talion is merged with Celebrimor, escaping death.  Players will have to gain EXP in order to upgrade abilities through completing various missions and defeating Uruk warlords. Some missions might require special conditions for the greater reward.\r\nShadow of Mordor implemented the Nemesis System. It tracks the progress of every special Uruk warrior. Each special Uruk has a set of strengths and weaknesses, and players can assassinate higher ranked officers in order to promote easy to defeat Uruk to defeat them at a higher rank, weakening the Sauron’s army. This planning allows players to adapt, and use mechanics of stealth kills, ranged combat, wraith skills and head-on melee more effective.','2014-09-30','Mature','https://media.rawg.io/media/games/d1a/d1a2e99ade53494c6330a0ed945fe823.jpg','Feral Interactive','http://www.shadowofmordor.com'),(39,'The Walking Dead: Season 1','The Walking Dead is a five-part game series set in the same universe as Robert Kirkman’s award-winning comic book series. Play as Lee Everett, a convicted criminal, who has been given a second chance at life in a world devastated by the undead. With corpses returning to life and survivors stopping at nothing to maintain their own safety, protecting an orphaned girl named Clementine may offer him redemption in a world gone to hell.\r\nA continuing story of adventure horror spanning across 5 episodes:\r\n\r\nEpisode 1 – A New Day (Available Now)\r\nEpisode 2 – Starved for Help (Available Now)\r\n\r\nEpisode 3 – Long Road Ahead (Available Now)\r\nEpisode 4 – Around Every Corner (Available Now)\r\nEpisode 5 – No Time Left (Available Now)\r\nAll five episodes are now available immediately upon purchasing Season 1. Based on Robert Kirkman’s Eisner-Award winning comic book series, The Walking Dead allows gamers to experience the true horror of the zombie apocalypse\r\nA tailored game experience – Live with the profound and lasting consequences of the decisions that you make in each episode. Your actions and choices will affect how your story plays out across the entire series.\r\nExperience events, meet people and visit locations that foreshadow the story of Deputy Sheriff Rick Grimes\r\nMeet Glenn before he heads to Atlanta, explore Hershel’s farm before Rick and his group of survivors arrive and before the barn becomes a notorious location in Walking Dead lore\r\nYou’ll be forced to make decisions that are not only difficult, but that will require you to make an almost immediate choice. There’s no time to ponder when the undead are pounding the door down!\r\nFeatures meaningful decision-making, exploration, problem solving and a constant fight for survival in a world overrun by the undead\r\nArtwork inspired by the original comic books','2012-04-23','Mature','https://media.rawg.io/media/games/8d6/8d69eb6c32ed6acfd75f82d532144993.jpg','Telltale Games','https://www.playstation.com/en-us/games/the-walking-dead-season-1/'),(40,'Hollow Knight','Hollow Knight is a Metroidvania-type game developed by an indie studio named Team Cherry.\r\n\r\nMost of the game\'s story is told through the in-world items, tablets, and thoughts of other characters. Many plot aspects are told to the player indirectly or through the secret areas that provide a bit of lore in addition to an upgrade. At the beginning of the game, the player visits a town of Dirtmouth. A town built above the ruins of Hallownest. The players descend down into the ruins to find some answers to his questions.\r\n\r\nThe game revolves mainly around the exploration of the in-game world, which requires the players to have some platforming skills. The players have to find secrets that are scattered around the level and battle their enemies. There is a certain degree of backtracking in the game as some areas are locked until the player defeats a certain boss or picks up a specific item. Each area changes as the plot advances so it may be surprising to come back in a certain area. \r\n\r\nThe Protagonist uses a nail which serves as a replacement for a sword. Players can attack in four directions. The nail is upgradable.','2017-02-23','Everyone 10+','https://media.rawg.io/media/games/4cf/4cfc6b7f1850590a4634b08bfab308ab.jpg','Team Cherry','http://hollowknight.com');
/*!40000 ALTER TABLE `game` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_genre`
--

DROP TABLE IF EXISTS `game_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_genre` (
  `genreID` int NOT NULL AUTO_INCREMENT,
  `genreName` varchar(50) NOT NULL,
  PRIMARY KEY (`genreID`),
  UNIQUE KEY `genreName` (`genreName`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_genre`
--

LOCK TABLES `game_genre` WRITE;
/*!40000 ALTER TABLE `game_genre` DISABLE KEYS */;
INSERT INTO `game_genre` VALUES (1,'Action'),(5,'Adventure'),(6,'Indie'),(8,'Massively Multiplayer'),(7,'Platformer'),(4,'Puzzle'),(10,'Racing'),(2,'RPG'),(3,'Shooter'),(9,'Sports');
/*!40000 ALTER TABLE `game_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_platform`
--

DROP TABLE IF EXISTS `game_platform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_platform` (
  `platformID` int NOT NULL AUTO_INCREMENT,
  `platformName` varchar(50) NOT NULL,
  PRIMARY KEY (`platformID`),
  UNIQUE KEY `platformName` (`platformName`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_platform`
--

LOCK TABLES `game_platform` WRITE;
/*!40000 ALTER TABLE `game_platform` DISABLE KEYS */;
INSERT INTO `game_platform` VALUES (11,'Android'),(14,'iOS'),(10,'Linux'),(8,'macOS'),(17,'Nintendo 3DS'),(9,'Nintendo Switch'),(1,'PC'),(18,'PlayStation 2'),(5,'PlayStation 3'),(4,'PlayStation 4'),(2,'PlayStation 5'),(13,'PS Vita'),(15,'Web'),(16,'Wii U'),(12,'Xbox'),(6,'Xbox 360'),(7,'Xbox One'),(3,'Xbox Series S/X');
/*!40000 ALTER TABLE `game_platform` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_review`
--

DROP TABLE IF EXISTS `game_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_review` (
  `reviewID` int NOT NULL,
  `starRating` int DEFAULT NULL,
  `textReview` text,
  `isHelpful` tinyint(1) DEFAULT NULL,
  `postedDate` datetime DEFAULT NULL,
  `isFlagged` tinyint(1) DEFAULT '0',
  `flagReason` varchar(100) DEFAULT NULL,
  `flagComment` text,
  PRIMARY KEY (`reviewID`),
  CONSTRAINT `game_review_chk_1` CHECK ((`starRating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_review`
--

LOCK TABLES `game_review` WRITE;
/*!40000 ALTER TABLE `game_review` DISABLE KEYS */;
INSERT INTO `game_review` VALUES (1,5,'An absolute masterpiece — storytelling and design are top-notch.',1,'2025-07-01 00:00:00',0,NULL,NULL),(2,4,'Great atmosphere and puzzles, though some bugs were annoying.',1,'2025-07-02 00:00:00',0,NULL,NULL),(3,2,'Didn’t really click with me. Found the pacing slow.',0,'2025-07-02 00:00:00',1,'Offensive language','Some inappropriate phrases.'),(4,5,'Incredible worldbuilding and gameplay loop.',1,'2025-07-03 00:00:00',0,NULL,NULL),(5,3,'Not bad, but controls felt outdated.',0,'2025-07-04 00:00:00',0,NULL,NULL),(6,1,'Worst experience. Glitchy and shallow.',0,'2025-07-05 00:00:00',1,'Spam/Trolling','Feels like bait.'),(7,4,'Surprisingly fun with friends. Online mode is a blast.',1,'2025-07-06 00:00:00',0,NULL,NULL),(8,5,'Perfectly paced. I played it three times in a row.',1,'2025-07-06 00:00:00',0,NULL,NULL),(9,4,'Art style is amazing, and the gameplay is smooth.',0,'2025-07-06 00:00:00',0,NULL,NULL),(10,2,'Started strong, but ended up pretty repetitive.',0,'2025-07-06 00:00:00',1,'Low effort','Barely provides actual critique.'),(11,5,'Still my favorite game years later.',1,'2025-07-07 00:00:00',0,NULL,NULL),(12,4,'Great storytelling but could use better combat.',1,'2025-07-07 00:00:00',0,NULL,NULL),(13,5,'An absolute masterpiece — storytelling and design are top-notch.',1,'2025-07-01 00:00:00',0,NULL,NULL),(14,4,'Great atmosphere and puzzles, though some bugs were annoying.',1,'2025-07-02 00:00:00',0,NULL,NULL),(15,2,'Didn’t really click with me. Found the pacing slow.',0,'2025-07-02 00:00:00',1,'Offensive language','Some inappropriate phrases.'),(16,5,'Incredible worldbuilding and gameplay loop.',1,'2025-07-03 00:00:00',0,NULL,NULL),(17,3,'Not bad, but controls felt outdated.',0,'2025-07-04 00:00:00',0,NULL,NULL),(18,1,'Worst experience. Glitchy and shallow.',0,'2025-07-05 00:00:00',1,'Spam/Trolling','Feels like bait.'),(19,4,'Surprisingly fun with friends. Online mode is a blast.',1,'2025-07-06 00:00:00',0,NULL,NULL),(20,5,'Perfectly paced. I played it three times in a row.',1,'2025-07-06 00:00:00',0,NULL,NULL),(21,4,'Art style is amazing, and the gameplay is smooth.',0,'2025-07-06 00:00:00',0,NULL,NULL),(22,2,'Started strong, but ended up pretty repetitive.',0,'2025-07-06 00:00:00',1,'Low effort','Barely provides actual critique.'),(23,5,'Still my favorite game years later.',1,'2025-07-07 00:00:00',0,NULL,NULL),(24,4,'Great storytelling but could use better combat.',1,'2025-07-07 00:00:00',0,NULL,NULL);
/*!40000 ALTER TABLE `game_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `has_genre`
--

DROP TABLE IF EXISTS `has_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `has_genre` (
  `gameID` int NOT NULL,
  `genreID` int NOT NULL,
  PRIMARY KEY (`gameID`,`genreID`),
  KEY `genreID` (`genreID`),
  CONSTRAINT `has_genre_ibfk_1` FOREIGN KEY (`gameID`) REFERENCES `game` (`gameID`),
  CONSTRAINT `has_genre_ibfk_2` FOREIGN KEY (`genreID`) REFERENCES `game_genre` (`genreID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `has_genre`
--

LOCK TABLES `has_genre` WRITE;
/*!40000 ALTER TABLE `has_genre` DISABLE KEYS */;
INSERT INTO `has_genre` VALUES (1,1),(2,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(35,1),(36,1),(37,1),(38,1),(39,1),(40,1),(2,2),(8,2),(12,2),(17,2),(22,2),(25,2),(28,2),(34,2),(35,2),(38,2),(3,3),(4,3),(7,3),(10,3),(11,3),(12,3),(14,3),(15,3),(18,3),(20,3),(21,3),(22,3),(25,3),(29,3),(32,3),(33,3),(3,4),(6,4),(19,4),(13,5),(19,5),(39,5),(19,6),(23,6),(27,6),(40,6),(19,7),(23,7),(40,7),(24,8),(25,8),(27,9),(27,10);
/*!40000 ALTER TABLE `has_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `has_playstyle`
--

DROP TABLE IF EXISTS `has_playstyle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `has_playstyle` (
  `userID` int NOT NULL,
  `playstyleID` int NOT NULL,
  PRIMARY KEY (`userID`,`playstyleID`),
  KEY `playstyleID` (`playstyleID`),
  CONSTRAINT `has_playstyle_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `has_playstyle_ibfk_2` FOREIGN KEY (`playstyleID`) REFERENCES `playstyle` (`playstyleID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `has_playstyle`
--

LOCK TABLES `has_playstyle` WRITE;
/*!40000 ALTER TABLE `has_playstyle` DISABLE KEYS */;
INSERT INTO `has_playstyle` VALUES (2,1),(6,1),(13,1),(16,1),(20,1),(1,2),(5,2),(11,2),(19,2),(3,3),(7,3),(9,3),(17,3),(2,4),(8,4),(12,4),(17,4),(5,5),(6,5),(16,5),(19,5),(15,6),(3,7),(10,7),(12,7),(1,8),(4,8),(9,8),(14,8),(18,9),(7,10),(18,10),(20,10);
/*!40000 ALTER TABLE `has_playstyle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes_genre`
--

DROP TABLE IF EXISTS `likes_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `likes_genre` (
  `userID` int NOT NULL,
  `genreID` int NOT NULL,
  PRIMARY KEY (`userID`,`genreID`),
  KEY `genreID` (`genreID`),
  CONSTRAINT `likes_genre_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `likes_genre_ibfk_2` FOREIGN KEY (`genreID`) REFERENCES `game_genre` (`genreID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes_genre`
--

LOCK TABLES `likes_genre` WRITE;
/*!40000 ALTER TABLE `likes_genre` DISABLE KEYS */;
INSERT INTO `likes_genre` VALUES (5,1),(6,1),(11,1),(13,1),(17,1),(19,1),(20,1),(1,2),(3,2),(9,2),(10,2),(12,2),(19,2),(5,3),(11,3),(13,3),(2,4),(4,4),(8,4),(14,4),(16,4),(1,5),(3,5),(6,5),(10,5),(2,6),(7,6),(8,6),(12,6),(16,6),(17,6),(18,6),(4,7),(9,7),(14,7),(15,7),(18,7),(7,8),(15,10),(20,10);
/*!40000 ALTER TABLE `likes_genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `on_platform`
--

DROP TABLE IF EXISTS `on_platform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `on_platform` (
  `gameID` int NOT NULL,
  `platformID` int NOT NULL,
  PRIMARY KEY (`gameID`,`platformID`),
  KEY `platformID` (`platformID`),
  CONSTRAINT `on_platform_ibfk_1` FOREIGN KEY (`gameID`) REFERENCES `game` (`gameID`),
  CONSTRAINT `on_platform_ibfk_2` FOREIGN KEY (`platformID`) REFERENCES `game_platform` (`platformID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `on_platform`
--

LOCK TABLES `on_platform` WRITE;
/*!40000 ALTER TABLE `on_platform` DISABLE KEYS */;
INSERT INTO `on_platform` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(34,1),(35,1),(36,1),(37,1),(38,1),(39,1),(40,1),(1,2),(2,2),(8,2),(15,2),(17,2),(22,2),(25,2),(1,3),(2,3),(8,3),(15,3),(22,3),(25,3),(1,4),(2,4),(5,4),(8,4),(9,4),(10,4),(13,4),(15,4),(16,4),(17,4),(19,4),(21,4),(22,4),(23,4),(25,4),(27,4),(28,4),(30,4),(31,4),(32,4),(33,4),(36,4),(38,4),(39,4),(40,4),(1,5),(3,5),(4,5),(5,5),(6,5),(8,5),(10,5),(12,5),(13,5),(14,5),(19,5),(23,5),(26,5),(32,5),(36,5),(38,5),(39,5),(1,6),(3,6),(4,6),(5,6),(6,6),(7,6),(8,6),(10,6),(11,6),(12,6),(13,6),(14,6),(19,6),(23,6),(26,6),(29,6),(32,6),(34,6),(36,6),(38,6),(39,6),(1,7),(2,7),(3,7),(5,7),(8,7),(9,7),(10,7),(13,7),(15,7),(17,7),(18,7),(19,7),(21,7),(22,7),(23,7),(25,7),(26,7),(27,7),(30,7),(31,7),(32,7),(33,7),(36,7),(38,7),(39,7),(40,7),(2,8),(3,8),(5,8),(6,8),(7,8),(11,8),(12,8),(13,8),(14,8),(19,8),(20,8),(23,8),(24,8),(27,8),(30,8),(33,8),(34,8),(35,8),(36,8),(37,8),(38,8),(39,8),(40,8),(2,9),(6,9),(8,9),(10,9),(19,9),(21,9),(22,9),(23,9),(25,9),(27,9),(31,9),(33,9),(39,9),(40,9),(3,10),(4,10),(6,10),(7,10),(10,10),(11,10),(12,10),(13,10),(18,10),(19,10),(20,10),(23,10),(24,10),(27,10),(37,10),(38,10),(40,10),(6,11),(11,11),(12,11),(13,11),(19,11),(23,11),(36,11),(39,11),(11,12),(36,12),(12,13),(19,13),(23,13),(39,13),(13,14),(19,14),(23,14),(25,14),(36,14),(39,14),(15,15),(23,16),(23,17),(36,18);
/*!40000 ALTER TABLE `on_platform` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playstyle`
--

DROP TABLE IF EXISTS `playstyle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playstyle` (
  `playstyleID` int NOT NULL AUTO_INCREMENT,
  `playstyleName` varchar(50) NOT NULL,
  `playstyleDescription` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`playstyleID`),
  UNIQUE KEY `playstyleName` (`playstyleName`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playstyle`
--

LOCK TABLES `playstyle` WRITE;
/*!40000 ALTER TABLE `playstyle` DISABLE KEYS */;
INSERT INTO `playstyle` VALUES (1,'Casual','Plays games mainly for fun and relaxation, without focusing on competition or high skill.'),(2,'Competitive','Focuses on winning, ranking, or mastering game mechanics'),(3,'Explorer','Enjoys discovering game worlds, storylines, secrets, and lore rather than rushing through objectives.'),(4,'Strategist','Enjoys games that require tactical thinking, planning, and problem-solving.'),(5,'Immersive','Engages deeply with story and characters for a personal, narrative-driven experience.'),(6,'Completionist','Aims to experience every aspect of a game, including side quests, collectibles, and achievements, leaving no content unfinished.'),(7,'Social','Prefers games with social interaction, co-op play, or playing with friends.'),(8,'Speedrunner','Plays games aiming to finish them in the shortest time by mastering optimized routes, glitches, and precise execution.'),(9,'Content Creator','Plays games with the intent to entertain others online.'),(10,'Multitasker','Enjoys juggling multiple objectives or games simultaneously, often switching between activities.');
/*!40000 ALTER TABLE `playstyle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prefers_platform`
--

DROP TABLE IF EXISTS `prefers_platform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prefers_platform` (
  `userID` int NOT NULL,
  `platformID` int NOT NULL,
  PRIMARY KEY (`userID`,`platformID`),
  KEY `platformID` (`platformID`),
  CONSTRAINT `prefers_platform_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `prefers_platform_ibfk_2` FOREIGN KEY (`platformID`) REFERENCES `game_platform` (`platformID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prefers_platform`
--

LOCK TABLES `prefers_platform` WRITE;
/*!40000 ALTER TABLE `prefers_platform` DISABLE KEYS */;
INSERT INTO `prefers_platform` VALUES (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1),(11,2),(12,2),(13,2),(14,2),(20,2),(15,3),(16,3),(17,3),(20,4),(18,9),(19,9);
/*!40000 ALTER TABLE `prefers_platform` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `bio` text,
  `isAdmin` tinyint(1) DEFAULT NULL,
  `isVerified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`userID`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'modBot','mbot@example.com','adminPass',NULL,'Old-school gamer who helps with reviews.',1,1),(2,'jane_rpg','jane.rpg@example.com','admin123',NULL,'Enjoys story-driven games and moderates on the side.',1,1),(3,'reviewScout','reviewscout@example.com','watchfulEye',NULL,'Most likely leveling up in JRPGs.',1,1),(4,'strat_keeper','stratkeeper@example.com','secureSys4!',NULL,'Loves strategy games.',1,1),(5,'banterman42','banter@example.com','banTime!',NULL,'Always joking — except when banning trolls.',1,1),(6,'hawk_eye','hawk@example.com','rules123',NULL,'Sharp eyes for spam. Chill with platformers.',1,1),(7,'cyn_plays','cynthia.playz@example.com','rootedPass',NULL,'Spends free time playing co-op indies.',1,1),(8,'casualmodder','casualmod@example.com','flaggedUp!',NULL,'Helps out with moderation, mostly into simulation games.',1,1),(9,'quietguardian','guardian@example.com','superSecure',NULL,'Usually quiet. Big fan of tactical RPGs.',1,1),(10,'samwise','sam.mod@example.com','passMODx1',NULL,'Loves JRPGs and gardening games alike.',1,1),(11,'playerOne','player1@example.com','password1234','https://example.com/avatars/p1.png','I love action games.',0,1),(12,'gamer_dudel92','gamer92@example.com','securePass!','https://example.com/avatars/gg92.png','RPG and indie game lover.',0,1),(13,'noobmaster96','noobmaster@example.com','thor9696',NULL,'Casual gamer, mostly shooters.',0,0),(14,'strategistX','stratx@example.com','chess4life','https://example.com/avatars/stratx.png','Turn-based tactics are my jam.',0,1),(15,'speedrunner','speed@example.com','gottaGoFast',NULL,'Speedruns old school platformers.',0,1),(16,'c0zyc4t','cozy@example.com','whiskers!',NULL,'Chill games and farming sims.',0,0),(17,'retroreviver','retro@example.com','8bitRules',NULL,'Retro collector & reviewer.',0,1),(18,'indiehype','indie@example.com','indieIsKing',NULL,'Indie dev and fan of pixel art.',0,1),(19,'th3_legend','legend@example.com','raids4days',NULL,'Guild leader and MMORPG veteran.',0,1),(20,'chill_blaster','cb@example.com','g4me0n!',NULL,'Just here for the explosions.',0,1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `userID` int NOT NULL,
  `gameID` int NOT NULL,
  `dateAdded` date DEFAULT NULL,
  PRIMARY KEY (`userID`,`gameID`),
  KEY `gameID` (`gameID`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`),
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`gameID`) REFERENCES `game` (`gameID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
INSERT INTO `wishlist` VALUES (1,1,'2025-06-01'),(1,13,'2025-06-10'),(2,2,'2025-05-15'),(3,3,'2025-07-01'),(4,4,'2025-05-20'),(5,7,'2025-06-22'),(6,8,'2025-06-05'),(7,20,'2025-06-10'),(8,23,'2025-06-15'),(9,10,'2025-07-01'),(10,40,'2025-07-02'),(11,15,'2025-06-20'),(12,24,'2025-06-18'),(13,29,'2025-06-25'),(14,21,'2025-06-10'),(15,19,'2025-07-01'),(16,33,'2025-07-05'),(17,27,'2025-07-06'),(18,22,'2025-07-07');
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-11 15:45:31
