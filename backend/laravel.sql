-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : sam. 24 mai 2025 à 00:04
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `laravel`
--

-- --------------------------------------------------------

--
-- Structure de la table `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `telephone` varchar(255) NOT NULL,
  `fonction` varchar(255) DEFAULT NULL,
  `status` enum('actif','inactif') NOT NULL DEFAULT 'actif',
  `secteur_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role` enum('admin','superadmin') NOT NULL DEFAULT 'admin',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `admins`
--

INSERT INTO `admins` (`id`, `nom`, `prenom`, `email`, `password`, `telephone`, `fonction`, `status`, `secteur_id`, `role`, `created_at`, `updated_at`) VALUES
(1, 'Super', 'Admin', 'superadmin@e.com', '$2y$12$dLqaYpWwHEbbokdQYwaViODyJDnJdShkYh3/E5qKOo7ZnT3z7ri6m', '0654321890', NULL, 'actif', NULL, 'superadmin', '2025-04-20 08:54:01', '2025-05-23 11:44:20'),
(2, 'at', 'Admin', 'admin@e.com', '$2y$12$/eaWl54/YzixMkHMrnKoQeJ0emQUSbE//Qb25r3eyY6FlCI4uKvPi', '0654321890', NULL, 'actif', 1, 'admin', '2025-04-20 08:54:01', '2025-04-20 21:15:47'),
(3, 'admin', 'assia', 'assia@e.com', '$2y$12$WR5vIhKDPUY2dPvjhnmip.0QalSTDQ2mKghfwjDmw3kUwQQTyVOkS', '0536152346', 'Dev', 'actif', 7, 'admin', '2025-04-25 08:11:17', '2025-05-23 20:25:45'),
(5, 'haz', 'tasnim', 'tasnim@e.com', '$2y$12$.xK1uQuZUCmtAgXDCAQ.DOehpiFSl4kp8GaZQkls0vFMG7VoQaAEC', '0728378738', 'dev', 'actif', 8, 'admin', '2025-05-08 12:29:56', '2025-05-08 13:58:30'),
(6, 'har', 'houda', 'houda@e.com', '$2y$12$GuTGuxl326DG6oQvU3QJ9.X8./VkGA9ug5/RGan/fZ16tGzCO0Wm2', '0676456464', 'dev', 'inactif', 10, 'admin', '2025-05-08 12:30:53', '2025-05-17 07:49:04'),
(8, 'Mazi', 'Doudou', 'doudou@e.com', '$2y$12$//hIww0G6JzUh/s4Ld.F8eF8QIhPdNrJl9OZWZGd.O1QE8iW91esS', '0653321238', 'Directeur', 'actif', 3, 'admin', '2025-05-14 18:48:00', '2025-05-17 07:48:24'),
(9, 'Nait', 'Nourhane', 'nourhane@gmail.com', '$2y$12$LDhAqYTTtLgO3jd17n.DrePfH9rKL2XRUiiMKEaoqS6S47IYXzoRe', '07777777777', 'Dev', 'actif', 7, 'admin', '2025-05-17 07:46:38', '2025-05-17 07:46:38'),
(10, 'Benattela', 'Adem', 'adem@gmail.com', '$2y$12$a0X9qEYwqhLcBHzJPGV0Lev.q/oc6qin6BXi8WgF9TssEdSWOx/Q6', '0777777799', 'Dev', 'actif', 7, 'admin', '2025-05-17 07:47:24', '2025-05-17 07:58:26');

-- --------------------------------------------------------

--
-- Structure de la table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `documents_offre`
--

CREATE TABLE `documents_offre` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `offre_id` bigint(20) UNSIGNED NOT NULL,
  `document_pdf` varchar(255) DEFAULT NULL,
  `document_annulation` varchar(255) DEFAULT NULL,
  `document_infructueux` varchar(255) DEFAULT NULL,
  `document_prorogation` varchar(255) DEFAULT NULL,
  `journal` varchar(255) DEFAULT NULL,
  `document_pdf_ar` varchar(255) DEFAULT NULL,
  `document_annulation_ar` varchar(255) DEFAULT NULL,
  `document_infructueux_ar` varchar(255) DEFAULT NULL,
  `document_prorogation_ar` varchar(255) DEFAULT NULL,
  `journal_ar` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `documents_offre`
--

INSERT INTO `documents_offre` (`id`, `offre_id`, `document_pdf`, `document_annulation`, `document_infructueux`, `document_prorogation`, `journal`, `document_pdf_ar`, `document_annulation_ar`, `document_infructueux_ar`, `document_prorogation_ar`, `journal_ar`, `created_at`, `updated_at`) VALUES
(1, 14, 'documents/pdf/zq12oFU6E8tpVhazM9XN7x4zH8IJC342RN7skY9d.pdf', '', '', 'documents/prorogations/QQ57ZokyFmFPlDieVkvEoXSsw3Krp7nTSdGZNf3g.pdf', NULL, 'documents/pdf_ar/1F5TlCfzOFG3dPEo3459JuAUutJ396rEpWwN3hhE.pdf', '', NULL, 'documents/prorogations_ar/rRwoZSZ0gugNEKDoaPd4hKXqY9p1wfg1xyF6aRMA.pdf', NULL, '2025-05-08 12:38:44', '2025-05-14 21:01:01'),
(2, 15, 'documents/pdf/v6VQ0WO3jrtFpurNmHUAH9J7qkl2KLDr1IHDRGOP.pdf', NULL, NULL, NULL, NULL, 'documents/pdf_ar/ALevwLL4iltTodc5QCzcmDhRACN8LWiseSxsBicp.pdf', NULL, NULL, NULL, NULL, '2025-05-08 12:39:12', '2025-05-08 12:41:10'),
(3, 16, 'documents/pdf/4vpfaXRaeXTVktQI3vp1bPl7qH2AEwSkxWKM0THW.pdf', 'documents/annulations/PuJK5GV64C5QxOA1gHvzrFdADGLxEpgoD4dlVrOH.pdf', NULL, 'documents/prorogations/oxdGPMgd5Wc9ziNR9HfuB1XC0WW6fRxWohJ1LBYY.pdf', NULL, 'documents/pdf_ar/zeLnQkINgwHjCMgDbrgOVCxzAh4JxY49K8t8I8A4.pdf', 'documents/annulations_ar/UrH9VLOmgY3fLhVVNJqE4RROHiGMKoMYTTCNQgRj.pdf', NULL, 'documents/prorogations_ar/PqMWVD3G5Wu0ZZe921Yj7Bq7atVfsglgpTLelHNR.pdf', NULL, '2025-05-08 12:40:00', '2025-05-16 21:30:07'),
(4, 17, 'documents/pdf/vfkPNzebaaLuayhejmPe5xCyiQznB4Is82zf2R0G.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-08 12:58:42', '2025-05-08 12:58:42'),
(5, 18, 'documents/pdf/Narq0Pn1WLHw1lOYgE0lFXPu0ZQTQi12on77T7dI.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-08 12:59:44', '2025-05-08 12:59:44'),
(7, 20, 'documents/pdf/rbQy8bIeVonWPz3EoOcyr8KF5ibl6ztrRjVbX2fC.pdf', NULL, 'documents/infructueux/uMqAAZF4Aez4OORfPZ885FD64lpt1H4BSGC5wZQL.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-08 13:01:13', '2025-05-11 16:20:31'),
(8, 21, 'documents/pdf/4WagFxVF9loCSNAIl9wUuQKMJKOU6Rf3cEwH5SXS.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-08 13:03:00', '2025-05-08 13:03:00'),
(9, 22, 'documents/pdf/Mbf0ORrwIM5o5Btt0XQLbvke7VDuQ6E3SY9h9xnO.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-08 13:03:21', '2025-05-08 13:03:21'),
(12, 25, 'documents/pdf/LrGSZevdwm4YwSaGJWINDJ38jmbYNGrj82RqKfuM.pdf', NULL, NULL, NULL, NULL, 'documents/pdf_ar/giIZkhxnVHgWf1Xe95eujp8UkExnUjbXQQNYTwJh.pdf', NULL, NULL, NULL, NULL, '2025-05-08 15:55:52', '2025-05-23 20:06:12'),
(13, 26, 'documents/pdf/o4fahJeCLk5Ng9YClQZjmr765wYvnEOy2c4MBXxp.pdf', NULL, NULL, NULL, NULL, 'documents/pdf_ar/UarAVAwzD0gZVpN7qLHK8F4Xi3s39LgnCSD4P6FZ.pdf', NULL, NULL, NULL, NULL, '2025-05-15 20:58:36', '2025-05-23 20:10:27'),
(14, 27, 'documents/pdf/inPCO7chTqH3HhLr1jptLU5YikeODiKZPx1wHKyJ.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-16 13:19:34', '2025-05-16 13:19:34'),
(15, 28, 'documents/pdf/kNOwGTV3fmQC5rlnMkre9xIdusW9eSHYO79b6rUa.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-16 14:29:54', '2025-05-16 14:29:54'),
(16, 29, 'documents/pdf/WvO2ilIYg0T3qc1wnLJYUZ1LyVnrYTRPvztC1OG0.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-16 14:31:41', '2025-05-16 14:31:41'),
(17, 30, 'documents/pdf/PjzSjPQpv7RbBRp0TpRmtNKlRScLQ2DhOpB0UKCm.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-17 07:52:24', '2025-05-17 07:52:24'),
(18, 31, 'documents/pdf/QnuCbxGTh3WJxVQ7U9OknvMtg5dKsSPLWNQ8QXr8.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-17 07:53:18', '2025-05-17 07:53:18'),
(19, 32, 'documents/pdf/HVxrtHtWoviMsQ2S7d7mF2fzoiu7zdBAg6t9DGeo.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-17 07:54:01', '2025-05-17 07:54:01'),
(20, 33, 'documents/pdf/QuRnOqXRwWC3Oz8gaJeWJitDcuiqzHiq2XdoXnj1.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-17 07:54:56', '2025-05-17 07:54:56'),
(21, 34, 'documents/pdf/iIDOwcRB5XWMPfMlbQfBuxHzGG4wsA4Oe0tVrv5x.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-17 07:55:05', '2025-05-17 07:55:05'),
(22, 35, 'documents/pdf/33esb3aMTCXpwLUlZzQvUgUqyRXt0df9kof0ObDK.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-17 07:55:12', '2025-05-17 07:55:12'),
(23, 36, 'documents/pdf/W12zLt5ixaDq2yr0TtbvsYisHjrHrEWndRKbRe4f.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-17 07:55:24', '2025-05-17 07:55:24'),
(24, 37, 'documents/pdf/AVijCYl4qxxa1JcQrlziilpnF4chSQhjPQPAjt1U.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-17 07:56:10', '2025-05-17 07:56:10'),
(25, 38, 'documents/pdf/umQ6Nbw02SXAfXnZnlpGaOeBptN3jx9yEnyBMu2q.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-23 20:27:54', '2025-05-23 20:27:54'),
(26, 39, 'documents/pdf/2IqZ3I5ZsfZbI2M5bp9aBqJqD052BVyzIm3PdBqP.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-23 20:29:05', '2025-05-23 20:29:05'),
(27, 40, 'documents/pdf/qvHva4cmnDeBvTqa732krcFT3Fi7EyEPU5Ox8bW1.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-23 20:32:32', '2025-05-23 20:32:32'),
(28, 41, 'documents/pdf/lfh1Dj6FvbaugHsfTAu2wTZ2CidE0SjRMJTkh11d.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-23 20:33:33', '2025-05-23 20:33:33'),
(29, 42, 'documents/pdf/DLLJ3pyJeNDFaXtRgxSwmcAddSHYbgoaSP7NvwHk.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-23 20:34:09', '2025-05-23 20:34:09'),
(30, 43, 'documents/pdf/YLioz9Ndc4A9n40FvBMnwttvGxtQsOFqot5pPUNk.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-23 20:34:28', '2025-05-23 20:34:28'),
(31, 44, 'documents/pdf/hkBkbbJcRsN0HVKhgzK3LyeENWSmHlfU3BBEnSNQ.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-23 20:42:28', '2025-05-23 20:42:28'),
(32, 45, 'documents/pdf/yRWCj2DIFY0kzFgWBaj7dr7Ez34TwrrrT7O0LWTB.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-23 20:42:58', '2025-05-23 20:42:58'),
(33, 46, 'documents/pdf/boWUFoiEIFLfu7maebq7vq1AUCZG5Odv6qR1cJ6j.pdf', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-05-23 20:49:20', '2025-05-23 20:49:20');

-- --------------------------------------------------------

--
-- Structure de la table `document_soumissions`
--

CREATE TABLE `document_soumissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `soumission_id` bigint(20) UNSIGNED NOT NULL,
  `nom_fichier` varchar(255) NOT NULL,
  `chemin_fichier` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `document_soumissions`
