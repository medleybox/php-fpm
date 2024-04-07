<?php

$major = 8;
$minor = 3;

$url = 'https://www.php.net/releases/active';
$latest = file_get_contents($url);
$json = json_decode($latest, true);

$version = $json[$major]["${major}.${minor}"]["version"];
echo $version;