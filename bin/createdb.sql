CREATE TABLE `domain` IF NOT EXITSTS (
    `id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `domain` varchar(64) NOT NULL,
    `cname` varchar(128) NOT NULL
);

CREATE TABLE `cname_tmpl` IF NOT EXITSTS (
    `vid` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `view_name` varchar(16) NOT NULL DEFAULT `其他`,
    `ip` varchar(32) NOT NULL,
    `query` int(10) NOT NULL DEFAULT `0`
);