--

INSERT INTO `document_soumissions` (`id`, `soumission_id`, `nom_fichier`, `chemin_fichier`, `created_at`, `updated_at`) VALUES
(17, 25, 'fiche.pdf', 'soumissions/1747502504_jEDjSYtn_fiche.pdf', '2025-05-17 16:21:44', '2025-05-17 16:21:44'),
(18, 26, 'fiche.pdf', 'soumissions/1747836856_G4mPNEeq_fiche.pdf', '2025-05-21 13:14:17', '2025-05-21 13:14:17'),
(19, 27, 'fiche.pdf', 'soumissions/1747836858_aZnean9q_fiche.pdf', '2025-05-21 13:14:18', '2025-05-21 13:14:18'),
(20, 28, 'annulation.pdf', 'soumissions/1748037221_CTxfX4WX_annulation.pdf', '2025-05-23 20:53:41', '2025-05-23 20:53:41'),
(21, 29, '3. crypto sym.pdf', 'soumissions/1748037339_34Yh4V4Q_3. crypto sym.pdf', '2025-05-23 20:55:39', '2025-05-23 20:55:39'),
(22, 30, 'fiche.pdf', 'soumissions/1748037613_f50b3cmo_fiche.pdf', '2025-05-23 21:00:13', '2025-05-23 21:00:13');

-- --------------------------------------------------------

--
-- Structure de la table `entreprises`
--

