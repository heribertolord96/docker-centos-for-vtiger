CREATE DATABASE IF NOT EXISTS `vtiger8` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
-- Verifica si el usuario no existe y lo crea con privilegios
CREATE USER IF NOT EXISTS 'vtiger-owner'@'localhost';
CREATE USER IF NOT EXISTS 'vtiger-owner'@'127.0.0.1';
CREATE USER IF NOT EXISTS 'vtiger-owner'@'::1';
-- Crea passwords se usuario
SET PASSWORD FOR 'vtiger-owner'@'localhost' = PASSWORD('vtiger123');
SET PASSWORD FOR 'vtiger-owner'@'127.0.0.1' = PASSWORD('vtiger123');
SET PASSWORD FOR 'vtiger-owner'@'::1' = PASSWORD('vtiger123');
    -- asignar privilegios
GRANT ALL PRIVILEGES ON `vtiger8`.* TO 'vtiger-owner'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `vtiger8`.* TO 'vtiger-owner'@'127.0.0.1' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `vtiger8`.* TO 'vtiger-owner'@'::1' WITH GRANT OPTION ;
    -- mostrar privilegios asignados
SHOW GRANTS FOR 'vtiger-owner'@'localhost';
SHOW GRANTS FOR 'vtiger-owner'@'127.0.0.1';
SHOW GRANTS FOR 'vtiger-owner'@'::1';

-- allow from any host 
CREATE USER IF NOT EXISTS 'vtiger-owner'@'%';
SET PASSWORD FOR 'vtiger-owner'@'%' = PASSWORD('vtiger123');
GRANT ALL PRIVILEGES ON `vtiger8`.* TO 'vtiger-owner'@'%' WITH GRANT OPTION ;
FLUSH PRIVILEGES;

-- set global mode execute one time
SET GLOBAL sql_mode = 'ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';