CREATE TABLE `entreprises` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom_entreprise` varchar(255) NOT NULL,
  `activite` varchar(255) NOT NULL,
  `categorie` varchar(255) NOT NULL,
  `pays` varchar(255) NOT NULL,
  `wilaya` varchar(255) DEFAULT NULL,
  `adresse` varchar(255) NOT NULL,
  `code_commerce` varchar(255) NOT NULL,
  `num_fiscal` varchar(255) NOT NULL,
  `num_statistique` varchar(255) NOT NULL,
  `num_national` varchar(255) NOT NULL,
  `nombre_employes` varchar(255) NOT NULL,
  `logo` varchar(255) DEFAULT NULL COMMENT 'Chemin ou URL du logo de l''entreprise',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `entreprises`
--

INSERT INTO `entreprises` (`id`, `nom_entreprise`, `activite`, `categorie`, `pays`, `wilaya`, `adresse`, `code_commerce`, `num_fiscal`, `num_statistique`, `num_national`, `nombre_employes`, `logo`, `created_at`, `updated_at`) VALUES
(1, 'Ministère de la Poste et des Télécommunications', 'Télécommunications', 'Public', 'Algérie', 'Alger', 'Adresse non définie', 'mpt', 'mpt-FISCAL', 'mpt-STAT', 'mpt-NAT', '0', 'storage/logo/logo-ministere.png', '2025-04-20 08:54:00', '2025-04-20 08:54:00'),
(2, 'cevital', 'Assurance et Banque', 'Entreprise Publique', 'Algérie', 'Alger', '321,2sasafd', '1243', '334234', '4324', '4234', '10', 'storage/logo/default.png', '2025-04-20 23:09:57', '2025-04-20 23:09:57'),
(3, 'sumame', 'Aéronautique', 'ANSEJ', 'Australie', NULL, 'wdadad', '213123', '1323123', '12323', '23123', '10', 'storage/logo/default.png', '2025-04-20 23:18:26', '2025-04-20 23:18:26'),
(11, 'dawdaw', 'Energie et Service pétrolier', 'SPA', 'Autriche', NULL, 'addaw', 'awdwad', 'dwawd', 'adwdadw', 'adw', '10', 'storage/logo/default.png', '2025-04-25 09:14:42', '2025-04-25 09:14:42'),
(12, 'wdwqe', 'Chimie', 'Entreprise Publique', 'Arménie', NULL, 'wdaad', 'awdd', 'awd', 'waddaw', 'dad', '10', 'storage/logo/default.png', '2025-04-25 11:16:15', '2025-04-25 11:16:15'),
(13, 'wad', 'Pétrochimie', 'SPA', 'Afrique du Sud', NULL, 'tyjty', 'tyj', 'jytjt', 'jty', 'jtj', '10-49', 'storage/logo/default.png', '2025-04-25 11:54:09', '2025-04-25 11:54:09'),
(14, 'wda', 'Pétrochimie', 'Entreprise Publique', 'Argentine', NULL, 'addawdwa', 'awdad', 'dwad', 'awd', 'dwwa', '50-249', 'storage/logo/default.png', '2025-04-25 13:11:55', '2025-04-25 13:11:55'),
(15, 'wdadw', 'Chimie', 'ANGEM', 'Aruba', NULL, 'awdaw', 'd', 'ada', 'frgr', 'vdv', '10-49', 'storage/logo/default.png', '2025-04-25 17:51:16', '2025-04-25 17:51:16'),
(16, 'wdad', 'Pétrochimie', 'SPA', 'Algérie', 'Tlemcen', 'wadad', 'wdad', 'adwa', 'dc', 'c', '50-249', 'storage/logo/default.png', '2025-04-25 18:06:29', '2025-04-25 18:06:29'),
(17, 'adwd', 'Energie et Service pétrolier', 'Entreprise Publique', 'Vanuatu', NULL, 'vf', 'dfv', 'dvfvvt', 'tbrfdc', 'xdfdf', '-10', 'storage/logo/default.png', '2025-04-25 19:10:29', '2025-04-25 19:10:29'),
(18, 'ycfec', 'Pétrochimie', 'SARL', 'Autriche', NULL, 'HDWJHDJ', '717717', '181990728', '2782', '123456789127', '-10', 'storage/logo/default.png', '2025-04-26 08:00:11', '2025-04-26 08:00:11'),
(19, 'qwe', 'Pétrochimie', 'Entreprise Publique', 'Albanie', NULL, 'refef', 'rfefef', 'er', 'frfe', 'refe', '50-249', 'storage/logo/default.png', '2025-04-27 07:46:10', '2025-04-27 07:46:10'),
(20, 'arter', 'Pétrochimie', 'Entreprise Publique', 'Afrique du Sud', NULL, 'h', 'huhu', 'reg', 'rggr', 'ergg', '10-49', 'storage/logo/default.png', '2025-04-27 07:59:50', '2025-04-27 07:59:50'),
(21, 'assia', 'Energie et Service pétrolier', 'SARL', 'Yémen', NULL, 'hyy', 'sf', 'sefesf', 'fsff', 'sef', '10-49', 'storage/logo/default.png', '2025-04-27 08:11:30', '2025-04-27 08:11:30'),
(22, 'ada', 'Energie et Service pétrolier', 'SNC', 'Bahreïn', NULL, 'cvbcvb', 'vcbcvc', 'vbv', 'bvb', 'cvb', '10-49', 'storage/logo/default.png', '2025-04-27 08:22:49', '2025-04-27 08:22:49'),
(23, 'dwad', 'Pétrochimie', 'Entreprise Publique', 'Bahamas', NULL, 'awdwa', 'awdwadaw', 'dwaduy', 'awaduytuyt', 'dayuty', '10-49', 'storage/logo/default.png', '2025-05-05 08:49:42', '2025-05-05 08:49:42'),
(24, 'dawgreg', 'Pétrochimie', 'Entreprise Publique', 'Autriche', NULL, 'regreg', 'rgegreg', 'regawdwa', 'regrwdwad', 'daddwad', '10-49', 'storage/logo/default.png', '2025-05-05 09:04:47', '2025-05-05 09:04:47'),
(25, 'ed', 'Elevage', 'SNC', 'Fidji', NULL, 'efw', 'ewfht', 'hhtr', 't', 'thrh', '10-49', 'storage/logo/default.png', '2025-05-05 09:13:33', '2025-05-05 09:13:33'),
(26, 'gregrg', 'Pétrochimie', 'TPE (STARTUP)', 'Tonga', NULL, 'uu', 'tuu', 'tut', 'ut6ut6u', 'utu', '10-49', 'storage/logo/default.png', '2025-05-05 09:16:01', '2025-05-05 09:16:01'),
(27, 'efw', 'Equipement industriel', 'SPA', 'Azerbaïdjan', NULL, 'fdsf', 'dsfdsf', 'dsf', 'dfdf', 'fdfewfc', '10-49', 'storage/logo/default.png', '2025-05-05 09:22:15', '2025-05-05 09:22:15'),
(28, 'fewf', 'Energie et Service pétrolier', 'SNC', 'Antigua-et-Barbuda', NULL, 'vfdvv', 'fvfdv', 'vfdvfd', 'fdv', 'fdv', '-10', 'storage/logo/default.png', '2025-05-05 09:27:41', '2025-05-05 09:27:41'),
(29, 'super', 'Bâtiment et Génie civil', 'Entreprise Publique', 'Algérie', 'Blida', 'asdasd', '3213123', '123213', '123123', '123132132132131233', '-10', 'storage/logo/default.png', '2025-05-16 18:57:59', '2025-05-16 18:57:59'),
(30, 'entreprise', 'Chimie', 'SCS', 'Algérie', 'Tiaret', '99999', '1234567', '12345678', '321d88', '123456789087654321', '10-49', 'storage/logo/default.png', '2025-05-17 16:20:12', '2025-05-17 16:20:12'),
(31, 'entreprise', 'Pétrochimie', 'SCS', 'Arménie', NULL, 'asdasd', 'sdas', 'dasd', 'asdsad', '342222222222222222', '10-49', 'storage/logo/default.png', '2025-05-21 12:20:24', '2025-05-21 12:20:24');

-- --------------------------------------------------------

--
-- Structure de la table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `favorites`
--

CREATE TABLE `favorites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `offre_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `favorites`
--

INSERT INTO `favorites` (`id`, `user_id`, `offre_id`, `created_at`, `updated_at`) VALUES
(17, 31, 14, '2025-05-17 16:20:57', '2025-05-17 16:20:57'),
(18, 31, 15, '2025-05-17 16:20:59', '2025-05-17 16:20:59'),
(19, 32, 14, '2025-05-21 13:50:50', '2025-05-21 13:50:50');

-- --------------------------------------------------------

--
-- Structure de la table `historique_soumissions`
--

CREATE TABLE `historique_soumissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `soumission_id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED NOT NULL,
  `ancien_statut` varchar(255) DEFAULT NULL,
  `nouveau_statut` varchar(255) NOT NULL,
  `ancien_commentaire` text DEFAULT NULL,
  `nouveau_commentaire` text DEFAULT NULL,
  `date_modification` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `historique_soumissions`
--

INSERT INTO `historique_soumissions` (`id`, `soumission_id`, `admin_id`, `ancien_statut`, `nouveau_statut`, `ancien_commentaire`, `nouveau_commentaire`, `date_modification`, `created_at`, `updated_at`) VALUES
(45, 25, 3, 'En attente', 'Acceptée', NULL, NULL, '2025-05-17 16:31:43', NULL, NULL),
(46, 26, 3, 'En attente', 'Rejetée', NULL, NULL, '2025-05-21 13:56:41', NULL, NULL),
(47, 26, 3, 'Rejetée', 'Rejetée', NULL, NULL, '2025-05-21 13:56:47', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `lots`
--

CREATE TABLE `lots` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `offre_id` bigint(20) UNSIGNED NOT NULL,
  `numero_lot` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `description_ar` text DEFAULT NULL,
  `document_pdf` varchar(255) DEFAULT NULL,
  `statut` enum('En cours','Attribué','Annulé') NOT NULL DEFAULT 'En cours',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `lots`
--

INSERT INTO `lots` (`id`, `offre_id`, `numero_lot`, `description`, `description_ar`, `document_pdf`, `statut`, `created_at`, `updated_at`) VALUES
(1, 14, 'N° 01', 'Travaux de raccordement final des clients en fibre optique Travaux de raccordement final des clients en cuivre', 'إعلان عن طلب عروض وطني مفتوح مع شرط الحد الأدنى من القدرات رقم 16/2025', NULL, 'En cours', '2025-05-08 12:38:44', '2025-05-23 20:50:39'),
(2, 14, 'N° 02', 'Travaux de raccordement final des clients en cuivre', 'إعلان عن طلب عروض وطني مفتوح مع شرط الحد الأدنى من القدرات رقم 16/2025', NULL, 'Attribué', '2025-05-08 12:38:44', '2025-05-23 20:50:39'),
(3, 15, 'N° 01', 'Travaux de raccordement final des clients en fibre optique Travaux de raccordement final des clients en cuivre', '\"أشغال الربط النهائي للزبائن بواسطة الألياف البصرية \" \"أشغال الربط النهائي للزبائن بواسطة اسلاك النحاس \"', NULL, 'En cours', '2025-05-08 12:39:12', '2025-05-23 20:51:22'),
(4, 15, 'N° 02', 'Travaux de raccordement final des clients en cuivre', '\"أشغال الربط النهائي للزبائن بواسطة الألياف البصرية \" \"أشغال الربط النهائي للزبائن بواسطة اسلاك النحاس \"', NULL, 'Attribué', '2025-05-08 12:39:12', '2025-05-23 20:51:22'),
(5, 16, 'N° 01', 'Travaux de raccordement final des clients en fibre optique Travaux de raccordement final des clients en cuivre', 'اقتناء لوازم التسليح الخاصة بالشبكة الهوائية والأعمدة الهاتفية', NULL, 'En cours', '2025-05-08 12:40:00', '2025-05-23 20:51:41'),
(6, 16, 'N° 02', 'Travaux de raccordement final des clients en cuivre', 'اقتناء لوازم التسليح الخاصة بالشبكة الهوائية والأعمدة الهاتفية', NULL, 'En cours', '2025-05-08 12:40:00', '2025-05-23 20:51:41'),
(11, 25, 'N° 01', 'Travaux de canalisation pour développement 150 logements KALITOUSSA OPGI', 'أشغال تهيئة مقر المديرية العملياتية للاتصالات بريكة 1', NULL, 'En cours', '2025-05-23 20:06:12', '2025-05-23 20:06:12'),
(12, 25, 'N° 02', 'Travaux de canalisation pour développement logements BONA PROM', 'أشغال تهيئة مقر المديرية العملياتية للاتصالات بريكة 2', NULL, 'En cours', '2025-05-23 20:06:12', '2025-05-23 20:06:12'),
(13, 15, 'N° 03', 'Travaux de raccordement final des clients en cuivre', NULL, NULL, 'En cours', '2025-05-23 20:52:29', '2025-05-23 20:52:29');

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000001_create_cache_table', 1),
(2, '0001_01_01_000002_create_jobs_table', 1),
(3, '2025_02_10_191525_create_personal_access_tokens_table', 1),
(4, '2025_02_14_140615_create_secteurs_table', 1),
(5, '2025_02_14_205042_create_entreprises_table', 1),
(6, '2025_02_15_000000_create_users_table', 1),
(7, '2025_03_10_133309_create_admins_table', 1),
(8, '2025_03_11_163113_create_offres_table', 1),
(9, '2025_03_12_194642_create_lots_table', 1),
(10, '2025_03_15_232527_create_soumissions_table', 1),
(11, '2025_03_15_232846_create_document_soumissions_table', 1),
(12, '2025_03_19_135449_create_favorites_table', 1),
(13, '2025_04_20_091219_create_documents_offre_table', 1),
(14, '2025_10_01_000000_create_historique_soumissions_table', 1),
(16, '2025_04_27_101113_create_suggestions_table', 2),
(17, '2025_05_01_214548_create_notifications_custom_table', 3);

-- --------------------------------------------------------

--
-- Structure de la table `notifications_custom`
--

CREATE TABLE `notifications_custom` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `notifications_custom`
--

INSERT INTO `notifications_custom` (`id`, `user_id`, `message`, `is_read`, `created_at`, `updated_at`) VALUES
(23, 31, 'Votre soumission pour l\'offre \'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITÉS MINIMALES N°03/2025\' a été acceptée', 1, '2025-05-17 16:31:46', '2025-05-17 16:31:46'),
(25, 32, 'Votre soumission pour l\'offre \'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITÉS MINIMALES N°03/2025\' a été rejetée', 1, '2025-05-21 13:56:49', '2025-05-21 13:56:49');

-- --------------------------------------------------------

--
-- Structure de la table `offres`
--

CREATE TABLE `offres` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `secteur_id` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED NOT NULL,
  `langue` varchar(255) NOT NULL DEFAULT 'Français',
  `etat_offre` varchar(255) NOT NULL DEFAULT 'En Cours',
  `wilaya` varchar(255) DEFAULT NULL,
  `numero_offre` varchar(255) NOT NULL,
  `titre_offre` varchar(255) NOT NULL,
  `titre_offre_ar` varchar(255) DEFAULT NULL,
  `type_offre` enum('Appel d''offre','Avis de consultation','Avis de manifestation') NOT NULL,
  `niveau` enum('National','International') NOT NULL DEFAULT 'National',
  `date_publication` date NOT NULL,
  `date_limite` date DEFAULT NULL,
  `date_prorogation` date DEFAULT NULL,
  `description` text DEFAULT NULL,
  `description_ar` text DEFAULT NULL,
  `etat` varchar(255) NOT NULL DEFAULT 'En rédaction',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `offres`
--

INSERT INTO `offres` (`id`, `secteur_id`, `admin_id`, `langue`, `etat_offre`, `wilaya`, `numero_offre`, `titre_offre`, `titre_offre_ar`, `type_offre`, `niveau`, `date_publication`, `date_limite`, `date_prorogation`, `description`, `description_ar`, `etat`, `created_at`, `updated_at`) VALUES
(14, 7, 10, 'francais', 'Attribué', 'Bejaia', 'N°03/2025', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITÉS MINIMALES N°03/2025', 'إعلان عن طلب عروض وطني مفتوح مع شرط الحد الأدنى من القدرات رقم 16/2025', 'Appel d\'offre', 'National', '2025-05-21', '2025-05-22', '2025-05-23', 'Travaux de raccordement final des clients en fibre optique Travaux de raccordement final des clients en cuivre', 'اقتناء لوازم التسليح الخاصة بالشبكة الهوائية والأعمدة الهاتفية', 'Publiée', '2025-05-08 12:38:43', '2025-05-23 20:50:39'),
(15, 7, 10, 'francais', 'Attribué', 'Constantine', 'N°16/2025', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCES DE CAPACITES MINIMALES N°16/2025', 'إعلان عن مناقصة وطنية مفتوحة مع اشتراط الحد الأدنى من القدرات رقم 03/2025', 'Appel d\'offre', 'National', '2025-05-23', '2025-05-30', NULL, 'Acquisition d’accessoires et armement pour les réseaux aériens et les poteaux téléphoniques d’Algérie Télécom', '\"أشغال الربط النهائي للزبائن بواسطة الألياف البصرية \" \"أشغال الربط النهائي للزبائن بواسطة اسلاك النحاس \"', 'Publiée', '2025-05-08 12:39:12', '2025-05-23 20:51:22'),
(16, 7, 10, 'francais', 'Annulé', 'Constantine', 'N°: 04/2025 2ème Relance suite à l’infructuosité', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITÉS MINIMALES N°: 04/2025 2ème Relance suite à l’infructuosité', 'إعلان عن طلب عروض وطني مفتوح مع شرط الحد الأدنى من القدرات رقم 16/2025', 'Appel d\'offre', 'National', '2025-05-08', '2025-05-22', '2025-05-23', 'DÉSINFECTION, NETTOYAGE, ENTRETIEN A COMMANDES DES IMMEUBLES ET DES MEUBLES DES SITES ALGÉRIE TÉLÉCOM DOT – BBA', 'اقتناء لوازم التسليح الخاصة بالشبكة الهوائية والأعمدة الهاتفية', 'Publiée', '2025-05-08 12:40:00', '2025-05-23 20:51:41'),
(17, 8, 5, 'francais', 'En Cours', 'Tébessa', '10/04/ATM/DG/DVALP/DPMGC/25', 'Appel d\'offres National Restreint', NULL, 'Appel d\'offre', 'National', '2025-05-08', '2025-05-26', NULL, 'La réalisation des prestations de conception d’une nouvelle organisation d’ATM Mobilis et l’accompagnement dans sa mise en œuvre.', NULL, 'Publiée', '2025-05-08 12:58:42', '2025-05-08 12:58:42'),
(18, 8, 5, 'francais', 'En Cours', 'Béchar', 'N° 21/AT/DG/DAMP/DAM/2020', 'AVIS DE PROROGATION DE DÉLAI DE L’APPEL D\'OFFRES NATIONAL ET INTERNATIONAL OUVERT AVEC EXIGENCE DE CAPACITÉS MINIMALES N° 21/AT/DG/DAMP/DAM/2020', 'مشروع اتفاقية لاقتناء اللوازم الاستهلاكية للاعلام الالي', 'Avis de manifestation', 'National', '2025-04-10', '2025-05-26', NULL, 'AVIS DE PROROGATION DE DÉLAI DE L’APPEL D\'OFFRES NATIONAL ET INTERNATIONAL OUVERT AVEC EXIGENCE DE CAPACITÉS MINIMALES N° 21/AT/DG/DAMP/DAM/2020', 'إعلان إستشارة عقد الإيجار السيارات على مستوى هياكل المديرية الجهوية لوهران أ ت أم موبيليس.', 'Publiée', '2025-05-08 12:59:44', '2025-05-08 12:59:44'),
(20, 8, 5, 'francais', 'En Cours', 'Tlemcen', 'N°20/2019', 'l’Avis de prorogation de l’Appel d’Offres National Restreint n°20/2019', 'توريد الورق الأبيض صنف أ4 وزن 80غرام', 'Avis de manifestation', 'National', '2025-03-13', '2025-05-26', NULL, 'l’Avis de prorogation de l’Appel d’Offres National Restreint n°20/2019 portant acquisition et la mise en place d’une solution de Gestion de Flotte et la fourniture des équipements et services associés', 'مشروع إتفاقية لإقتناء لوازم مكتبية', 'Publiée', '2025-05-08 13:01:13', '2025-05-08 13:01:13'),
(21, 10, 6, 'francais', 'En Cours', 'Oum El Bouaghi', '03/2022', 'Réalisation des travaux de réhabilitation du bp OULED FAYET ALGER OUEST', NULL, 'Avis de manifestation', 'National', '2025-05-09', '2025-05-16', NULL, 'Réalisation des travaux de réhabilitation du bp OULED FAYET ALGER OUEST', NULL, 'Publiée', '2025-05-08 13:03:00', '2025-05-08 13:03:00'),
(22, 10, 1, 'francais', 'Annulé', 'Tlemcen', '01/2022', 'TRAVAUX DE RÉHABILITATION BUREAU DE POSTE MAZOUNA (JOURNAL ELDJAZAIR EL DJADIDA', NULL, 'Avis de manifestation', 'National', '2025-05-09', '2025-05-16', NULL, 'TRAVAUX DE RÉHABILITATION BUREAU DE POSTE MAZOUNA (JOURNAL ELDJAZAIR EL DJADIDA', NULL, 'Publiée', '2025-05-08 13:03:21', '2025-05-14 21:01:22'),
(25, 7, 1, 'arabe', 'En Cours', 'Bejaia', 'N° 02/2025', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITÉS MINIMALES N° 02/2025', 'إعلان عن مناقصة وطنية مفتوحة مع اشتراط الحد الأدنى من القدرات رقم 08/2025', 'Appel d\'offre', 'National', '2025-05-22', '2025-05-09', NULL, 'Travaux de développement du réseau de distribution optique (ODN) et modernisation du réseau de distribution cuivre (CDN) en ODN , y compris le raccordement des clients à moderniser', 'أشغال تهيئة مقر المديرية العملياتية للاتصالات بريكة على مستوى مركز التراسل بريكة CT 8 سابقا وأشغال الطرق والشبكات المختلفة (VRD)', 'Publiée', '2025-05-08 15:55:52', '2025-05-23 20:05:46'),
(26, 7, 1, 'francais', 'Attribué', 'Chlef', 'N°44/AT/DG/DAMP/DAM/2024', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITES MINIMALES N°44/AT/DG/DAMP/DAM/2024', 'علان عن مناقصة وطنية مفتوحة مع اشتراط الحد الأدنى من القدرات', 'Appel d\'offre', 'National', '2025-05-15', '2025-05-30', NULL, 'TRAVAUX DE MAINTENANCE ET DE DÉVELOPPEMENT DE LA CANALISATION POUR LE RÉSEAU FTTX (CONTRAT D\'ADHÉSION)', 'أشغال تهيئة مقر المديرية العملياتية للاتصالات بريكة على مستوى مركز التراسل بريكة CT 8 سابقا وأشغال الطرق والشبكات المختلفة (VRD)', 'Publiée', '2025-05-15 20:58:36', '2025-05-23 20:10:53'),
(27, 7, 3, 'francais', 'En Cours', 'Mascara', '\r\nN° 15/2025', 'AVIS DE CONSULTATION NATIONALE N° 15/2025', 'إعلان عن استشارة وطنية رقم 15/2025', 'Avis de consultation', 'National', '2025-05-23', '2025-05-30', NULL, 'Réalisation des travaux de Pose Et Raccordement de Câbles A Fibre Optique', 'وضع وربط كوابل الألياف البصرية', 'Publiée', '2025-05-16 13:19:34', '2025-05-16 13:19:34'),
(28, 7, 3, 'francais', 'En Cours', 'Oum El Bouaghi', 'N° 11/2025\r\n', '\r\nAVIS DE CONSULTATION N° 11/2025\r\n', 'إعلان عن استشارة رقم 11/2025\r\n', 'Avis de consultation', 'National', '2025-05-18', '2025-05-28', NULL, '\r\n« Élimination Des Appareils Électriques À Base De Polychlorobiphényles (PCB), Des Huiles (PCB) Et La Décontamination Des Sols »', '\r\n» إزالة الأجهزة الكهربائية التي تحتوي على ثنائي الفينيل متعدد الكلور (PCB) من زيوت ثنائي الفينيل (PCB) متعدد الكلور وإزالة تلوث التربة «', 'Publiée', '2025-05-16 14:29:54', '2025-05-16 14:29:54'),
(29, 7, 1, 'francais', 'En Cours', 'Oum El Bouaghi', 'N°: 02/2025', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITES MINIMALES N°: 02/2025', NULL, 'Avis de manifestation', 'National', '2025-05-22', '2025-05-23', NULL, 'Travaux de Réalisation d’Infrastructure d’Accueil Pose et Raccordement de Câbles A Fibre Optique', NULL, 'Publiée', '2025-05-16 14:31:41', '2025-05-23 20:13:23'),
(30, 7, 1, 'francais', 'Attribué', 'Chlef', 'N°45/AT/DG/DAMP/DAM/2024« Relance »', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITES MINIMALES N°45/AT/DG/DAMP/DAM/2024« Relance »', NULL, 'Appel d\'offre', 'National', '2025-05-17', '2025-05-17', NULL, 'FOURNITURE, INSTALLATION ET MISE EN SERVICE DES SYSTÈMES DE DÉTECTION AUTOMATIQUE D’INCENDIE (SDAI) CONVENTIONNEL, DES SYSTÈME DÉTECTION AUTOMATIQUE D\'INCENDIE (SDAI) ADRESSABLE & DES SYSTÈMES DÉTECTION EXTINCTION AUTOMATIQUE D’INCENDIE (SDEAI) Y COMPRIS LA FORMATION', NULL, 'Publiée', '2025-05-17 07:52:24', '2025-05-23 20:14:23'),
(31, 7, 1, 'francais', 'En Cours', 'Laghouat', 'N° 03/AT/DG/DCMI/CTMER/2025', 'APPEL A MANIFESTATION D’INTERET NATIONAL N° 03/AT/DG/DCMI/CTMER/2025', NULL, 'Appel d\'offre', 'National', '2025-05-19', '2025-05-30', NULL, 'la présélection de déposants pour un partenariat dans le cadre du Dépôt Vente', NULL, 'En rédaction', '2025-05-17 07:53:18', '2025-05-23 20:15:17'),
(32, 7, 1, 'francais', 'En Cours', 'Laghouat', 'N°/06/2025', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITES MINIMALES N°/06/2025', NULL, 'Appel d\'offre', 'National', '2025-05-23', '2025-05-17', NULL, 'Réalisation d’infrastructures d’accueil pose et raccordement de câbles à fibre optique', NULL, 'En rédaction', '2025-05-17 07:54:01', '2025-05-23 20:16:30'),
(33, 7, 1, 'francais', 'En Cours', 'Oum El Bouaghi', 'N° 03/2025', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITÉS MINIMALES N° 03/2025', NULL, 'Avis de manifestation', 'National', '2025-05-13', '2025-05-17', NULL, '« Contrat d’Adhésion à Commandes Pour : Travaux de Développement et Maintenance de la Canalisation pour les Réseaux FTTX wilaya de Biskra »', NULL, 'En rédaction', '2025-05-17 07:54:56', '2025-05-23 20:17:31'),
(34, 7, 3, 'francais', 'En Cours', 'Oum El Bouaghi', '\r\nN° 06/2025\r\n\r\n', '\r\nAVIS DE CONSULTATION NATIONALE N° 06/2025', 'إعلان عن استشارة وطنية رقم 06/2025', 'Avis de consultation', 'National', '2025-05-13', '2025-05-17', NULL, 'Prestation d’Entretien et Nettoyage du SKILLS CENTER SETIF', 'خدمات الصيانة والنظافة لمركز المهارات بسطيف', 'En rédaction', '2025-05-17 07:55:05', '2025-05-17 07:55:05'),
(35, 7, 1, 'francais', 'En Cours', 'Oum El Bouaghi', 'N° 06/2025', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITES MINIMALES N° 06/2025', NULL, 'Avis de consultation', 'National', '2025-05-13', '2025-05-17', NULL, 'Travaux de développement de la canalisation, FTTX pour sept (07) lots séparés', NULL, 'En rédaction', '2025-05-17 07:55:12', '2025-05-23 20:18:17'),
(36, 7, 1, 'francais', 'En Cours', 'Oum El Bouaghi', '03/2024', 'Travaux de construction d\'un bureau de poste+ logement d\'astreinte à BENI SLIMANE ,DUPW MEDEA', NULL, 'Avis de manifestation', 'National', '2025-05-13', '2025-05-17', NULL, 'Travaux de construction d\'un bureau de poste+ logement d\'astreinte à BENI SLIMANE ,DUPW MEDEA', NULL, 'En rédaction', '2025-05-17 07:55:24', '2025-05-23 20:20:03'),
(37, 7, 1, 'francais', 'En Cours', 'Oum El Bouaghi', 'N° 04/2025', 'Avis d\'Appel d\'Offres National Ouvert avec Exigence de Capacités Minimales N° 04/20', NULL, 'Avis de manifestation', 'National', '2025-05-13', '2025-06-07', NULL, '« Conclusion de contrat d\'adhésion à commandes pour une durée d’une (01) année, renouvelable d’année en année et qui ne peut excéder trois (03) années pour travaux de maintenance et de développement de la canalisation pour le réseau FTTX »', NULL, 'En rédaction', '2025-05-17 07:56:10', '2025-05-23 20:12:18'),
(38, 7, 3, 'francais', 'Infructueux', 'Laghouat', 'N 006-2025', 'Avis d\'Appel d\'Offres National Restreint N° 006/2025', NULL, 'Avis de consultation', 'National', '2025-05-19', '2025-05-23', NULL, 'RÉALISATION DES TRAVAUX DE GÉNIE CIVIL ET POSE DE CÂBLE À FIBRES OPTIQUES AU PROFIT DU BUREAU DE POSTE OULED SLIMANE (SKIKDA).', NULL, 'Publiée', '2025-05-23 20:27:54', '2025-05-23 20:27:54'),
(39, 7, 3, 'francais', 'Attribué', 'Batna', 'N° : 01/AT/DO29/SDT/DPS/2025', 'AVIS D’APPEL D’OFFRES OUVERT N° : 01/AT/DO29/SDT/DPS/2025', NULL, 'Avis de consultation', 'National', '2025-05-19', '2025-05-23', NULL, 'Travaux de canalisations et chambres téléphoniques dans le cadre du plan d’action 2018\" répartis comme suit : Lot n° 01 : Cité 215 LGTS +Lotissement -BOUHANIFIA Lot n° 02 : SIDI SLIMANE -BOUHANIFIA Lot n° 03 : Lotissement AIN EL BEIDA SUD -MASCARA Lot n° 04 : Cité BEKHEITIA -MOHAMMADIA Lot n° 05 : HAI BLAHA-BOUHENNI Lot n° 06 : Coopérative DJEBLI- GHRISS Lot n° 07 : AIN FEKKAN centre Lot n° 08 : Cité des JARDINS -ZAHANA', NULL, 'En rédaction', '2025-05-23 20:29:05', '2025-05-23 20:29:05'),
(40, 7, 9, 'francais', 'Attribué', 'Batna', 'N°02/AT/DG/DAMP/DAM/2025', 'AVIS D’APPEL D’OFFRES NATIONAL OUVERT AVEC EXIGENCE DE CAPACITES MINIMALES N°02/AT/DG/DAMP/DAM/2025', NULL, 'Avis de manifestation', 'National', '2025-05-20', '2025-05-30', NULL, 'Fourniture de systèmes de protection contre la Foudre Directe et Indirecte (Paratonnerre - Parafoudre) et de Systèmes de Mise à la Terre, y compris la formation', NULL, 'En rédaction', '2025-05-23 20:32:32', '2025-05-23 20:32:32'),
(41, 7, 9, 'francais', 'Attribué', 'Béchar', 'N° 004/2025', 'Avis d\'Appel d\'Offres National Ouvert avec Exigence de Capacités Minimales N° 04/2025', NULL, 'Avis de manifestation', 'National', '2025-05-20', '2025-05-30', NULL, '« Conclusion de contrat d\'adhésion à commandes pour une durée d’une (01) année, renouvelable d’année en année et qui ne peut excéder trois (03) années pour travaux de maintenance et de développement de la canalisation pour le réseau FTTX »', NULL, 'Publiée', '2025-05-23 20:33:33', '2025-05-23 20:33:33'),
(42, 7, 9, 'francais', 'Attribué', 'Béchar', 'N° 005/2025', 'Avis d\'Appel d\'Offres National Ouvert avec Exigence de Capacités Minimales N° 05/2025', NULL, 'Avis de manifestation', 'National', '2025-05-20', '2025-05-30', NULL, 'renouvelable d’année en année et qui ne peut excéder trois (03) années pour travaux de maintenance et de développement de la canalisation pour le réseau FTTX »', NULL, 'Publiée', '2025-05-23 20:34:09', '2025-05-23 20:34:09'),
(43, 7, 9, 'francais', 'Attribué', 'Béchar', 'N° 006/2025', 'Avis d\'Appel d\'Offres National Ouvert avec Exigence de Capacités Minimales N66/2025', NULL, 'Avis de manifestation', 'National', '2025-05-20', '2025-05-30', NULL, 'renouvelable d’année en année et qui ne peut excéder trois (03) années pour travaux de maintenance et de développement de la canalisation pour le réseau FTTX »', NULL, 'Publiée', '2025-05-23 20:34:28', '2025-05-23 20:34:28'),
(44, 7, 9, 'francais', 'Attribué', 'Béchar', 'N°05/ANF/DG/DSI/2024', 'Avis d’appel d\'offres national ouvert avec exigences de capacités minimales N°05/ANF/DG/DSI/2024', NULL, 'Avis de consultation', 'National', '2024-06-23', '2025-05-23', NULL, 'L’acquisition et la mise en service d’un centre de données modulaire intelligent au profit de l’Agence Nationale des Fréquences.', NULL, 'Publiée', '2025-05-23 20:42:28', '2025-05-23 20:42:28'),
(45, 7, 9, 'francais', 'Attribué', 'Béchar', 'N°05/ANF/DG/DSI/2023', 'Avis d’appel d\'offres national ouvert avec exigences de capacités minimales N°05/ANF/DG/DSI/2023', NULL, 'Avis de consultation', 'National', '2023-08-07', '2025-05-23', NULL, 'L’acquisition et la mise en service d’un centre de données modulaire intelligent au profit de l’Agence Nationale des Fréquences.', NULL, 'Publiée', '2025-05-23 20:42:58', '2025-05-23 20:42:58'),
(46, 7, 10, 'francais', 'Infructueux', 'Bouira', 'N° 28/AT/DG/DAMP/DAM/2020', 'Cet appel à manifestation est publié pour garantir la transparence selon la législation qui régit le code des marchés AVIS D\'APPEL A MANIFESTATION D\'INTÉRÊT NATIONAL N° 28/AT/DG/DAMP/DAM/2020', NULL, 'Avis de manifestation', 'National', '2025-04-25', '2025-05-30', NULL, 'Avis d\'appel a manifestation d\'intérêt national destine aux TPE, PME/PMI, START-UP, entreprises crées dans le cadre de l’ANSEJ, CNAC ou ANGEM. Appel à manifestation pour candidature destiné à des activités pour des prestations liées à plusieurs activités de l’entreprise', NULL, 'Publiée', '2025-05-23 20:49:20', '2025-05-23 20:49:20');

-- --------------------------------------------------------

--
-- Structure de la table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(98, 'App\\Models\\User', 30, 'authToken', '21858d7d019479371036947901bfbd21655bd2c92152a236eb7a4424e95f7e9e', '[\"*\"]', '2025-05-17 10:42:14', NULL, '2025-05-17 07:59:13', '2025-05-17 10:42:14'),
(119, 'App\\Models\\User', 31, 'authToken', 'd1910093a5353e67d46bab5b2d13dc11c70dbdb3e5936f42ce50f3770de15651', '[\"*\"]', '2025-05-23 21:04:04', NULL, '2025-05-23 20:59:05', '2025-05-23 21:04:04');

-- --------------------------------------------------------

--
-- Structure de la table `secteurs`
--

CREATE TABLE `secteurs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `nom` varchar(255) NOT NULL,
  `abreviation` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `secteurs`
--

INSERT INTO `secteurs` (`id`, `logo`, `nom`, `abreviation`, `created_at`, `updated_at`) VALUES
(1, 'storage/logo/logo-ministere.png', 'Ministère de la Poste et des Télécommunications', 'MDPT', '2025-04-20 08:54:00', '2025-04-20 08:54:00'),
(2, 'storage/logo/logo-anf.png', 'Agence Nationale des Fréquences', 'ANF', '2025-04-20 08:54:00', '2025-05-23 10:31:23'),
(3, 'storage/logo/logo-poste.png', 'Algérie Poste', 'Algérie Poste', '2025-04-20 08:54:00', '2025-05-23 10:33:13'),
(4, 'storage/logo/logo-inptic.png', 'Institut National de la Poste et des Technologies de l\'Information et de la Communication', 'INPTIC', '2025-04-20 08:54:00', '2025-05-23 10:31:40'),
(5, 'storage/logo/logo-inttic.png', 'Ecole Nationale Supérieure des Télécommunications et des Technologies de l\'Information et de la Communication', 'INTTIC', '2025-04-20 08:54:00', '2025-05-23 10:32:06'),
(6, 'storage/logo/logo-gta.png', 'Le Groupe Télécom Algérie', 'GTA', '2025-04-20 08:54:00', '2025-05-23 10:32:45'),
(7, 'storage/logo/logo-at.png', 'Algérie Télécom', 'AT', '2025-04-20 08:54:00', '2025-04-20 08:54:00'),
(8, 'storage/logo/logo-mobilis.png', 'Mobilis', 'Mobilis', '2025-04-20 08:54:00', '2025-05-23 10:33:02'),
(9, 'storage/logo/logo-ats.png', 'Algérie Télécom Satellite', 'ATS', '2025-04-20 08:54:00', '2025-05-23 10:33:47'),
(10, 'storage/logo/logo-saticom.png', 'Société Algérienne de Technologie de l\'Information et de la Communication', 'SATICOM', '2025-04-20 08:54:00', '2025-05-23 10:34:17'),
(11, 'storage/logo/logo-comintal.png', 'Compagnie des infrastructures de télécom Algérie', 'COMINTAL', '2025-04-20 08:54:00', '2025-05-23 10:24:36'),
(12, 'storage/logo/logo-natp.png', 'Agence Nationale de Promotion & de Développement des Parcs Technologiques', 'ANPT', '2025-04-20 08:54:00', '2025-05-23 10:20:56'),
(13, 'storage/logo/logo-numirisation.png', 'Entreprise d\'Appui au Developpement Numérique', 'EADN', '2025-04-20 08:54:00', '2025-05-23 10:22:54'),
(14, 'storage/logo/logo-eci-tic.png', 'L\'Agence Nationale de Promotion et de Développement des Parcs Technologiques', 'ECI TIC', '2025-04-20 08:54:00', '2025-05-23 10:23:24'),
(15, 'storage/logo/logo-netbeopen.png', 'NetBeOpen Prime', 'NBOP', '2025-04-20 08:54:00', '2025-05-23 10:29:42'),
(16, 'storage/logo/logo-wb.png', 'WhiteBay Limited', 'WBL', '2025-04-20 08:54:00', '2025-04-20 08:54:00'),
(17, 'storage/logo/logo-ems.png', 'EMS CHAMPION POSTE ALGERIA', 'EMS', '2025-04-20 08:54:00', '2025-05-23 10:30:59'),
(20, 'storage/logo/3InGpFFAyD5Kqn2U3J6eVfWbdnnNsDNpu7nEooJx.jpg', 'Ooredoo', 'Ooredoo', '2025-05-23 10:18:19', '2025-05-23 10:18:19');

-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('bU4lrRDPifgbzlscnuMGeOuojLl9fTIXghJYmD1t', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNGlJcHdIVTdKZVkwdGpzQXlqVlhtd0lLQ2Qzd2FNcFhvZUJ3d1BZVyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDQ6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9lbWFpbC12ZXJpZmllZC1zdWNjZXNzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1745590339),
('SbtETWaNxNPwjVyqfAkzqzuMML6t5PlyGrcG7GCr', NULL, '127.0.0.1', 'PostmanRuntime/7.43.4', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTnFYSVNkQzFXUTY3c05TYlBwdlFsS3RKOUhFa1NvMVB6U3REQzdlbSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1747408862);

-- --------------------------------------------------------

--
-- Structure de la table `soumissions`
--

CREATE TABLE `soumissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `offre_id` bigint(20) UNSIGNED NOT NULL,
  `proposition` text DEFAULT NULL,
  `statut` enum('En attente','Acceptée','Rejetée') NOT NULL DEFAULT 'En attente',
  `date_soumission` timestamp NOT NULL DEFAULT current_timestamp(),
  `commentaire_admin` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `soumissions`
--

INSERT INTO `soumissions` (`id`, `user_id`, `offre_id`, `proposition`, `statut`, `date_soumission`, `commentaire_admin`, `created_at`, `updated_at`) VALUES
(25, 31, 14, 'detail', 'Acceptée', '2025-05-17 17:21:44', NULL, '2025-05-17 16:21:44', '2025-05-17 16:31:43'),
(26, 32, 14, NULL, 'Rejetée', '2025-05-21 14:14:16', NULL, '2025-05-21 13:14:16', '2025-05-21 13:56:41'),
(27, 32, 14, NULL, 'En attente', '2025-05-21 14:14:18', NULL, '2025-05-21 13:14:18', '2025-05-21 13:14:18'),
(28, 32, 25, NULL, 'En attente', '2025-05-23 21:53:41', NULL, '2025-05-23 20:53:41', '2025-05-23 20:53:41'),
(29, 31, 25, NULL, 'En attente', '2025-05-23 21:55:39', NULL, '2025-05-23 20:55:39', '2025-05-23 20:55:39'),
(30, 31, 16, NULL, 'En attente', '2025-05-23 22:00:13', NULL, '2025-05-23 21:00:13', '2025-05-23 21:00:13');

-- --------------------------------------------------------

--
-- Structure de la table `suggestions`
--

CREATE TABLE `suggestions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `suggestions`
--

INSERT INTO `suggestions` (`id`, `email`, `content`, `created_at`, `updated_at`) VALUES
(6, 'assia.kassab1234@gmail.com', 'Pouvez-vous ajouter une option pour enregistrer une soumission comme brouillon ? Parfois je n’ai pas tous les documents à la fois.', '2025-05-21 12:51:18', '2025-05-21 12:51:18'),
(7, 'selma@gmail.com', 'Un petit tuto rapide dès la première connexion serait utile pour comprendre comment fonctionne la plateforme.', '2025-05-21 12:52:30', '2025-05-21 12:52:30'),
(8, 'ahmed@gmail.com', 'J’adore le site, mais un mode sombre serait top pour les utilisateurs qui bossent tard.', '2025-05-21 12:52:57', '2025-05-21 12:52:57'),
(9, 'houda@gmail.com', 'J’aimerais avoir une option pour chatter ou envoyer un message à l’équipe SAFQATIC si j’ai une question sur une offre', '2025-05-21 12:53:59', '2025-05-21 12:53:59'),
(10, 'omar@gmail.com', 'Un système de tags pour les offres (ex : \'Urgent\', \'Nouveau\', \'Favori\') serait vraiment pratique', '2025-05-21 12:54:50', '2025-05-21 12:54:50'),
(11, 'nait@gmail.com', 'J’aimerais pouvoir filtrer les offres par date de fin, ça m’aiderait à mieux gérer mes priorités', '2025-05-21 12:55:23', '2025-05-21 12:55:23');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('en attente','actif','suspendu') NOT NULL DEFAULT 'en attente',
  `civilite` varchar(255) DEFAULT NULL,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `fonction` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) NOT NULL,
  `entreprise_id` bigint(20) UNSIGNED DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `status`, `civilite`, `nom`, `prenom`, `fonction`, `telephone`, `entreprise_id`, `email_verified_at`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'user@test.com', '$2y$12$cmJo2qsixFxx7.0SpXhPteDRN6qbA8S6D74qzmNG.A7hO/qdz26Q6', 'actif', 'Madame', 'User', 'Test', 'Directeur', '055555555', 1, '2025-04-20 08:54:00', NULL, '2025-04-20 08:54:00', '2025-04-20 19:03:52'),
(3, 'assia@gmail.com', '$2y$12$MrmW.5DmwLCpTRHM0Akd2ejBTuP4/0Mqxpm6XU1gZN.7b6gSVROmO', 'en attente', 'Madame', 'kassab', 'assia', 'Dev', '0548327362', 2, NULL, NULL, '2025-04-20 23:09:57', '2025-04-20 23:09:57'),
(4, 'tasnim@gmail.com', '$2y$12$nvvv8bADQwy9.4dq20k9G.uwjkC.lSsjDj7kfZUGvbX6pMEckAq46', 'en attente', 'Madame', 'Hazourli', 'Tasnim', 'Dev', '0542134543', 3, NULL, NULL, '2025-04-20 23:18:27', '2025-04-20 23:18:27'),
(12, 'ahmed@gmail.com', '$2y$12$HM0K2fBgFVfI9N8e9SawRO1O1nlBOk3lPXihFar2EtDlFWZ7IiLcS', 'actif', 'Monsieur', 'Aouani', 'Ahmed', 'Directeur', '0671209099', 2, '2025-04-25 09:15:36', NULL, '2025-04-25 09:14:42', '2025-04-25 09:15:36'),
(15, 'selma@gmail.com', '$2y$12$rLXcc7/lGXRELnaAx/kDIu1TY5Tb0jr0qvI9WqFoZXUefu5tAXJl2', 'actif', 'Madame', 'Larbi', 'Selma', 'IT', '0761293949', 29, '2025-04-25 13:12:19', NULL, '2025-04-25 13:11:55', '2025-04-25 13:12:19'),
(17, 'nait@gmail.com', '$2y$12$wO09qk688u9zWFuTUWWmGuG4v7mCK4wTuIhaHAtS4tc/oQ2xVGiw.', 'actif', 'Monsieur', 'Nait', 'Mohamed', 'Dev', '0676423409', 3, '2025-04-25 18:42:17', NULL, '2025-04-25 18:06:30', '2025-04-25 18:42:17'),
(18, 'houda@gmail.com', '$2y$12$/NpoQAK.KdLWA3msee23OO8KOPtfbKibB72a1C6e5MBHF.9l7HnaW', 'actif', 'Madame', 'Hamech', 'Houda', 'Directeur', '0654327888', 3, '2025-04-25 19:11:58', NULL, '2025-04-25 19:10:29', '2025-04-25 19:11:58'),
(19, 'omar@gmail.com', '$2y$12$QReAsqt1Bab7W3SOkRnQduyQqDzC76r4eSmUrI5WFfc9eYOYIm21W', 'actif', 'Monsieur', 'Benmad', 'Omar', 'IT', '0587657881', 1, '2025-04-26 08:00:58', NULL, '2025-04-26 08:00:11', '2025-04-26 08:00:58'),
(28, 'Linda@gmail.com', '$2y$12$Qvn91oYmXNv0M/4wdGMcweTxmP/hlzZ.bg9RPN3wWgqTrN69SV4Se', 'en attente', 'Madame', 'Kherouchi', 'Linda', 'Dev', '0752433182', 30, NULL, NULL, '2025-05-05 09:22:16', '2025-05-05 09:22:16'),
(29, 'kamel@gmail.com', '$2y$12$zHNBy9ML5SN446ll/hehfufQkq2fycGKrgGpVWFSY.ylo8YOPO5BW', 'en attente', 'Monsieur', 'Didouche', 'Kamel', 'Directeur', '0675543271', 2, NULL, NULL, '2025-05-05 09:27:41', '2025-05-05 09:27:41'),
(31, 'yumi.dz1234@gmail.com', '$2y$12$.TNGyFy.aSCd6LbLqtw8CegcsomWzstLpCDi5WQ4F/ckU3Wim0TBe', 'actif', 'Madame', 'Mbarek', 'Yamina', 'dev', '0566666666', 30, '2025-05-17 16:20:42', NULL, '2025-05-17 16:20:13', '2025-05-17 16:20:42'),
(32, 'louiza1234@gmail.com', '$2y$12$se6DM03c77COj.WKSvD33ugcdUoelC/3cPG7cdVEIGh39fkEe1YFC', 'actif', 'Madame', 'belarbi', 'louiza', 'Directeur', '0563636363', 29, '2025-05-21 12:45:16', NULL, '2025-05-21 12:20:24', '2025-05-23 20:23:49');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admins_email_unique` (`email`),
  ADD KEY `admins_secteur_id_foreign` (`secteur_id`);

--
-- Index pour la table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Index pour la table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Index pour la table `documents_offre`
--
ALTER TABLE `documents_offre`
  ADD PRIMARY KEY (`id`),
  ADD KEY `documents_offre_offre_id_foreign` (`offre_id`);

--
-- Index pour la table `document_soumissions`
--
ALTER TABLE `document_soumissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `document_soumissions_soumission_id_foreign` (`soumission_id`);

--
-- Index pour la table `entreprises`
--
ALTER TABLE `entreprises`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `entreprises_code_commerce_unique` (`code_commerce`),
  ADD UNIQUE KEY `entreprises_num_fiscal_unique` (`num_fiscal`),
  ADD UNIQUE KEY `entreprises_num_statistique_unique` (`num_statistique`),
  ADD UNIQUE KEY `entreprises_num_national_unique` (`num_national`);

--
-- Index pour la table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Index pour la table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `favorites_user_id_foreign` (`user_id`),
  ADD KEY `favorites_offre_id_foreign` (`offre_id`);

--
-- Index pour la table `historique_soumissions`
--
ALTER TABLE `historique_soumissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `historique_soumissions_soumission_id_foreign` (`soumission_id`),
  ADD KEY `historique_soumissions_admin_id_foreign` (`admin_id`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Index pour la table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `lots`
--
ALTER TABLE `lots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lots_offre_id_foreign` (`offre_id`);

--
-- Index pour la table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `notifications_custom`
--
ALTER TABLE `notifications_custom`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_custom_user_id_foreign` (`user_id`);

--
-- Index pour la table `offres`
--
ALTER TABLE `offres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `offres_numero_offre_unique` (`numero_offre`),
  ADD KEY `offres_secteur_id_foreign` (`secteur_id`),
  ADD KEY `offres_admin_id_foreign` (`admin_id`);

--
-- Index pour la table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Index pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Index pour la table `secteurs`
--
ALTER TABLE `secteurs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Index pour la table `soumissions`
--
ALTER TABLE `soumissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `soumissions_user_id_foreign` (`user_id`),
  ADD KEY `soumissions_offre_id_foreign` (`offre_id`);

--
-- Index pour la table `suggestions`
--
ALTER TABLE `suggestions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `suggestions_email_index` (`email`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_entreprise_id_foreign` (`entreprise_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `documents_offre`
--
ALTER TABLE `documents_offre`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT pour la table `document_soumissions`
--
ALTER TABLE `document_soumissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT pour la table `entreprises`
--
ALTER TABLE `entreprises`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT pour la table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `historique_soumissions`
--
ALTER TABLE `historique_soumissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT pour la table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `lots`
--
ALTER TABLE `lots`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT pour la table `notifications_custom`
--
ALTER TABLE `notifications_custom`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT pour la table `offres`
--
ALTER TABLE `offres`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT pour la table `secteurs`
--
ALTER TABLE `secteurs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT pour la table `soumissions`
--
ALTER TABLE `soumissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT pour la table `suggestions`
--
ALTER TABLE `suggestions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `admins_secteur_id_foreign` FOREIGN KEY (`secteur_id`) REFERENCES `secteurs` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `documents_offre`
--
ALTER TABLE `documents_offre`
  ADD CONSTRAINT `documents_offre_offre_id_foreign` FOREIGN KEY (`offre_id`) REFERENCES `offres` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `document_soumissions`
--
ALTER TABLE `document_soumissions`
  ADD CONSTRAINT `document_soumissions_soumission_id_foreign` FOREIGN KEY (`soumission_id`) REFERENCES `soumissions` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_offre_id_foreign` FOREIGN KEY (`offre_id`) REFERENCES `offres` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favorites_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `historique_soumissions`
--
ALTER TABLE `historique_soumissions`
  ADD CONSTRAINT `historique_soumissions_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `historique_soumissions_soumission_id_foreign` FOREIGN KEY (`soumission_id`) REFERENCES `soumissions` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `lots`
--
ALTER TABLE `lots`
  ADD CONSTRAINT `lots_offre_id_foreign` FOREIGN KEY (`offre_id`) REFERENCES `offres` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `notifications_custom`
--
ALTER TABLE `notifications_custom`
  ADD CONSTRAINT `notifications_custom_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `offres`
--
ALTER TABLE `offres`
  ADD CONSTRAINT `offres_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `offres_secteur_id_foreign` FOREIGN KEY (`secteur_id`) REFERENCES `secteurs` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `soumissions`
--
ALTER TABLE `soumissions`
  ADD CONSTRAINT `soumissions_offre_id_foreign` FOREIGN KEY (`offre_id`) REFERENCES `offres` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `soumissions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_entreprise_id_foreign` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
